module {
  llvm.func @matmul_f32(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %25 = llvm.mlir.constant(0 : index) : i64
    %26 = llvm.mlir.constant(128 : index) : i64
    %27 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%25 : i64)
  ^bb1(%28: i64):  // 2 preds: ^bb0, ^bb5
    %29 = llvm.icmp "slt" %28, %26 : i64
    llvm.cond_br %29, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%25 : i64)
  ^bb3(%30: i64):  // 2 preds: ^bb2, ^bb4
    %31 = llvm.icmp "slt" %30, %26 : i64
    llvm.cond_br %31, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %32 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.mlir.constant(128 : index) : i64
    %34 = llvm.mul %28, %33  : i64
    %35 = llvm.add %34, %30  : i64
    %36 = llvm.getelementptr %32[%35] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %24, %36 : f32, !llvm.ptr
    %37 = llvm.add %30, %27  : i64
    llvm.br ^bb3(%37 : i64)
  ^bb5:  // pred: ^bb3
    %38 = llvm.add %28, %27  : i64
    llvm.br ^bb1(%38 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%25 : i64)
  ^bb7(%39: i64):  // 2 preds: ^bb6, ^bb14
    %40 = llvm.icmp "slt" %39, %26 : i64
    llvm.cond_br %40, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%25 : i64)
  ^bb9(%41: i64):  // 2 preds: ^bb8, ^bb13
    %42 = llvm.icmp "slt" %41, %26 : i64
    llvm.cond_br %42, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%25 : i64)
  ^bb11(%43: i64):  // 2 preds: ^bb10, ^bb12
    %44 = llvm.icmp "slt" %43, %26 : i64
    llvm.cond_br %44, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %45 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %46 = llvm.mlir.constant(128 : index) : i64
    %47 = llvm.mul %39, %46  : i64
    %48 = llvm.add %47, %43  : i64
    %49 = llvm.getelementptr %45[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %50 = llvm.load %49 : !llvm.ptr -> f32
    %51 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.mlir.constant(128 : index) : i64
    %53 = llvm.mul %43, %52  : i64
    %54 = llvm.add %53, %41  : i64
    %55 = llvm.getelementptr %51[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %56 = llvm.load %55 : !llvm.ptr -> f32
    %57 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.mlir.constant(128 : index) : i64
    %59 = llvm.mul %39, %58  : i64
    %60 = llvm.add %59, %41  : i64
    %61 = llvm.getelementptr %57[%60] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %62 = llvm.load %61 : !llvm.ptr -> f32
    %63 = llvm.fmul %50, %56  : f32
    %64 = llvm.fadd %62, %63  : f32
    %65 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.mlir.constant(128 : index) : i64
    %67 = llvm.mul %39, %66  : i64
    %68 = llvm.add %67, %41  : i64
    %69 = llvm.getelementptr %65[%68] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %64, %69 : f32, !llvm.ptr
    %70 = llvm.add %43, %27  : i64
    llvm.br ^bb11(%70 : i64)
  ^bb13:  // pred: ^bb11
    %71 = llvm.add %41, %27  : i64
    llvm.br ^bb9(%71 : i64)
  ^bb14:  // pred: ^bb9
    %72 = llvm.add %39, %27  : i64
    llvm.br ^bb7(%72 : i64)
  ^bb15:  // pred: ^bb7
    llvm.return
  }
}

