module {
  func.func @matmul_f32(%arg0: memref<128x128xf32>, %arg1: memref<128x128xf32>, %arg2: memref<128x128xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c128 = arith.constant 128 : index
    %c1 = arith.constant 1 : index
    cf.br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb5
    %1 = arith.cmpi slt, %0, %c128 : index
    cf.cond_br %1, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    %c0_0 = arith.constant 0 : index
    %c128_1 = arith.constant 128 : index
    %c1_2 = arith.constant 1 : index
    cf.br ^bb3(%c0_0 : index)
  ^bb3(%2: index):  // 2 preds: ^bb2, ^bb4
    %3 = arith.cmpi slt, %2, %c128_1 : index
    cf.cond_br %3, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    memref.store %cst, %arg2[%0, %2] : memref<128x128xf32>
    %4 = arith.addi %2, %c1_2 : index
    cf.br ^bb3(%4 : index)
  ^bb5:  // pred: ^bb3
    %5 = arith.addi %0, %c1 : index
    cf.br ^bb1(%5 : index)
  ^bb6:  // pred: ^bb1
    %c0_3 = arith.constant 0 : index
    %c128_4 = arith.constant 128 : index
    %c1_5 = arith.constant 1 : index
    cf.br ^bb7(%c0_3 : index)
  ^bb7(%6: index):  // 2 preds: ^bb6, ^bb14
    %7 = arith.cmpi slt, %6, %c128_4 : index
    cf.cond_br %7, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    %c0_6 = arith.constant 0 : index
    %c128_7 = arith.constant 128 : index
    %c1_8 = arith.constant 1 : index
    cf.br ^bb9(%c0_6 : index)
  ^bb9(%8: index):  // 2 preds: ^bb8, ^bb13
    %9 = arith.cmpi slt, %8, %c128_7 : index
    cf.cond_br %9, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    %c0_9 = arith.constant 0 : index
    %c128_10 = arith.constant 128 : index
    %c1_11 = arith.constant 1 : index
    cf.br ^bb11(%c0_9 : index)
  ^bb11(%10: index):  // 2 preds: ^bb10, ^bb12
    %11 = arith.cmpi slt, %10, %c128_10 : index
    cf.cond_br %11, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %12 = memref.load %arg0[%6, %10] : memref<128x128xf32>
    %13 = memref.load %arg1[%10, %8] : memref<128x128xf32>
    %14 = memref.load %arg2[%6, %8] : memref<128x128xf32>
    %15 = arith.mulf %12, %13 : f32
    %16 = arith.addf %14, %15 : f32
    memref.store %16, %arg2[%6, %8] : memref<128x128xf32>
    %17 = arith.addi %10, %c1_11 : index
    cf.br ^bb11(%17 : index)
  ^bb13:  // pred: ^bb11
    %18 = arith.addi %8, %c1_8 : index
    cf.br ^bb9(%18 : index)
  ^bb14:  // pred: ^bb9
    %19 = arith.addi %6, %c1_5 : index
    cf.br ^bb7(%19 : index)
  ^bb15:  // pred: ^bb7
    return
  }
}

