#!/usr/bin/env bash
# =============================================================
# test_3.sh — cadena de bajada + validacion JIT del test_3,
# el del dialecto propio sstr (Strassen, 64x64).
# Uso:  bash test_3.sh
#       SSTR_OPT=/ruta/a/sstr-opt bash test_3.sh
# Construye sstr-opt si hace falta y genera en out/test_3/ los niveles
# 00b (sstr-expand), 00c (bufferizado) y 01..08.
# =============================================================
set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER="${MLIR_RUNNER:-mlir-cpu-runner-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
SSTR_OPT="${SSTR_OPT:-src/test_3/dialect/build/sstr-opt}"
OUT="out"
TEST="src/test_3"
DEST="$OUT/test_3"
mkdir -p "$DEST"

if [ ! -x "$SSTR_OPT" ]; then
  echo "== construyendo el dialecto propio (sstr-opt) =="
  bash src/test_3/dialect/build.sh
fi

echo "========== test_3 (dialecto sstr, Strassen 64x64) =========="

# 0a: entrada.
cp "$TEST/01_matmul_sstr.mlir" "$DEST/01_matmul_sstr.mlir"

# 0b: kernel SIN @main (el driver queda en el archivo).
awk 'BEGIN{cut=0} /^\/\/ DRIVER \(invocación\)/{cut=1} !cut{print}' \
  "$TEST/01_matmul_sstr.mlir" > "$DEST/_kernel.mlir"

# 0c: dialecto propio -> sstr-expand (Strassen) -> bufferizar.
echo "  [0c] sstr-expand (Strassen) -> $DEST/00b_sstr_expand.mlir"
"$SSTR_OPT" "$DEST/_kernel.mlir" -o "$DEST/00b_sstr_expand.mlir"
echo "  [0c] one-shot-bufferize (+fronteras + out-params) -> $DEST/00c_sstr_buffered.mlir"
"$MLIR_OPT" "$DEST/00b_sstr_expand.mlir" \
  --one-shot-bufferize='bufferize-function-boundaries=true function-boundary-type-conversion=identity-layout-map' \
  --buffer-deallocation \
  --buffer-results-to-out-params \
  -o "$DEST/00c_sstr_buffered.mlir"

# 1: linalg -> affine.
echo "  [1/8] B1: linalg->affine -> $DEST/02_affine.mlir"
"$MLIR_OPT" "$DEST/00c_sstr_buffered.mlir" \
  --linalg-generalize-named-ops \
  --convert-linalg-to-affine-loops \
  -o "$DEST/02_affine.mlir"

# 2: B2 — fusion de bucles.
echo "  [2/8] B2: affine-loop-fusion -> $DEST/03_fused.mlir"
"$MLIR_OPT" "$DEST/02_affine.mlir" \
  --affine-loop-fusion='fusion-maximal=1' \
  -o "$DEST/03_fused.mlir"

# 3: affine -> scf.
echo "  [3/8] B1: affine->scf -> $DEST/04_scf.mlir"
"$MLIR_OPT" "$DEST/03_fused.mlir" --lower-affine -o "$DEST/04_scf.mlir"

# 4: scf -> cf.
echo "  [4/8] B1: scf->cf -> $DEST/05_cf.mlir"
"$MLIR_OPT" "$DEST/04_scf.mlir" --convert-scf-to-cf -o "$DEST/05_cf.mlir"

# 5: cf -> llvm dialect.
echo "  [5/8] B1: final -> llvm dialect -> $DEST/06_llvm.mlir"
"$MLIR_OPT" "$DEST/05_cf.mlir" \
  --expand-strided-metadata \
  --finalize-memref-to-llvm \
  --convert-arith-to-llvm \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts \
  -o "$DEST/06_llvm.mlir"

# 6: B2 bonus — unroll.
echo "  [6/8] B2 bonus: fusion + unroll -> $DEST/07_unrolled.mlir"
"$MLIR_OPT" "$DEST/02_affine.mlir" \
  --affine-loop-fusion='fusion-maximal=1' \
  --affine-loop-unroll='unroll-full=1' \
  -o "$DEST/07_unrolled.mlir"

# 7: camino clasico (g++) contra el que valida el JIT.
echo "  [7/8] camino clasico g++"
g++ -O2 -Wall "$TEST/main.cpp" src/mm_naive.cpp src/mm_strassen.cpp \
  -I src -o "$DEST/matmul_c"
"$DEST/matmul_c"

# 8: ejecucion JIT (el driver pasa de nuevo por sstr-opt + bufferize).
echo "  [8/8] ejecucion JIT -> $DEST/08_run_llvm.mlir"
"$SSTR_OPT" "$TEST/01_matmul_sstr.mlir" -o "$DEST/00d_sstr_run_exp.mlir"
"$MLIR_OPT" "$DEST/00d_sstr_run_exp.mlir" \
  --one-shot-bufferize='bufferize-function-boundaries=true function-boundary-type-conversion=identity-layout-map' \
  --buffer-deallocation \
  --buffer-results-to-out-params \
  -o "$DEST/00c_sstr_run.mlir"
"$MLIR_OPT" "$DEST/00c_sstr_run.mlir" \
  --convert-linalg-to-loops \
  --convert-scf-to-cf \
  --convert-func-to-llvm \
  --convert-arith-to-llvm \
  --expand-strided-metadata \
  --finalize-memref-to-llvm \
  --reconcile-unrealized-casts \
  -o "$DEST/08_run_llvm.mlir"

echo -n "  resultado (>0 fallo / 0 correcto): "
"$MLIR_RUNNER" "$DEST/08_run_llvm.mlir" -e main -entry-point-result=i32 \
  -shared-libs="$MLIR_RUNNER_LIBS"
echo ""

echo "Resumen de optimizaciones: affine.for en 02 = $(grep -c 'affine.for' "$DEST/02_affine.mlir") | en 03 = $(grep -c 'affine.for' "$DEST/03_fused.mlir") | en 07 = $(grep -c 'affine.for' "$DEST/07_unrolled.mlir")"