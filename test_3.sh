set -euo pipefail

MLIR_OPT="${MLIR_OPT:-mlir-opt-18}"
MLIR_RUNNER_LIBS="${MLIR_RUNNER_LIBS:-/usr/lib/llvm-18/lib/libmlir_c_runner_utils.so}"
SSTR_OPT="${SSTR_OPT:-src/test_2/dialect/build/sstr-opt}"
LIBDIR="$(dirname "$MLIR_RUNNER_LIBS")"
OUT="out"
TEST="src/test_3"
SSTR_SRC="src/test_2"
DEST="$OUT/test_3"
SIZE="${1:-256}"
EXEC_ITERS="${EXEC_ITERS:-5}"
COMPILE_ITERS="${COMPILE_ITERS:-3}"
TMPD="$(mktemp -d)"
trap 'rm -rf "$TMPD"' EXIT

if [ ! -x "$SSTR_OPT" ]; then
  echo "== construyendo el dialecto propio (sstr-opt) =="
  bash src/test_2/dialect/build.sh
fi

SIZE_LAST=$((SIZE - 1))
SIZE_HALF=$((SIZE / 2))

link_mlir() { # $1 tmp .ll, $2 out exe
  mlir-translate-18 --mlir-to-llvmir "$1" -o "$1.ll"
  llc-18 "$1.ll" -filetype=obj -o "$1.o"
  cc "$1.o" -o "$2" -L"$LIBDIR" -lmlir_c_runner_utils -Wl,-rpath,"$LIBDIR"
}

sed "s/__SIZE__/$SIZE/g; s/__LAST__/$SIZE_LAST/g; s/__HALF__/$SIZE_HALF/g" \
  "$TEST/01_matmul_linalg.mlir.in" > "$TMPD/normal_kernel.mlir"
sed "s/__SIZE__/$SIZE/g; s/__LAST__/$SIZE_LAST/g; s/__HALF__/$SIZE_HALF/g" \
  "$TEST/main.mlir.in" > "$TMPD/normal_main.mlir"
cat "$TMPD/normal_kernel.mlir" "$TMPD/normal_main.mlir" > "$TMPD/normal_full.mlir"
cat "$SSTR_SRC/01_matmul_sstr.mlir" "$SSTR_SRC/main.mlir" > "$TMPD/sstr_full.mlir"

mlir_normal() { # opt=0|1, $2 exe salida
  local opt="$1" out="$2" chain=""
  chain="--linalg-generalize-named-ops --convert-linalg-to-affine-loops"
  if [ "$opt" = "1" ]; then
    chain="$chain --affine-loop-fusion=fusion-maximal=1 --affine-loop-unroll=unroll-full=1"
  fi
  chain="$chain --lower-affine --convert-scf-to-cf --expand-strided-metadata"
  chain="$chain --finalize-memref-to-llvm --convert-arith-to-llvm --convert-func-to-llvm --reconcile-unrealized-casts"
  "$MLIR_OPT" "$TMPD/normal_full.mlir" $chain -o "$TMPD/normal_run.mlir"
  link_mlir "$TMPD/normal_run.mlir" "$out"
}

mlir_strassen() { # opt=0|1, $2 exe salida
  local opt="$1" out="$2" chain=""
  "$SSTR_OPT" "$TMPD/sstr_full.mlir" -o "$TMPD/sstr_exp.mlir"
  "$MLIR_OPT" "$TMPD/sstr_exp.mlir" \
    --one-shot-bufferize='bufferize-function-boundaries=true function-boundary-type-conversion=identity-layout-map' \
    --buffer-deallocation --buffer-results-to-out-params \
    -o "$TMPD/sstr_buf.mlir"
  chain="--linalg-generalize-named-ops --convert-linalg-to-affine-loops"
  if [ "$opt" = "1" ]; then
    chain="$chain --affine-loop-fusion=fusion-maximal=1 --affine-loop-unroll=unroll-full=1"
  fi
  chain="$chain --lower-affine --convert-scf-to-cf --expand-strided-metadata"
  chain="$chain --finalize-memref-to-llvm --convert-arith-to-llvm --convert-func-to-llvm --reconcile-unrealized-casts"
  "$MLIR_OPT" "$TMPD/sstr_buf.mlir" $chain -o "$TMPD/sstr_run.mlir"
  link_mlir "$TMPD/sstr_run.mlir" "$out"
}

