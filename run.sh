#!/usr/bin/env bash
# =============================================================
# run.sh — Reproduce el pipeline completo del proyecto B1+B2.
# Uso:  bash run.sh [test_1|test_2|all]   (default: all)
#       MLIR_OPT=/ruta/a/mlir-opt-18 bash run.sh  (binario alterno)
#
# Por cada test (test_1: 3x4x5, test_2: 8x16x32) se regenera:
#   out/<test>/0X_*.mlir     la cadena linalg->affine->scf->cf->llvm
#   out/<test>/07_unrolled   fusion + unroll (B2)
#   out/<test>/matmul_c      camino clasico (gcc)
#   out/<test>/10_run_llvm   ejecucion del matmul via JIT
# =============================================================
set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER="${MLIR_RUNNER:-mlir-cpu-runner-18}"
OUT="out"

# El parametro decide que tests procesar.
TARGET="${1:-all}"
if [ "$TARGET" = "all" ]; then
  TESTS="src/test_1 src/test_2"
else
  TESTS="src/$TARGET"
fi

process_test() {
  local TEST="$1"
  local INPUT="$TEST/01_matmul_linalg.mlir"
  local DEST="$OUT/${TEST#src/}"

  # Etapa 0: copia de entrada.
  local STAGE00="$DEST/01_matmul_linalg.mlir"
  local KERNEL="$DEST/_kernel.mlir"
  local STAGE02="$DEST/02_affine.mlir"
  local STAGE03="$DEST/03_fused.mlir"
  local STAGE04="$DEST/04_scf.mlir"
  local STAGE05="$DEST/05_cf.mlir"
  local STAGE06="$DEST/06_llvm.mlir"
  local STAGE07="$DEST/07_unrolled.mlir"

  echo "================ $TEST ================"
  mkdir -p "$DEST"

  echo "  [0/7] entrada linalg -> $STAGE00"
  cp "$INPUT" "$STAGE00"

  echo "  [A]  camino clasico (gcc): $TEST/matmul.c"
  gcc -O2 -Wall "$TEST/matmul.c" -o "$DEST/matmul_c"
  "$DEST/matmul_c"

  echo "  [0b] kernel sin @main -> $KERNEL"
  awk 'BEGIN{cut=0} /^\/\/ DRIVER \(invocación\)/{cut=1} !cut{print}' "$INPUT" > "$KERNEL"

  echo "  [1/7] lowering linalg->affine -> $STAGE02"
  "$MLIR_OPT" "$KERNEL" \
    --linalg-generalize-named-ops \
    --convert-linalg-to-affine-loops \
    -o "$STAGE02"

  echo "  [2/7] B2: affine-loop-fusion -> $STAGE03"
  "$MLIR_OPT" "$STAGE02" --affine-loop-fusion='fusion-maximal=1' -o "$STAGE03"

  echo "  [3/7] B1: affine -> scf -> $STAGE04"
  "$MLIR_OPT" "$STAGE03" --lower-affine -o "$STAGE04"

  echo "  [4/7] B1: scf -> cf -> $STAGE05"
  "$MLIR_OPT" "$STAGE04" --convert-scf-to-cf -o "$STAGE05"

  echo "  [5/7] B1: final -> llvm dialect -> $STAGE06"
  "$MLIR_OPT" "$STAGE05" \
    --finalize-memref-to-llvm \
    --convert-arith-to-llvm \
    --convert-func-to-llvm \
    --reconcile-unrealized-casts \
    -o "$STAGE06"

  echo "  [6/7] B2 bonus: affine-loop-unroll -> $STAGE07"
  "$MLIR_OPT" "$STAGE02" \
    --affine-loop-fusion='fusion-maximal=1' \
    --affine-loop-unroll='unroll-full=1' \
    -o "$STAGE07"

  echo "  [7/7] ejecucion JIT del matmul:"
  "$MLIR_OPT" "$INPUT" \
    --convert-linalg-to-loops \
    --convert-scf-to-cf \
    --convert-func-to-llvm \
    --convert-arith-to-llvm \
    --finalize-memref-to-llvm \
    --reconcile-unrealized-casts \
    -o "$DEST/10_run_llvm.mlir"

  echo -n "  resultado (>0 fallo / 0 correcto): "
  "$MLIR_RUNNER" "$DEST/10_run_llvm.mlir" -e main -entry-point-result=i32
  echo ""
}

for T in $TESTS; do
  process_test "$T"
done

echo "Listo. Resumen por test (fusion 02 vs 03, unroll 02 vs 07):"
for T in $TESTS; do
  D="${OUT}/${T#src/}"
  echo "  ${T#src/}: affine.for en 02 = $(grep -c 'affine.for' "$D/02_affine.mlir") | en 03 = $(grep -c 'affine.for' "$D/03_fused.mlir") | en 07 = $(grep -c 'affine.for' "$D/07_unrolled.mlir")"
done
ls -d out/*/