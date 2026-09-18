module {
  func.func @matmul_f32(%arg0: memref<8x16xf32>, %arg1: memref<16x32xf32>, %arg2: memref<8x32xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c8 step %c1 {
      %c0_0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1_1 = arith.constant 1 : index
      scf.for %arg4 = %c0_0 to %c32 step %c1_1 {
        memref.store %cst, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %c0_2 = arith.constant 0 : index
        %c16 = arith.constant 16 : index
        %c1_3 = arith.constant 1 : index
        scf.for %arg5 = %c0_2 to %c16 step %c1_3 {
          %0 = memref.load %arg0[%arg3, %arg5] : memref<8x16xf32>
          %1 = memref.load %arg1[%arg5, %arg4] : memref<16x32xf32>
          %2 = memref.load %arg2[%arg3, %arg4] : memref<8x32xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %2, %3 : f32
          memref.store %4, %arg2[%arg3, %arg4] : memref<8x32xf32>
        }
      }
    }
    return
  }
}