t_ms() { # deltas negativos por saltos de reloj de WSL -> 0
  local d=$(( ( $2 - $1 ) / 1000000 ))
  if [ "$d" -lt 0 ]; then d=0; fi
  echo "$d"
}
avg_ms() { echo $(( $1 / $2 )); }

run_exec_ms() { # $1 exe, -> echo ms totales (EXEC_ITERS corridas)
  local t0 t1 i
  t0=$(date +%s%N)
  for i in $(seq 1 "$EXEC_ITERS"); do "$1" >/dev/null 2>&1; done
  t1=$(date +%s%N)
  t_ms "$t0" "$t1"
}

compile_gcc_ms() { # $1 flags, $2 archivos, $3 exe, -> echo promedio ms
  local acc=0 t0 t1 i
  for i in $(seq 1 "$COMPILE_ITERS"); do
    t0=$(date +%s%N)
    g++ $1 $2 -I src -o "$3"
    t1=$(date +%s%N); acc=$((acc + $(t_ms "$t0" "$t1")))
  done
  avg_ms "$acc" "$COMPILE_ITERS"
}

compile_mlir_ms() { # $1 funcion mlir, $2 opt, $3 exe, -> echo promedio ms
  local acc=0 t0 t1 i
  for i in $(seq 1 "$COMPILE_ITERS"); do
    t0=$(date +%s%N)
    "$1" "$2" "$3"
    t1=$(date +%s%N); acc=$((acc + $(t_ms "$t0" "$t1")))
  done
  avg_ms "$acc" "$COMPILE_ITERS"
}

BENCHD="$DEST/09_bench"
mkdir -p "$BENCHD"

declare -A GCOMP MCOMP GEXEC MEXEC

for A in normal strassen; do
  for O in sin con; do
    if [ "$O" = "sin" ]; then GFLAGS="-O0"; MLOPT=0; else GFLAGS="-O2"; MLOPT=1; fi
    if [ "$A" = "normal" ]; then
      GCX="$TEST/main.cpp src/mm_naive.cpp"
      GCCEXE="$BENCHD/gcc_norm_${O}"
      MLIRF=mlir_normal
    else
      GCX="$SSTR_SRC/main.cpp src/mm_naive.cpp src/mm_strassen.cpp"
      GCCEXE="$BENCHD/gcc_sstr_${O}"
      MLIRF=mlir_strassen
    fi
    GCOMP[$A/$O]=$(compile_gcc_ms "$GFLAGS -DSIZE=$SIZE" "$GCX" "$GCCEXE")
    MCOMP[$A/$O]=$(compile_mlir_ms "$MLIRF" "$MLOPT" "$BENCHD/mlir_${A}_${O}")
    GEXEC[$A/$O]=$(run_exec_ms "$GCCEXE")
    MEXEC[$A/$O]=$(run_exec_ms "$BENCHD/mlir_${A}_${O}")
  done
done

echo "========== test_3 (comparativa g++ vs MLIR, pares con igual optimizacion) =========="
echo "  matmul normal SIZE=$SIZE | strassen 64x64 | compile x${COMPILE_ITERS} | exec x${EXEC_ITERS}"
echo ""
printf "  %-18s %13s %13s %13s %13s\n" "medida" "normal/sin" "normal/con" "strassen/sin" "strassen/con"
printf "  %-18s %13s %13s %13s %13s\n" "-----" "----------" "-----------" "------------" "------------"
printf "  %-18s %13s %13s %13s %13s\n" "g++ compilacion" "${GCOMP[normal/sin]}" "${GCOMP[normal/con]}" "${GCOMP[strassen/sin]}" "${GCOMP[strassen/con]}"
printf "  %-18s %13s %13s %13s %13s\n" "MLIR compilacion" "${MCOMP[normal/sin]}" "${MCOMP[normal/con]}" "${MCOMP[strassen/sin]}" "${MCOMP[strassen/con]}"
printf "  %-18s %13s %13s %13s %13s\n" "g++ ejecucion" "${GEXEC[normal/sin]}" "${GEXEC[normal/con]}" "${GEXEC[strassen/sin]}" "${GEXEC[strassen/con]}"
printf "  %-18s %13s %13s %13s %13s\n" "MLIR ejecucion" "${MEXEC[normal/sin]}" "${MEXEC[normal/con]}" "${MEXEC[strassen/sin]}" "${MEXEC[strassen/con]}"
echo ""
echo "  (binarios e intermedios en $BENCHD/)"