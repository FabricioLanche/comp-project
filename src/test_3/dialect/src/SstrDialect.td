// =============================================================
// SstrDialect.td — definicion del dialecto "sstr" (TableGen/ODS)
//
// Un dialecto ES un vocabulario + reglas. "sstr" agrega un nivel de
// abstraccion por encima de linalg: la op sstr.matmul describe "multiplique
// estas matrices" y DELEGA al pass sstr-expand la decision de COMO hacerlo
// (Strassen recursivo con nivel de corte configurable, o directo).
//
// Compilar: mlir-tblgen -gen-dialect-decls / -gen-dialect-defs
// =============================================================

#ifndef SSTR_DIALECT_TD
#define SSTR_DIALECT_TD

include "mlir/IR/OpBase.td"

def Sstr_Dialect : Dialect {
  let summary = "Dialecto sstr: matmul rapido (Strassen) sobre tensores";
  let description = [{
    El dialecto sstr agrega un nivel de abstraccion sobre linalg para
    estudiar algoritmos de multiplicacion de matrices rapida (fast matrix
    multiplication). Hoy expone una sola operacion, sstr.matmul, que declara
    el producto de dos matrices f32 (cuadradas, estaticas y de potencia de 2)
    y deja que el pass sstr-expand decida la implementacion:

      sstr.matmul %A, %B init(%init)
             {method = "strassen", cutoff = 16 : i64}
             : (tensor<64x64xf32>, tensor<64x64xf32>) -> tensor<64x64xf32>

    El pass sstr-expand baja sstr.matmul a operaciones de linalg/tensor/arith
    (extract_slice, linalg.generic con addf/subf, linalg.matmul, insert_slice)
    y desde ahi la cadena estandar linalg -> affine -> scf -> cf -> llvm
    responde el resto.
  }];
  let cppNamespace = "sstr";
  let name = "sstr";
}

class Sstr_Op<string mnemonic, list<Trait> traits = []>
    : Op<Sstr_Dialect, mnemonic, traits>;

#endif // SSTR_DIALECT_TD