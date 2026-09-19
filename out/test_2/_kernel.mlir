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

