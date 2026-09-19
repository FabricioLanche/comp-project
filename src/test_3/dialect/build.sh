#!/usr/bin/env bash
# =============================================================
# build.sh — construye el dialecto sstr (sstr-opt) contra libMLIR 18.
#
# Uso:  bash dialect/build.sh
# Produce: dialect/build/sstr-opt   (mini-mlir-opt con el dialecto sstr)
#
# Organizacion de carpetas (para no perderse):
#   dialect/src/    lo que se edita a mano (SstrDialect.td, SstrOps.td,
#                   SstrDialect.h, SstrOps.h, SstrStrassen.cpp)
#   dialect/gen/    lo que genera mlir-tblgen (NO se edita, se regenera)
#   dialect/build/  lo que se compila (sstr-opt, se borra y se recrea)
#
# Pasos:
#   1) mlir-tblgen genera las .inc (declaraciones/definiciones) en gen/
#   2) g++ compila src/SstrStrassen.cpp y linkea contra libMLIR
# =============================================================
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
LLVM="/usr/lib/llvm-18"
TBLGEN="$LLVM/bin/mlir-tblgen"
CXX="${CXX:-g++}"

SRC="$HERE/src"
GEN="$HERE/gen"
BIN="$HERE/build"

mkdir -p "$GEN" "$BIN"

echo "== [1/4] generar dialecto (h.inc / cpp.inc) -> gen/ =="
"$TBLGEN" -gen-dialect-decls -dialect=sstr \
  -I "$LLVM/include" -I "$SRC" "$SRC/SstrDialect.td" -o "$GEN/SstrDialect.h.inc"
"$TBLGEN" -gen-dialect-defs -dialect=sstr \
  -I "$LLVM/include" -I "$SRC" "$SRC/SstrDialect.td" -o "$GEN/SstrDialect.cpp.inc"

echo "== [2/4] generar op (h.inc / cpp.inc) -> gen/ =="
"$TBLGEN" -gen-op-decls \
  -I "$LLVM/include" -I "$SRC" "$SRC/SstrOps.td" -o "$GEN/SstrOps.h.inc"
"$TBLGEN" -gen-op-defs \
  -I "$LLVM/include" -I "$SRC" "$SRC/SstrOps.td" -o "$GEN/SstrOps.cpp.inc"

echo "== [3/4] compilar -> build/sstr-opt =="
"$CXX" -std=c++17 -O1 -fno-rtti -fno-exceptions \
  -I "$SRC" -I "$LLVM/include" \
  "$SRC/SstrStrassen.cpp" \
  -L "$LLVM/lib" -lMLIR -lLLVM \
  -Wl,-rpath,"$LLVM/lib" \
  -o "$BIN/sstr-opt"

echo "== [4/4] listo: $BIN/sstr-opt =="