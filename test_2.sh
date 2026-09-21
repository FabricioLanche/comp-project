set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
SSTR_OPT="${SSTR_OPT:-src/test_2/dialect/build/sstr-opt}"
OUT="out"
TEST="src/test_2"
DEST="$OUT/test_2"
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT
mkdir -p "$DEST"

if [ ! -x "$SSTR_OPT" ]; then
  echo "== construyendo el dialecto propio (sstr-opt) =="
  bash src/test_2/dialect/build.sh
fi

echo "========== test_2 (dialecto sstr, Strassen 64x64) =========="

# 0a: entrada (definicion de la operacion del dialecto sstr).
cp "$TEST/01_matmul_sstr.mlir" "$DEST/01_matmul_sstr.mlir"

# Los niveles 0c..5 se estudian sobre la definicion, sin driver.
KERNEL="$TEST/01_matmul_sstr.mlir"

# 0c: dialecto propio -> sstr-expand (Strassen) -> bufferizar.
echo "  [0c] sstr-expand (Strassen) -> $DEST/00b_sstr_expand.mlir"
"$SSTR_OPT" "$KERNEL" -o "$DEST/00b_sstr_expand.mlir"
echo "  [0c] one-shot-bufferize (+fronteras + out-params) -> $DEST/00c_sstr_buffered.mlir"
"$MLIR_OPT" "$DEST/00b_sstr_expand.mlir" \
  --one-shot-bufferize='bufferize-function-boundaries=true function-boundary-type-conversion=identity-layout-map' \
  --buffer-deallocation \
  --buffer-results-to-out-params \
  -o "$DEST/00c_sstr_buffered.mlir"

# 1: linalg -> affine.
echo "  [1/6] B1: linalg->affine -> $DEST/02_affine.mlir"
"$MLIR_OPT" "$DEST/00c_sstr_buffered.mlir" \
  --linalg-generalize-named-ops \
  --convert-linalg-to-affine-loops \
  -o "$DEST/02_affine.mlir"

# 2: affine -> scf (el camino sigue sin optimizaciones).
echo "  [2/6] B1: affine->scf -> $DEST/03_scf.mlir"
"$MLIR_OPT" "$DEST/02_affine.mlir" --lower-affine -o "$DEST/03_scf.mlir"

# 3: scf -> cf.
echo "  [3/6] B1: scf->cf -> $DEST/04_cf.mlir"
"$MLIR_OPT" "$DEST/03_scf.mlir" --convert-scf-to-cf -o "$DEST/04_cf.mlir"

# 4: cf -> llvm dialect.
echo "  [4/6] B1: final -> llvm dialect -> $DEST/05_llvm.mlir"
"$MLIR_OPT" "$DEST/04_cf.mlir" \
  --expand-strided-metadata \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts \
  -o "$DEST/05_llvm.mlir"

# 5: camino clasico (g++) contra el que se valida el resultado.
echo "  [5/6] camino clasico g++"
g++ -O2 -Wall "$TEST/main.cpp" src/mm_naive.cpp src/mm_strassen.cpp \
  -I src -o "$DEST/matmul_c"
"$DEST/matmul_c"

# 6: modulo ejecutable = definicion (01) + invocacion (main.mlir),
#     pasado por el dialecto propio, bufferizado y bajado a nativo.
echo "  [6/6] ejecutable nativo -> $DEST/matmul_mlir"
cat "$TEST/01_matmul_sstr.mlir" "$TEST/main.mlir" > "$TMPD/01_full.mlir"
"$SSTR_OPT" "$TMPD/01_full.mlir" -o "$TMPD/run_exp.mlir"
"$MLIR_OPT" "$TMPD/run_exp.mlir" \
  --one-shot-bufferize='bufferize-function-boundaries=true function-boundary-type-conversion=identity-layout-map' \
  --buffer-deallocation \
  --buffer-results-to-out-params \
  -o "$TMPD/run_buf.mlir"
"$MLIR_OPT" "$TMPD/run_buf.mlir" \
  --convert-linalg-to-loops \
  --convert-scf-to-cf \
  --convert-func-to-llvm \
  --convert-arith-to-llvm \
  --expand-strided-metadata \
  --finalize-memref-to-llvm \
  --reconcile-unrealized-casts \
  -o "$TMPD/run.mlir"
mlir-translate-18 --mlir-to-llvmir "$TMPD/run.mlir" -o "$TMPD/run.ll"
llc-18 "$TMPD/run.ll" -filetype=obj -o "$TMPD/run.o"
cc "$TMPD/run.o" -o "$DEST/matmul_mlir" \
  -L"$(dirname "$MLIR_RUNNER_LIBS")" -lmlir_c_runner_utils \
  -Wl,-rpath,"$(dirname "$MLIR_RUNNER_LIBS")"

set +e
"$DEST/matmul_mlir"
RC=$?
set -e
echo "  resultado (>0 fallo / 0 correcto): $RC"