// =============================================================
// 01_matmul_linalg.mlir
// MATMUL: C[3x5] = A[3x4] x B[4x5]
//   C(i,j) = sum_k A(i,k) * B(k,j)
//
// Este archivo es la REALIZACION en dialectos MLIR del programa
// fuente src/matmul.c (ver el mapeo 1:1 en los comentarios de ese
// archivo). Lo que aqui se escribe a nivel de tensores (sin bucles)
// es justamente lo que el compilador re-genera al bajar de nivel.
//
// Este archivo esta escrito en el dialecto "linalg": describe la
// computacion a nivel de tensores, SIN escribir los bucles a mano.
// MLIR lo entiende de forma declarativa (que se computa), y luego
// toda la maquinaria lo baja a bucles (affine) y a codigo de maquina.
// =============================================================

// Funcion con 3 buffers (memrefs) como argumentos.
func.func @matmul_f32(%A: memref<3x4xf32>, %B: memref<4x5xf32>, %C: memref<3x5xf32>) {

  // Constantes que se usan abajo.
  %cst = arith.constant 0.0 : f32      // cero
  %cst_1 = arith.constant 1.0 : f32    // uno (no usado; de ejemplo)

  // 1) linalg.fill: inicializa C con 0.
  //    Es un op "named": no hay que pedirle bucles, el compilador los genera.
  linalg.fill ins(%cst : f32) outs(%C : memref<3x5xf32>)

  // 2) linalg.generic: la operacion "generica" de linalg.
  //    Compone la suma producto:
  //      - ins  = entradas A y B
  //      - outs = C (acumulador)
  //      - indexing_maps = como se indexa cada operando (ver cabecera)
  //      - iterator_types = "parallel" (i,j) y "reduction" (k)
  //      - ^bb0: el "cuerpo" de la operacion sobre 1 elemento c/u,
  //        recibe (a, b, c) y devuelve a*b + c  (acumulacion).
  linalg.generic {
    indexing_maps = [
      affine_map<(d0, d1, d2) -> (d0, d2)>,   // A(i,k)
      affine_map<(d0, d1, d2) -> (d2, d1)>,   // B(k,j)
      affine_map<(d0, d1, d2) -> (d0, d1)>    // C(i,j)
    ],
    iterator_types = ["parallel", "parallel", "reduction"]
  } ins(%A, %B : memref<3x4xf32>, memref<4x5xf32>)
    outs(%C : memref<3x5xf32>) {
  ^bb0(%a: f32, %b: f32, %c: f32):
    %prod = arith.mulf %a, %b : f32          // a*b
    %0 = arith.addf %c, %prod : f32          // c + a*b  (acumular)
    linalg.yield %0 : f32
  }

  return
}

// =============================================================
