module {
  func.func @matmul_f32(%arg0: memref<3x4xf32>, %arg1: memref<4x5xf32>, %arg2: memref<3x5xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c3 = arith.constant 3 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %c0 to %c3 step %c1 {
      %c0_3 = arith.constant 0 : index
      %c5 = arith.constant 5 : index
      %c1_4 = arith.constant 1 : index
      scf.for %arg4 = %c0_3 to %c5 step %c1_4 {
        memref.store %cst, %arg2[%arg3, %arg4] : memref<3x5xf32>
      }
    }
    %c0_0 = arith.constant 0 : index
    %c3_1 = arith.constant 3 : index
    %c1_2 = arith.constant 1 : index
    scf.for %arg3 = %c0_0 to %c3_1 step %c1_2 {
      %c0_3 = arith.constant 0 : index
      %c5 = arith.constant 5 : index
      %c1_4 = arith.constant 1 : index
      scf.for %arg4 = %c0_3 to %c5 step %c1_4 {
        %c0_5 = arith.constant 0 : index
        %c4 = arith.constant 4 : index
        %c1_6 = arith.constant 1 : index
        scf.for %arg5 = %c0_5 to %c4 step %c1_6 {
          %0 = memref.load %arg0[%arg3, %arg5] : memref<3x4xf32>
          %1 = memref.load %arg1[%arg5, %arg4] : memref<4x5xf32>
          %2 = memref.load %arg2[%arg3, %arg4] : memref<3x5xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %2, %3 : f32
          memref.store %4, %arg2[%arg3, %arg4] : memref<3x5xf32>
        }
      }
    }
    return
  }
}

