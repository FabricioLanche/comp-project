module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
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
    %25 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %26 = llvm.mlir.constant(0 : index) : i64
    %27 = llvm.mlir.constant(3 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(5 : index) : i64
    llvm.br ^bb1(%26 : i64)
  ^bb1(%30: i64):  // 2 preds: ^bb0, ^bb5
    %31 = llvm.icmp "slt" %30, %27 : i64
    llvm.cond_br %31, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%26 : i64)
  ^bb3(%32: i64):  // 2 preds: ^bb2, ^bb4
    %33 = llvm.icmp "slt" %32, %29 : i64
    llvm.cond_br %33, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %34 = llvm.mlir.constant(5 : index) : i64
    %35 = llvm.mul %30, %34  : i64
    %36 = llvm.add %35, %32  : i64
    %37 = llvm.getelementptr %arg15[%36] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %25, %37 : f32, !llvm.ptr
    %38 = llvm.add %32, %28  : i64
    llvm.br ^bb3(%38 : i64)
  ^bb5:  // pred: ^bb3
    %39 = llvm.add %30, %28  : i64
    llvm.br ^bb1(%39 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%26 : i64)
  ^bb7(%40: i64):  // 2 preds: ^bb6, ^bb14
    %41 = llvm.icmp "slt" %40, %27 : i64
    llvm.cond_br %41, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%26 : i64)
  ^bb9(%42: i64):  // 2 preds: ^bb8, ^bb13
    %43 = llvm.icmp "slt" %42, %29 : i64
    llvm.cond_br %43, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%26 : i64)
  ^bb11(%44: i64):  // 2 preds: ^bb10, ^bb12
    %45 = llvm.icmp "slt" %44, %24 : i64
    llvm.cond_br %45, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %46 = llvm.mlir.constant(4 : index) : i64
    %47 = llvm.mul %40, %46  : i64
    %48 = llvm.add %47, %44  : i64
    %49 = llvm.getelementptr %arg1[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %50 = llvm.load %49 : !llvm.ptr -> f32
    %51 = llvm.mlir.constant(5 : index) : i64
    %52 = llvm.mul %44, %51  : i64
    %53 = llvm.add %52, %42  : i64
    %54 = llvm.getelementptr %arg8[%53] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %55 = llvm.load %54 : !llvm.ptr -> f32
    %56 = llvm.mlir.constant(5 : index) : i64
    %57 = llvm.mul %40, %56  : i64
    %58 = llvm.add %57, %42  : i64
    %59 = llvm.getelementptr %arg15[%58] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %60 = llvm.load %59 : !llvm.ptr -> f32
    %61 = llvm.fmul %50, %55  : f32
    %62 = llvm.fadd %60, %61  : f32
    %63 = llvm.mlir.constant(5 : index) : i64
    %64 = llvm.mul %40, %63  : i64
    %65 = llvm.add %64, %42  : i64
    %66 = llvm.getelementptr %arg15[%65] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %62, %66 : f32, !llvm.ptr
    %67 = llvm.add %44, %28  : i64
    llvm.br ^bb11(%67 : i64)
  ^bb13:  // pred: ^bb11
    %68 = llvm.add %42, %28  : i64
    llvm.br ^bb9(%68 : i64)
  ^bb14:  // pred: ^bb9
    %69 = llvm.add %40, %28  : i64
    llvm.br ^bb7(%69 : i64)
  ^bb15:  // pred: ^bb7
    llvm.return
  }
  llvm.func @main() -> i32 {
    %0 = llvm.mlir.constant(5 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(3 : index) : i64
    %3 = llvm.mlir.constant(1 : i32) : i32
    %4 = llvm.mlir.constant(4.000000e+00 : f32) : f32
    %5 = llvm.mlir.constant(4 : index) : i64
    %6 = llvm.mlir.constant(2 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(3 : index) : i64
    %10 = llvm.mlir.constant(4 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(12 : index) : i64
    %13 = llvm.mlir.zero : !llvm.ptr
    %14 = llvm.getelementptr %13[12] : (!llvm.ptr) -> !llvm.ptr, f32
    %15 = llvm.ptrtoint %14 : !llvm.ptr to i64
    %16 = llvm.call @malloc(%15) : (i64) -> !llvm.ptr
    %17 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %18 = llvm.insertvalue %16, %17[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %16, %18[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mlir.constant(0 : index) : i64
    %21 = llvm.insertvalue %20, %19[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %9, %21[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %10, %22[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %10, %23[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %11, %24[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.mlir.constant(4 : index) : i64
    %27 = llvm.mlir.constant(5 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(20 : index) : i64
    %30 = llvm.mlir.zero : !llvm.ptr
    %31 = llvm.getelementptr %30[20] : (!llvm.ptr) -> !llvm.ptr, f32
    %32 = llvm.ptrtoint %31 : !llvm.ptr to i64
    %33 = llvm.call @malloc(%32) : (i64) -> !llvm.ptr
    %34 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %35 = llvm.insertvalue %33, %34[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %33, %35[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.mlir.constant(0 : index) : i64
    %38 = llvm.insertvalue %37, %36[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %26, %38[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.insertvalue %27, %39[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.insertvalue %27, %40[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.insertvalue %28, %41[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.mlir.constant(3 : index) : i64
    %44 = llvm.mlir.constant(5 : index) : i64
    %45 = llvm.mlir.constant(1 : index) : i64
    %46 = llvm.mlir.constant(15 : index) : i64
    %47 = llvm.mlir.zero : !llvm.ptr
    %48 = llvm.getelementptr %47[15] : (!llvm.ptr) -> !llvm.ptr, f32
    %49 = llvm.ptrtoint %48 : !llvm.ptr to i64
    %50 = llvm.call @malloc(%49) : (i64) -> !llvm.ptr
    %51 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %52 = llvm.insertvalue %50, %51[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.insertvalue %50, %52[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.mlir.constant(0 : index) : i64
    %55 = llvm.insertvalue %54, %53[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.insertvalue %43, %55[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.insertvalue %44, %56[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.insertvalue %44, %57[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %59 = llvm.insertvalue %45, %58[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%7 : i64)
  ^bb1(%60: i64):  // 2 preds: ^bb0, ^bb5
    %61 = llvm.icmp "slt" %60, %2 : i64
    llvm.cond_br %61, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%7 : i64)
  ^bb3(%62: i64):  // 2 preds: ^bb2, ^bb4
    %63 = llvm.icmp "slt" %62, %5 : i64
    llvm.cond_br %63, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %64 = llvm.mlir.constant(4 : index) : i64
    %65 = llvm.mul %60, %64  : i64
    %66 = llvm.add %65, %62  : i64
    %67 = llvm.getelementptr %16[%66] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %8, %67 : f32, !llvm.ptr
    %68 = llvm.add %62, %1  : i64
    llvm.br ^bb3(%68 : i64)
  ^bb5:  // pred: ^bb3
    %69 = llvm.add %60, %1  : i64
    llvm.br ^bb1(%69 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%7 : i64)
  ^bb7(%70: i64):  // 2 preds: ^bb6, ^bb11
    %71 = llvm.icmp "slt" %70, %5 : i64
    llvm.cond_br %71, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%7 : i64)
  ^bb9(%72: i64):  // 2 preds: ^bb8, ^bb10
    %73 = llvm.icmp "slt" %72, %0 : i64
    llvm.cond_br %73, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %74 = llvm.mlir.constant(5 : index) : i64
    %75 = llvm.mul %70, %74  : i64
    %76 = llvm.add %75, %72  : i64
    %77 = llvm.getelementptr %33[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %8, %77 : f32, !llvm.ptr
    %78 = llvm.add %72, %1  : i64
    llvm.br ^bb9(%78 : i64)
  ^bb11:  // pred: ^bb9
    %79 = llvm.add %70, %1  : i64
    llvm.br ^bb7(%79 : i64)
  ^bb12:  // pred: ^bb7
    %80 = llvm.extractvalue %25[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %81 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %82 = llvm.extractvalue %25[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %83 = llvm.extractvalue %25[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.extractvalue %25[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.extractvalue %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.extractvalue %25[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.extractvalue %42[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %88 = llvm.extractvalue %42[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.extractvalue %42[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.extractvalue %42[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %91 = llvm.extractvalue %42[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.extractvalue %42[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.extractvalue %42[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %94 = llvm.extractvalue %59[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.extractvalue %59[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %96 = llvm.extractvalue %59[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.extractvalue %59[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %98 = llvm.extractvalue %59[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.extractvalue %59[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.extractvalue %59[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @matmul_f32(%80, %81, %82, %83, %84, %85, %86, %87, %88, %89, %90, %91, %92, %93, %94, %95, %96, %97, %98, %99, %100) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    %101 = llvm.mlir.constant(5 : index) : i64
    %102 = llvm.mul %7, %101  : i64
    %103 = llvm.add %102, %7  : i64
    %104 = llvm.getelementptr %50[%103] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %105 = llvm.load %104 : !llvm.ptr -> f32
    %106 = llvm.mlir.constant(5 : index) : i64
    %107 = llvm.mul %7, %106  : i64
    %108 = llvm.add %107, %5  : i64
    %109 = llvm.getelementptr %50[%108] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %110 = llvm.load %109 : !llvm.ptr -> f32
    %111 = llvm.mlir.constant(5 : index) : i64
    %112 = llvm.mul %6, %111  : i64
    %113 = llvm.add %112, %6  : i64
    %114 = llvm.getelementptr %50[%113] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %115 = llvm.load %114 : !llvm.ptr -> f32
    %116 = llvm.fcmp "oeq" %105, %4 : f32
    %117 = llvm.fcmp "oeq" %110, %4 : f32
    %118 = llvm.fcmp "oeq" %115, %4 : f32
    %119 = llvm.and %116, %117  : i1
    %120 = llvm.and %119, %118  : i1
    %121 = llvm.zext %120 : i1 to i32
    %122 = llvm.sub %3, %121  : i32
    llvm.call @free(%50) : (!llvm.ptr) -> ()
    llvm.call @free(%33) : (!llvm.ptr) -> ()
    llvm.call @free(%16) : (!llvm.ptr) -> ()
    llvm.return %122 : i32
  }
}

