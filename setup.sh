set -euo pipefail

PKGS="build-essential llvm-18 llvm-18-tools llvm-18-dev libmlir-18 libmlir-18-dev mlir-18-tools"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "este script asume Ubuntu/Debian (apt). Revisa el SO e instala los paquetes equivalentes."
  exit 1
fi

echo "== [1/3] apt-get update =="
if [ "$(id -u)" -eq 0 ]; then
  apt-get update
else
  sudo apt-get update
fi

echo "== [2/3] instalando $PKGS =="
if [ "$(id -u)" -eq 0 ]; then
  DEBIAN_FRONTEND=noninteractive apt-get install -y $PKGS
else
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y $PKGS
fi

echo "== [3/3] verificando herramientas =="
OK=1
for T in g++ mlir-opt-18 mlir-translate-18 mlir-cpu-runner-18 llc-18 mlir-tblgen; do
  if command -v "$T" >/dev/null 2>&1; then
    echo "  ok   $T -> $(command -v "$T")"
  elif [ -x "/usr/lib/llvm-18/bin/$T" ]; then
    echo "  ok   $T -> /usr/lib/llvm-18/bin/$T"
  else
    echo "  FALTA $T"
    OK=0
  fi
done
if [ ! -f /usr/lib/llvm-18/include/llvm/Support/Casting.h ]; then
  echo "  FALTA las cabeceras de LLVM en /usr/lib/llvm-18/include"
  OK=0
fi

if [ "$OK" -eq 0 ]; then
  echo "Hubo faltantes, revisa los mensajes de arriba."
  exit 1
fi

echo "  compilando el dialecto propio (sstr-opt) ..."
bash src/test_2/dialect/build.sh

echo ""
echo "Listo. Prueba el proyecto con"
echo "  bash test_1.sh"
echo "  bash test_2.sh"
echo "  bash test_3.sh"