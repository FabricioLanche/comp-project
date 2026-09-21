#map = affine_map<(d0) -> (d0 + 1)>
#map1 = affine_map<(d0) -> (d0 + 2)>
#map2 = affine_map<(d0) -> (d0 + 3)>
module {
  func.func @matmul_f32(%arg0: memref<3x4xf32>, %arg1: memref<4x5xf32>, %arg2: memref<3x5xf32>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg3 = 0 to 3 {
      affine.for %arg4 = 0 to 5 {
        affine.store %cst, %arg2[%arg3, %arg4] : memref<3x5xf32>
        %0 = affine.load %arg0[%arg3, %c0] : memref<3x4xf32>
        %1 = affine.load %arg1[%c0, %arg4] : memref<4x5xf32>
        %2 = affine.load %arg2[%arg3, %arg4] : memref<3x5xf32>
        %3 = arith.mulf %0, %1 : f32
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %arg2[%arg3, %arg4] : memref<3x5xf32>
        %5 = affine.apply #map(%c0)
        %6 = affine.load %arg0[%arg3, %5] : memref<3x4xf32>
        %7 = affine.load %arg1[%5, %arg4] : memref<4x5xf32>
        %8 = affine.load %arg2[%arg3, %arg4] : memref<3x5xf32>
        %9 = arith.mulf %6, %7 : f32
        %10 = arith.addf %8, %9 : f32
        affine.store %10, %arg2[%arg3, %arg4] : memref<3x5xf32>
        %11 = affine.apply #map1(%c0)
        %12 = affine.load %arg0[%arg3, %11] : memref<3x4xf32>
        %13 = affine.load %arg1[%11, %arg4] : memref<4x5xf32>
        %14 = affine.load %arg2[%arg3, %arg4] : memref<3x5xf32>
        %15 = arith.mulf %12, %13 : f32
        %16 = arith.addf %14, %15 : f32
        affine.store %16, %arg2[%arg3, %arg4] : memref<3x5xf32>
        %17 = affine.apply #map2(%c0)
        %18 = affine.load %arg0[%arg3, %17] : memref<3x4xf32>
        %19 = affine.load %arg1[%17, %arg4] : memref<4x5xf32>
        %20 = affine.load %arg2[%arg3, %arg4] : memref<3x5xf32>
        %21 = arith.mulf %18, %19 : f32
        %22 = arith.addf %20, %21 : f32
        affine.store %22, %arg2[%arg3, %arg4] : memref<3x5xf32>
      }
    }
    return
  }
}

