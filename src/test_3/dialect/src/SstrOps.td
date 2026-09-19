// =============================================================
// SstrOps.td — operaciones del dialecto sstr
//
// Compilar este archivo genera (via mlir-tblgen):
//   SstrOps.h.inc   (declaraciones de la clase de la op)
//   SstrOps.cpp.inc (implementacion build/parse/verify generada)
// =============================================================

#ifndef SSTR_OPS_TD
#define SSTR_OPS_TD

include "SstrDialect.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinTypes.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// Pure = la op no tiene efectos laterales (no toca memoria externa):
// habilita CSE/canonicalize, que es la regla de "dialecto bien hecho".
def Sstr_MatmulOp : Sstr_Op<"matmul", [Pure]> {
  let summary = "Producto de matrices por el metodo Strassen";
  let description = [{
    Declara el producto C = A * B sobre tensores f32 cuadrados y estaticos
    de tamano potencia de 2. `init` es el tensor de acumulacion inicial en
    estilo destination-passing (como linalg): la op devuelve un tensor nuevo
    con el resultado.

    Atributos:
      method  — implementacion pedida ("strassen" u "naive").
      cutoff  — tamano minimo de bloque; por debajo se usa el clasico.
  }];
  let arguments = (ins
    // A: [n x n], B: [n x n], init: [n x n]
    TensorOf<[F32]>:$a,
    TensorOf<[F32]>:$b,
    TensorOf<[F32]>:$init,

    StrAttr:$method,
    ConfinedAttr<I64Attr, [IntNonNegative]>:$cutoff
  );
  let results = (outs TensorOf<[F32]>:$result);

  // Sintaxis legible cuando se imprime:
  //   sstr.matmul %A, %B init %init {method = "strassen", cutoff = 16 : i64}
  let assemblyFormat =
    "$a `,` $b `init` $init attr-dict `:` type($a) `,` type($b) `,` "
    "type($init) `->` type($result)";

  // Verifier en C++: tamaños estaticos, cuadrados, potencia de 2.
  let hasVerifier = 1;
}

#endif // SSTR_OPS_TD