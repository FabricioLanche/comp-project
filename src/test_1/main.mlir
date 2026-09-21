func.func @main() -> i32 {
  %uno = arith.constant 1.0 : f32
  %cero = arith.constant 0.0 : f32

  %A = memref.alloc() : memref<3x4xf32>
  %B = memref.alloc() : memref<4x5xf32>
  %C = memref.alloc() : memref<3x5xf32>

  linalg.fill ins(%uno : f32) outs(%A : memref<3x4xf32>)
  linalg.fill ins(%uno : f32) outs(%B : memref<4x5xf32>)

  func.call @matmul_f32(%A, %B, %C) : (memref<3x4xf32>, memref<4x5xf32>, memref<3x5xf32>) -> ()

  // Todas las celdas deben ser 4.0.
  %r0 = arith.constant 0 : index
  %r1 = arith.constant 1 : index
  %r2 = arith.constant 2 : index
  %r4 = arith.constant 4 : index
  %c4 = arith.constant 4.0 : f32

  %d_a = memref.load %C[%r0, %r0] : memref<3x5xf32>
  %d_b = memref.load %C[%r0, %r4] : memref<3x5xf32>
  %d_c = memref.load %C[%r2, %r2] : memref<3x5xf32>

  %ok1 = arith.cmpf oeq, %d_a, %c4 : f32
  %ok2 = arith.cmpf oeq, %d_b, %c4 : f32
  %ok3 = arith.cmpf oeq, %d_c, %c4 : f32
  %ok_a = arith.andi %ok1, %ok2 : i1
  %ok = arith.andi %ok_a, %ok3 : i1

  %uno_i = arith.constant 1 : i32
  %ok_i = arith.extui %ok : i1 to i32
  %fallo = arith.subi %uno_i, %ok_i : i32   // 1 si fallo, 0 si ok

  memref.dealloc %C : memref<3x5xf32>
  memref.dealloc %B : memref<4x5xf32>
  memref.dealloc %A : memref<3x4xf32>

  return %fallo : i32
}