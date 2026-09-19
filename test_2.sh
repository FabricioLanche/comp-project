#!/usr/bin/env bash
# =============================================================
# test_2.sh — cadena de bajada + validacion JIT + cronometro del
# test_2 (tamano variable, plantilla .mlir.in).
#
# Uso:  bash test_2.sh                (serie por defecto 128 256 512)
#       bash test_2.sh 256            (una sola dimension)
#       bash test_2.sh 256 512        (varias dimensiones + tabla)
#       BENCH_ITERS=10 bash test_2.sh (repeticiones del cronometro)
#
# Sin argumentos genera la tabla de tiempos en la terminal con la serie
# por defecto. Con argumentos toma esas dimensiones como serie.
# =============================================================
set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER="${MLIR_RUNNER:-mlir-cpu-runner-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
LIBDIR="$(dirname "$MLIR_RUNNER_LIBS")"
OUT="out"
DEST="$OUT/test_2"
ITERS="${BENCH_ITERS:-20}"

if [ "$#" -eq 0 ]; then
  SIZES=(128 256 512)
else
  SIZES=("$@")
fi

run_pipeline() {
  local S="$1"
  local SIZE_LAST=$((S - 1))
  local SIZE_HALF=$((S / 2))
  sed "s/__SIZE__/$S/g; s/__LAST__/$SIZE_LAST/g; s/__HALF__/$SIZE_HALF/g" \
    "$TEST/01_matmul_linalg.mlir.in" > "$DEST/01_matmul_linalg.mlir"

  awk 'BEGIN{cut=0} /^\/\/ DRIVER \(invocación\)/{cut=1} !cut{print}' \
    "$DEST/01_matmul_linalg.mlir" > "$DEST/_kernel.mlir"

  "$MLIR_OPT" "$DEST/_kernel.mlir" \
    --linalg-generalize-named-ops \
    --convert-linalg-to-affine-loops \
    -o "$DEST/02_affine.mlir"

  "$MLIR_OPT" "$DEST/02_affine.mlir" --affine-loop-fusion='fusion-maximal=1' \
    -o "$DEST/03_fused.mlir"

  "$MLIR_OPT" "$DEST/03_fused.mlir" --lower-affine -o "$DEST/04_scf.mlir"

  "$MLIR_OPT" "$DEST/04_scf.mlir" --convert-scf-to-cf -o "$DEST/05_cf.mlir"

  "$MLIR_OPT" "$DEST/05_cf.mlir" \
    --expand-strided-metadata \
    --finalize-memref-to-llvm \
    --convert-arith-to-llvm \
    --convert-func-to-llvm \
    --reconcile-unrealized-casts \
    -o "$DEST/06_llvm.mlir"

  "$MLIR_OPT" "$DEST/02_affine.mlir" \
    --affine-loop-fusion='fusion-maximal=1' \
    --affine-loop-unroll='unroll-full=1' \
    -o "$DEST/07_unrolled.mlir"

  "$MLIR_OPT" "$DEST/01_matmul_linalg.mlir" \
    --convert-linalg-to-loops \
    --convert-scf-to-cf \
    --convert-func-to-llvm \
    --convert-arith-to-llvm \
    --expand-strided-metadata \
    --finalize-memref-to-llvm \
    --reconcile-unrealized-casts \
    -o "$DEST/08_run_llvm.mlir"
}

echo "========== test_2 (SIZE x SIZE x SIZE, serie ${SIZES[*]}) =========="
TEST="src/test_2"

echo ""
echo "Tabla baseline   (g++ estandar vs MLIR estandar)   ${ITERS} corridas por tamano"
echo "  ambos caminos bajados a ejecutable nativo; tiempos totales en ms"
printf "  %-8s %-16s %-16s %-14s\n" "SIZE" "gcc (ms)" "mlir (ms)" "mlir/gcc"
printf "  %-8s %-16s %-16s %-14s\n" "----" "---------" "----------" "--------"

mkdir -p "$DEST/09_bench"
for S in "${SIZES[@]}"; do
  echo "  -> preparando pipeline con SIZE=$S ..."
  run_pipeline "$S"

  g++ -O2 -Wall -DSIZE="$S" "$TEST/main.cpp" src/mm_naive.cpp -I src \
    -o "$DEST/matmul_c"
  "$DEST/matmul_c" >/dev/null

  "$MLIR_RUNNER" "$DEST/08_run_llvm.mlir" -e main -entry-point-result=i32 \
    -shared-libs="$MLIR_RUNNER_LIBS" >/dev/null
  echo "     JIT correcto para SIZE=$S"

  GCC_STD="$DEST/09_bench/gcc_${S}"
  MLIR_STD="$DEST/09_bench/mlir_${S}"

  g++ -O0 -DSIZE="$S" "$TEST/main.cpp" src/mm_naive.cpp -I src -o "$GCC_STD"
  mlir-translate-18 --mlir-to-llvmir "$DEST/08_run_llvm.mlir" -o "$DEST/09_bench/run_${S}.ll"
  llc-18 "$DEST/09_bench/run_${S}.ll" -filetype=obj -o "$DEST/09_bench/run_${S}.o"
  cc "$DEST/09_bench/run_${S}.o" -o "$MLIR_STD" \
    -L"$LIBDIR" -lmlir_c_runner_utils -Wl,-rpath,"$LIBDIR"

  S0=$(date +%s%N)
  for i in $(seq 1 "$ITERS"); do "$GCC_STD" >/dev/null 2>&1; done
  S1=$(date +%s%N)
  MS_GCC=$(( (S1 - S0) / 1000000 ))

  S0=$(date +%s%N)
  for i in $(seq 1 "$ITERS"); do "$MLIR_STD" >/dev/null 2>&1; done
  S1=$(date +%s%N)
  MS_MLIR=$(( (S1 - S0) / 1000000 ))

  RATIO=$(awk -v a="$MS_GCC" -v b="$MS_MLIR" 'BEGIN { if (a > 0) printf "%.2f", b/a; else print "--" }')
  printf "  %-8s %-16s %-16s %-14s\n" "$S" "$MS_GCC" "$MS_MLIR" "$RATIO"
done

echo "  (ejecutables e IR intermedios en $DEST/09_bench/)"
echo ""
echo "Resumen de optimizaciones (SIZE=$S): affine.for en 02 = $(grep -c 'affine.for' "$DEST/02_affine.mlir") | en 03 = $(grep -c 'affine.for' "$DEST/03_fused.mlir") | en 07 = $(grep -c 'affine.for' "$DEST/07_unrolled.mlir")"