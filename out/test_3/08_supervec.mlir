module {
  func.func @matmul_f32(%arg0: memref<8x16xf32>, %arg1: memref<16x32xf32>, %arg2: memref<8x32xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg3 = 0 to 8 {
      affine.for %arg4 = 0 to 32 {
        affine.store %cst, %arg2[%arg3, %arg4] : memref<8x32xf32>
      }
    }
    affine.for %arg3 = 0 to 8 {
      affine.for %arg4 = 0 to 32 {
        affine.for %arg5 = 0 to 16 {
          %0 = affine.load %arg0[%arg3, %arg5] : memref<8x16xf32>
          %1 = affine.load %arg1[%arg5, %arg4] : memref<16x32xf32>
          %2 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %2, %3 : f32
          affine.store %4, %arg2[%arg3, %arg4] : memref<8x32xf32>
        }
      }
    }
    return
  }
}

