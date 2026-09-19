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
    %26 = llvm.mlir.constant(512 : index) : i64
    %27 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%25 : i64)
  ^bb1(%28: i64):  // 2 preds: ^bb0, ^bb8
    %29 = llvm.icmp "slt" %28, %26 : i64
    llvm.cond_br %29, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%25 : i64)
  ^bb3(%30: i64):  // 2 preds: ^bb2, ^bb7
    %31 = llvm.icmp "slt" %30, %26 : i64
    llvm.cond_br %31, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    %32 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.mlir.constant(512 : index) : i64
    %34 = llvm.mul %28, %33  : i64
    %35 = llvm.add %34, %30  : i64
    %36 = llvm.getelementptr %32[%35] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %24, %36 : f32, !llvm.ptr
    llvm.br ^bb5(%25 : i64)
  ^bb5(%37: i64):  // 2 preds: ^bb4, ^bb6
    %38 = llvm.icmp "slt" %37, %26 : i64
    llvm.cond_br %38, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %39 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(512 : index) : i64
    %41 = llvm.mul %28, %40  : i64
    %42 = llvm.add %41, %37  : i64
    %43 = llvm.getelementptr %39[%42] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %44 = llvm.load %43 : !llvm.ptr -> f32
    %45 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %46 = llvm.mlir.constant(512 : index) : i64
    %47 = llvm.mul %37, %46  : i64
    %48 = llvm.add %47, %30  : i64
    %49 = llvm.getelementptr %45[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %50 = llvm.load %49 : !llvm.ptr -> f32
    %51 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.mlir.constant(512 : index) : i64
    %53 = llvm.mul %28, %52  : i64
    %54 = llvm.add %53, %30  : i64
    %55 = llvm.getelementptr %51[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %56 = llvm.load %55 : !llvm.ptr -> f32
    %57 = llvm.fmul %44, %50  : f32
    %58 = llvm.fadd %56, %57  : f32
    %59 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.mlir.constant(512 : index) : i64
    %61 = llvm.mul %28, %60  : i64
    %62 = llvm.add %61, %30  : i64
    %63 = llvm.getelementptr %59[%62] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %58, %63 : f32, !llvm.ptr
    %64 = llvm.add %37, %27  : i64
    llvm.br ^bb5(%64 : i64)
  ^bb7:  // pred: ^bb5
    %65 = llvm.add %30, %27  : i64
    llvm.br ^bb3(%65 : i64)
  ^bb8:  // pred: ^bb3
    %66 = llvm.add %28, %27  : i64
    llvm.br ^bb1(%66 : i64)
  ^bb9:  // pred: ^bb1
    llvm.return
  }
}

