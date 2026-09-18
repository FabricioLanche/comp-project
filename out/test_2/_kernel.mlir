// =============================================================
// 01_matmul_linalg.mlir  (test_2 — matrices MAS GRANDES)
// MATMUL: C[8x32] = A[8x16] x B[16x32]
//   C(i,j) = sum_k A(i,k) * B(k,j)   (k recorre 16 terminos)
//
// Realizacion en dialectos MLIR del programa fuente matmul.c de
// este mismo directorio (ver mapeo 1:1 en sus comentarios).
// A y B de unos -> C = 16.0 en toda celda (16 sumas de 1*1).
// =============================================================

func.func @matmul_f32(%A: memref<8x16xf32>, %B: memref<16x32xf32>, %C: memref<8x32xf32>) {

  %cst = arith.constant 0.0 : f32

  // 1) Inicializa C en 0.
  linalg.fill ins(%cst : f32) outs(%C : memref<8x32xf32>)

  // 2) Producto punto: 8 filas (d0) x 32 cols (d1), reduciendo 16 (d2).
  linalg.generic {
    indexing_maps = [
      affine_map<(d0, d1, d2) -> (d0, d2)>,   // A(i,k)
      affine_map<(d0, d1, d2) -> (d2, d1)>,   // B(k,j)
      affine_map<(d0, d1, d2) -> (d0, d1)>    // C(i,j)
    ],
    iterator_types = ["parallel", "parallel", "reduction"]
  } ins(%A, %B : memref<8x16xf32>, memref<16x32xf32>)
    outs(%C : memref<8x32xf32>) {
  ^bb0(%a: f32, %b: f32, %c: f32):
    %prod = arith.mulf %a, %b : f32          // a*b
    %0 = arith.addf %c, %prod : f32          // c + a*b  (acumular)
    linalg.yield %0 : f32
  }

  return
}

// =============================================================
