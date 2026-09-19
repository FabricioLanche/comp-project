func.func @matmul_f32(%A: memref<512x512xf32>, %B: memref<512x512xf32>, %C: memref<512x512xf32>) {

  %cst = arith.constant 0.0 : f32

  linalg.fill ins(%cst : f32) outs(%C : memref<512x512xf32>)

  linalg.generic {
    indexing_maps = [
      affine_map<(d0, d1, d2) -> (d0, d2)>,
      affine_map<(d0, d1, d2) -> (d2, d1)>,
      affine_map<(d0, d1, d2) -> (d0, d1)>
    ],
    iterator_types = ["parallel", "parallel", "reduction"]
  } ins(%A, %B : memref<512x512xf32>, memref<512x512xf32>)
    outs(%C : memref<512x512xf32>) {
  ^bb0(%a: f32, %b: f32, %c: f32):
    %prod = arith.mulf %a, %b : f32
    %0 = arith.addf %c, %prod : f32
    linalg.yield %0 : f32
  }

  return
}

// DRIVER (invocación)
func.func @main() -> i32 {
  %uno = arith.constant 1.0 : f32

  %A = memref.alloc() : memref<512x512xf32>
  %B = memref.alloc() : memref<512x512xf32>
  %C = memref.alloc() : memref<512x512xf32>

  linalg.fill ins(%uno : f32) outs(%A : memref<512x512xf32>)
  linalg.fill ins(%uno : f32) outs(%B : memref<512x512xf32>)

  func.call @matmul_f32(%A, %B, %C) : (memref<512x512xf32>, memref<512x512xf32>, memref<512x512xf32>) -> ()

  %r0 = arith.constant 0 : index
  %r_half = arith.constant 256 : index
  %r_last = arith.constant 511 : index
  %c_esp = arith.constant 512.0 : f32

  %d_a = memref.load %C[%r0, %r0] : memref<512x512xf32>
  %d_b = memref.load %C[%r0, %r_last] : memref<512x512xf32>
  %d_c = memref.load %C[%r_last, %r_half] : memref<512x512xf32>

  %ok1 = arith.cmpf oeq, %d_a, %c_esp : f32
  %ok2 = arith.cmpf oeq, %d_b, %c_esp : f32
  %ok3 = arith.cmpf oeq, %d_c, %c_esp : f32
  %ok_a = arith.andi %ok1, %ok2 : i1
  %ok = arith.andi %ok_a, %ok3 : i1

  %uno_i = arith.constant 1 : i32
  %ok_i = arith.extui %ok : i1 to i32
  %fallo = arith.subi %uno_i, %ok_i : i32

  memref.dealloc %C : memref<512x512xf32>
  memref.dealloc %B : memref<512x512xf32>
  memref.dealloc %A : memref<512x512xf32>

  return %fallo : i32
}