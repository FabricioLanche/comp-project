set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
OUT="out"
TEST="src/test_1"
DEST="$OUT/test_1"
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT
mkdir -p "$DEST"

echo "========== test_1 (3x4x5) =========="

# 0a: entrada (definicion de la operacion).
cp "$TEST/01_matmul_linalg.mlir" "$DEST/01_matmul_linalg.mlir"

# Los niveles 1..7 se estudian sobre la definicion, sin driver.
KERNEL="$TEST/01_matmul_linalg.mlir"

# 1: linalg -> affine.
echo "  [1/8] B1: linalg->affine -> $DEST/02_affine.mlir"
"$MLIR_OPT" "$KERNEL" \
  --linalg-generalize-named-ops \
  --convert-linalg-to-affine-loops \
  -o "$DEST/02_affine.mlir"

# 2: B2 — fusion de bucles (variante documentada, NO sigue el camino).
echo "  [2/8] B2: affine-loop-fusion -> $DEST/02_opt_fused.mlir (doc)"
"$MLIR_OPT" "$DEST/02_affine.mlir" \
  --affine-loop-fusion='fusion-maximal=1' \
  -o "$DEST/02_opt_fused.mlir"

# 3: affine -> scf (el camino principal sigue sin optimizaciones).
echo "  [3/8] B1: affine->scf -> $DEST/03_scf.mlir"
"$MLIR_OPT" "$DEST/02_affine.mlir" --lower-affine -o "$DEST/03_scf.mlir"

# 4: scf -> cf.
echo "  [4/8] B1: scf->cf -> $DEST/04_cf.mlir"
"$MLIR_OPT" "$DEST/03_scf.mlir" --convert-scf-to-cf -o "$DEST/04_cf.mlir"

# 5: cf -> llvm dialect.
echo "  [5/8] B1: final -> llvm dialect -> $DEST/05_llvm.mlir"
"$MLIR_OPT" "$DEST/04_cf.mlir" \
  --expand-strided-metadata \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts \
  -o "$DEST/05_llvm.mlir"

# 6: B2 bonus — unroll (variante documentada, NO sigue el camino).
echo "  [6/8] B2 bonus: fusion + unroll -> $DEST/02_opt_unrolled.mlir (doc)"
"$MLIR_OPT" "$DEST/02_affine.mlir" \
  --affine-loop-fusion='fusion-maximal=1' \
  --affine-loop-unroll='unroll-full=1' \
  -o "$DEST/02_opt_unrolled.mlir"

# 7: camino clasico (g++) contra el que se valida el resultado.
echo "  [7/8] camino clasico g++"
g++ -O2 -Wall "$TEST/main.cpp" src/mm_naive.cpp -I src -o "$DEST/matmul_c"
"$DEST/matmul_c"

# 8: bajada a ejecutable nativo y ejecucion (como en C). El modulo
#     ejecutable se arma concatenando la definicion y el driver.
echo "  [8/8] ejecutable nativo -> $DEST/matmul_mlir"
cat "$TEST/01_matmul_linalg.mlir" "$TEST/main.mlir" > "$TMPD/01_full.mlir"
"$MLIR_OPT" "$TMPD/01_full.mlir" \
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