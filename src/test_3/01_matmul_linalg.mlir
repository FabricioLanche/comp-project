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
// DRIVER (invocación): 8x16 unos x 16x32 unos -> C = 16.0.
// @main devuelve 0 si correcto, 1 si no.
// =============================================================

func.func @main() -> i32 {
  %uno = arith.constant 1.0 : f32

  %A = memref.alloc() : memref<8x16xf32>
  %B = memref.alloc() : memref<16x32xf32>
  %C = memref.alloc() : memref<8x32xf32>

  linalg.fill ins(%uno : f32) outs(%A : memref<8x16xf32>)
  linalg.fill ins(%uno : f32) outs(%B : memref<16x32xf32>)

  func.call @matmul_f32(%A, %B, %C) : (memref<8x16xf32>, memref<16x32xf32>, memref<8x32xf32>) -> ()

  // Verificamos esquinas y centro: todas deben ser 16.0.
  %r0 = arith.constant 0 : index
  %r1 = arith.constant 1 : index
  %r3 = arith.constant 3 : index
  %r7 = arith.constant 7 : index
  %r31 = arith.constant 31 : index
  %c16 = arith.constant 16.0 : f32

  %d_a = memref.load %C[%r0, %r0] : memref<8x32xf32>
  %d_b = memref.load %C[%r0, %r31] : memref<8x32xf32>
  %d_c = memref.load %C[%r7, %r3] : memref<8x32xf32>

  %ok1 = arith.cmpf oeq, %d_a, %c16 : f32
  %ok2 = arith.cmpf oeq, %d_b, %c16 : f32
  %ok3 = arith.cmpf oeq, %d_c, %c16 : f32
  %ok_a = arith.andi %ok1, %ok2 : i1
  %ok = arith.andi %ok_a, %ok3 : i1

  %uno_i = arith.constant 1 : i32
  %ok_i = arith.extui %ok : i1 to i32
  %fallo = arith.subi %uno_i, %ok_i : i32   // 1 si fallo, 0 si ok

  memref.dealloc %C : memref<8x32xf32>
  memref.dealloc %B : memref<16x32xf32>
  memref.dealloc %A : memref<8x16xf32>

  return %fallo : i32
}