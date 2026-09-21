func.func @matmul_f32(%A: memref<3x4xf32>, %B: memref<4x5xf32>, %C: memref<3x5xf32>) {

  %cst = arith.constant 0.0 : f32
  linalg.fill ins(%cst : f32) outs(%C : memref<3x5xf32>)

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