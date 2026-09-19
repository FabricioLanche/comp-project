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
  TESTS="src/test_1 src/test_2 src/test_3"
else
  TESTS="src/$TARGET"
fi

process_test() {
  local TEST="$1"
  local INPUT="$TEST/01_matmul_linalg.mlir"
  local DEST="$OUT/${TEST#src/}"
  mkdir -p "$DEST"

  # Etapa 0: copia de entrada.
  local STAGE00="$DEST/01_matmul_linalg.mlir"
  local KERNEL="$DEST/_kernel.mlir"
  local STAGE02="$DEST/02_affine.mlir"
  local STAGE03="$DEST/03_fused.mlir"
  local STAGE04="$DEST/04_scf.mlir"
  local STAGE05="$DEST/05_cf.mlir"
  local STAGE06="$DEST/06_llvm.mlir"
  local STAGE07="$DEST/07_unrolled.mlir"

  # max 0c: entrada linalg completa.
  local STAGE00="$DEST/01_matmul_linalg.mlir"
  local INPUT="$TEST/01_matmul_linalg.mlir"

  echo "================ $TEST ================"
  echo "  [0c] entrada linalg -> $STAGE00"
  cp "$INPUT" "$STAGE00"

  # 0b: kernel SIN @main (driver invocación vive en el archivo completo).
  local KERNEL="$DEST/_kernel.mlir"
  echo "  [0b] kernel sin @main -> $KERNEL"
  awk 'BEGIN{cut=0} /^\/\/ DRIVER \(invocación\)/{cut=1} !cut{print}' "$INPUT" > "$KERNEL"

  # 1: linalg->affine (baja un nivel de representación; B1).
  local STAGE02="$DEST/02_affine.mlir"
  echo "  [1/7] B1: linalg->affine -> $STAGE02"
  "$MLIR_OPT" "$KERNEL" \
    --linalg-generalize-named-ops \
    --convert-linalg-to-affine-loops \
    -o "$STAGE02"

  # 2: B2 — fusión de bucles (aplicamos una optimización; B2).
  local STAGE03="$DEST/03_fused.mlir"
  echo "  [2/7] B2: affine-loop-fusion -> $STAGE03"
  "$MLIR_OPT" "$STAGE02" \
    --affine-loop-fusion='fusion-maximal=1' \
    -o "$STAGE03"

  # 3: affine->scf (baja un nivel; B1).
  local STAGE04="$DEST/04_scf.mlir"
  echo "  [3/7] B1: affine->scf -> $STAGE04"
  "$MLIR_OPT" "$STAGE03" --lower-affine -o "$STAGE04"

  # 4: scf->cf (baja un nivel; B1).
  local STAGE05="$DEST/05_cf.mlir"
  echo "  [4/7] B1: scf->cf -> $STAGE05"
  "$MLIR_OPT" "$STAGE04" --convert-scf-to-cf -o "$STAGE05"

  # 5: cf -> llvm dialect (último nivel que vemos antes del machine code).
  local STAGE06="$DEST/06_llvm.mlir"
  echo "  [5/7] B1: final -> llvm dialect -> $STAGE06"
  "$MLIR_OPT" "$STAGE05" \
    --finalize-memref-to-llvm \
    --convert-arith-to-llvm \
    --convert-func-to-llvm \
    --reconcile-unrealized-casts \
    -o "$STAGE06"

  # 6: B2 bonus — unroll (aplicamos otra optimización; B2).
  local STAGE07="$DEST/07_unrolled.mlir"
  echo "  [6/7] B2 bonus: affine-loop-unroll -> $STAGE07"
  "$MLIR_OPT" "$STAGE02" \
    --affine-loop-fusion='fusion-maximal=1' \
    --affine-loop-unroll='unroll-full=1' \
    -o "$STAGE07"

  # 7a — [RUTA A] super-vectorize (best effort, NO fatal).
  #   MLIR 18.1.3 de Ubuntu es CAPAZ de super-vectorizar, pero el kernel
  #   matmul 3x4x5 (k=4) no siempre cumple las condiciones del analyzer.
  #   Dejar el resultado (IR) o el error es evidencia; nunca abortamos.
  local STAGE08="$DEST/08_supervec.mlir"
  local ERR08="$DEST/08_vector_err.txt"
  echo "  [7a/7] RUTA A: affine-super-vectorize (best effort) -> $STAGE08"
  if "$MLIR_OPT" "$STAGE02" \
       --affine-super-vectorize='vectorize-reductions=1' \
       -o "$STAGE08" 2> "$ERR08"; then
    echo "         ok: genero IR vectorizado (revisar vector.*)"
  else
    echo "         no pudo super-vectorizar; dejo la evidencia en $ERR08"
    cp "$STAGE02" "$STAGE08"   # conservamos el affine; el error queda aparte.
  fi

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

  # 7: [RUTA A] super-vectorize, BEST EFFORT (evidencia, no fatal).
  #   El pass de super-vectorización de MLIR 18.1.3 suele exigir tamaños
  #   de bucle "amigables" para el análisis; con k=16 (test_3 e incluso
  #   test_2 k=16): intentamos. Exito -> 08_vector_vec.mlir; fallo ->
  #   el archivo de error queda como evidencia sin abortar (B2/B1: no
  #   toda transformacion es siempre aplicable, y eso es resultado valido).
  local STAGE08="$DEST/08_supervec.mlir"
  echo "  [7/8] RUTA A: affine-super-vectorize (best effort) -> $STAGE08"
  if "$MLIR_OPT" "$STAGE02" \
       --affine-super-vectorize='vectorize-reductions=1' \
       -o "$STAGE08" 2> "$DEST/08_supervec_error.txt"; then
    echo "         ok: genero IR vectorizado (revisar vector.*)"
  else
    echo "         aviso: super-vectorize NO pudo; evidencia guardada en:"
    echo "           $DEST/08_supervec_error.txt"
    cp "$STAGE02" "$STAGE08"   # conservamos affine; el error queda aparte.
  fi

  echo "  [8/8] ejecucion JIT del matmul:"
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