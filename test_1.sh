#!/usr/bin/env bash
# =============================================================
# test_1.sh — cadena de bajada + validacion JIT del test_1.
# Matriz fija 3x4 x 4x5, linalg directo sobre buffers.
# Uso:  bash test_1.sh
#       MLIR_OPT=/ruta/a/mlir-opt-18 bash test_1.sh
# Genera en out/test_1/ los niveles 01..08 y ejecuta la validacion.
# =============================================================
set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER="${MLIR_RUNNER:-mlir-cpu-runner-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
OUT="out"
TEST="src/test_1"
DEST="$OUT/test_1"
mkdir -p "$DEST"

echo "========== test_1 (3x4x5) =========="

# 0a: entrada.
cp "$TEST/01_matmul_linalg.mlir" "$DEST/01_matmul_linalg.mlir"

# 0b: kernel SIN @main (el driver queda en el archivo).
awk 'BEGIN{cut=0} /^\/\/ DRIVER \(invocación\)/{cut=1} !cut{print}' \
  "$TEST/01_matmul_linalg.mlir" > "$DEST/_kernel.mlir"

# 1: linalg -> affine.
echo "  [1/8] B1: linalg->affine -> $DEST/02_affine.mlir"
"$MLIR_OPT" "$DEST/_kernel.mlir" \
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
g++ -O2 -Wall "$TEST/main.cpp" src/mm_naive.cpp -I src -o "$DEST/matmul_c"
"$DEST/matmul_c"

# 8: ejecucion JIT.
echo "  [8/8] ejecucion JIT -> $DEST/08_run_llvm.mlir"
"$MLIR_OPT" "$TEST/01_matmul_linalg.mlir" \
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