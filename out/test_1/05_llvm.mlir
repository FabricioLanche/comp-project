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
    %24 = llvm.mlir.constant(4 : index) : i64
    %25 = llvm.mlir.constant(5 : index) : i64
    %26 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.mlir.constant(3 : index) : i64
    %29 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%27 : i64)
  ^bb1(%30: i64):  // 2 preds: ^bb0, ^bb5
    %31 = llvm.icmp "slt" %30, %28 : i64
    llvm.cond_br %31, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%27 : i64)
  ^bb3(%32: i64):  // 2 preds: ^bb2, ^bb4
    %33 = llvm.icmp "slt" %32, %25 : i64
    llvm.cond_br %33, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %34 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.mlir.constant(5 : index) : i64
    %36 = llvm.mul %30, %35  : i64
    %37 = llvm.add %36, %32  : i64
    %38 = llvm.getelementptr %34[%37] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %26, %38 : f32, !llvm.ptr
    %39 = llvm.add %32, %29  : i64
    llvm.br ^bb3(%39 : i64)
  ^bb5:  // pred: ^bb3
    %40 = llvm.add %30, %29  : i64
    llvm.br ^bb1(%40 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%27 : i64)
  ^bb7(%41: i64):  // 2 preds: ^bb6, ^bb14
    %42 = llvm.icmp "slt" %41, %28 : i64
    llvm.cond_br %42, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%27 : i64)
  ^bb9(%43: i64):  // 2 preds: ^bb8, ^bb13
    %44 = llvm.icmp "slt" %43, %25 : i64
    llvm.cond_br %44, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%27 : i64)
  ^bb11(%45: i64):  // 2 preds: ^bb10, ^bb12
    %46 = llvm.icmp "slt" %45, %24 : i64
    llvm.cond_br %46, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %47 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.mlir.constant(4 : index) : i64
    %49 = llvm.mul %41, %48  : i64
    %50 = llvm.add %49, %45  : i64
    %51 = llvm.getelementptr %47[%50] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %52 = llvm.load %51 : !llvm.ptr -> f32
    %53 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.mlir.constant(5 : index) : i64
    %55 = llvm.mul %45, %54  : i64
    %56 = llvm.add %55, %43  : i64
    %57 = llvm.getelementptr %53[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %58 = llvm.load %57 : !llvm.ptr -> f32
    %59 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.mlir.constant(5 : index) : i64
    %61 = llvm.mul %41, %60  : i64
    %62 = llvm.add %61, %43  : i64
    %63 = llvm.getelementptr %59[%62] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %64 = llvm.load %63 : !llvm.ptr -> f32
    %65 = llvm.fmul %52, %58  : f32
    %66 = llvm.fadd %64, %65  : f32
    %67 = llvm.extractvalue %23[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.mlir.constant(5 : index) : i64
    %69 = llvm.mul %41, %68  : i64
    %70 = llvm.add %69, %43  : i64
    %71 = llvm.getelementptr %67[%70] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %66, %71 : f32, !llvm.ptr
    %72 = llvm.add %45, %29  : i64
    llvm.br ^bb11(%72 : i64)
  ^bb13:  // pred: ^bb11
    %73 = llvm.add %43, %29  : i64
    llvm.br ^bb9(%73 : i64)
  ^bb14:  // pred: ^bb9
    %74 = llvm.add %41, %29  : i64
    llvm.br ^bb7(%74 : i64)
  ^bb15:  // pred: ^bb7
    llvm.return
  }
}

