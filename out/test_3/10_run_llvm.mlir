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
    %24 = llvm.mlir.constant(16 : index) : i64
    %25 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %26 = llvm.mlir.constant(0 : index) : i64
    %27 = llvm.mlir.constant(8 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(32 : index) : i64
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
    %34 = llvm.mlir.constant(32 : index) : i64
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
    %46 = llvm.mlir.constant(16 : index) : i64
    %47 = llvm.mul %40, %46  : i64
    %48 = llvm.add %47, %44  : i64
    %49 = llvm.getelementptr %arg1[%48] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %50 = llvm.load %49 : !llvm.ptr -> f32
    %51 = llvm.mlir.constant(32 : index) : i64
    %52 = llvm.mul %44, %51  : i64
    %53 = llvm.add %52, %42  : i64
    %54 = llvm.getelementptr %arg8[%53] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %55 = llvm.load %54 : !llvm.ptr -> f32
    %56 = llvm.mlir.constant(32 : index) : i64
    %57 = llvm.mul %40, %56  : i64
    %58 = llvm.add %57, %42  : i64
    %59 = llvm.getelementptr %arg15[%58] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %60 = llvm.load %59 : !llvm.ptr -> f32
    %61 = llvm.fmul %50, %55  : f32
    %62 = llvm.fadd %60, %61  : f32
    %63 = llvm.mlir.constant(32 : index) : i64
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
    %0 = llvm.mlir.constant(32 : index) : i64
    %1 = llvm.mlir.constant(16 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.constant(8 : index) : i64
    %4 = llvm.mlir.constant(1 : i32) : i32
    %5 = llvm.mlir.constant(1.600000e+01 : f32) : f32
    %6 = llvm.mlir.constant(31 : index) : i64
    %7 = llvm.mlir.constant(7 : index) : i64
    %8 = llvm.mlir.constant(3 : index) : i64
    %9 = llvm.mlir.constant(0 : index) : i64
    %10 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %11 = llvm.mlir.constant(8 : index) : i64
    %12 = llvm.mlir.constant(16 : index) : i64
    %13 = llvm.mlir.constant(1 : index) : i64
    %14 = llvm.mlir.constant(128 : index) : i64
    %15 = llvm.mlir.zero : !llvm.ptr
    %16 = llvm.getelementptr %15[128] : (!llvm.ptr) -> !llvm.ptr, f32
    %17 = llvm.ptrtoint %16 : !llvm.ptr to i64
    %18 = llvm.call @malloc(%17) : (i64) -> !llvm.ptr
    %19 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %20 = llvm.insertvalue %18, %19[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %18, %20[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.mlir.constant(0 : index) : i64
    %23 = llvm.insertvalue %22, %21[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %11, %23[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %12, %24[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %12, %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.insertvalue %13, %26[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.mlir.constant(16 : index) : i64
    %29 = llvm.mlir.constant(32 : index) : i64
    %30 = llvm.mlir.constant(1 : index) : i64
    %31 = llvm.mlir.constant(512 : index) : i64
    %32 = llvm.mlir.zero : !llvm.ptr
    %33 = llvm.getelementptr %32[512] : (!llvm.ptr) -> !llvm.ptr, f32
    %34 = llvm.ptrtoint %33 : !llvm.ptr to i64
    %35 = llvm.call @malloc(%34) : (i64) -> !llvm.ptr
    %36 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %37 = llvm.insertvalue %35, %36[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %35, %37[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.mlir.constant(0 : index) : i64
    %40 = llvm.insertvalue %39, %38[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.insertvalue %28, %40[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.insertvalue %29, %41[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.insertvalue %29, %42[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.insertvalue %30, %43[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.mlir.constant(8 : index) : i64
    %46 = llvm.mlir.constant(32 : index) : i64
    %47 = llvm.mlir.constant(1 : index) : i64
    %48 = llvm.mlir.constant(256 : index) : i64
    %49 = llvm.mlir.zero : !llvm.ptr
    %50 = llvm.getelementptr %49[256] : (!llvm.ptr) -> !llvm.ptr, f32
    %51 = llvm.ptrtoint %50 : !llvm.ptr to i64
    %52 = llvm.call @malloc(%51) : (i64) -> !llvm.ptr
    %53 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %54 = llvm.insertvalue %52, %53[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.insertvalue %52, %54[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.mlir.constant(0 : index) : i64
    %57 = llvm.insertvalue %56, %55[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.insertvalue %45, %57[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %59 = llvm.insertvalue %46, %58[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.insertvalue %46, %59[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %61 = llvm.insertvalue %47, %60[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%9 : i64)
  ^bb1(%62: i64):  // 2 preds: ^bb0, ^bb5
    %63 = llvm.icmp "slt" %62, %3 : i64
    llvm.cond_br %63, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%9 : i64)
  ^bb3(%64: i64):  // 2 preds: ^bb2, ^bb4
    %65 = llvm.icmp "slt" %64, %1 : i64
    llvm.cond_br %65, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %66 = llvm.mlir.constant(16 : index) : i64
    %67 = llvm.mul %62, %66  : i64
    %68 = llvm.add %67, %64  : i64
    %69 = llvm.getelementptr %18[%68] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %10, %69 : f32, !llvm.ptr
    %70 = llvm.add %64, %2  : i64
    llvm.br ^bb3(%70 : i64)
  ^bb5:  // pred: ^bb3
    %71 = llvm.add %62, %2  : i64
    llvm.br ^bb1(%71 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%9 : i64)
  ^bb7(%72: i64):  // 2 preds: ^bb6, ^bb11
    %73 = llvm.icmp "slt" %72, %1 : i64
    llvm.cond_br %73, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%9 : i64)
  ^bb9(%74: i64):  // 2 preds: ^bb8, ^bb10
    %75 = llvm.icmp "slt" %74, %0 : i64
    llvm.cond_br %75, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %76 = llvm.mlir.constant(32 : index) : i64
    %77 = llvm.mul %72, %76  : i64
    %78 = llvm.add %77, %74  : i64
    %79 = llvm.getelementptr %35[%78] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %10, %79 : f32, !llvm.ptr
    %80 = llvm.add %74, %2  : i64
    llvm.br ^bb9(%80 : i64)
  ^bb11:  // pred: ^bb9
    %81 = llvm.add %72, %2  : i64
    llvm.br ^bb7(%81 : i64)
  ^bb12:  // pred: ^bb7
    %82 = llvm.extractvalue %27[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %83 = llvm.extractvalue %27[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.extractvalue %27[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.extractvalue %27[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.extractvalue %27[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.extractvalue %27[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %88 = llvm.extractvalue %27[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.extractvalue %44[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.extractvalue %44[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %91 = llvm.extractvalue %44[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.extractvalue %44[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.extractvalue %44[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %94 = llvm.extractvalue %44[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.extractvalue %44[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %96 = llvm.extractvalue %61[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.extractvalue %61[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %98 = llvm.extractvalue %61[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.extractvalue %61[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.extractvalue %61[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %101 = llvm.extractvalue %61[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %102 = llvm.extractvalue %61[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @matmul_f32(%82, %83, %84, %85, %86, %87, %88, %89, %90, %91, %92, %93, %94, %95, %96, %97, %98, %99, %100, %101, %102) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    %103 = llvm.mlir.constant(32 : index) : i64
    %104 = llvm.mul %9, %103  : i64
    %105 = llvm.add %104, %9  : i64
    %106 = llvm.getelementptr %52[%105] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %107 = llvm.load %106 : !llvm.ptr -> f32
    %108 = llvm.mlir.constant(32 : index) : i64
    %109 = llvm.mul %9, %108  : i64
    %110 = llvm.add %109, %6  : i64
    %111 = llvm.getelementptr %52[%110] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %112 = llvm.load %111 : !llvm.ptr -> f32
    %113 = llvm.mlir.constant(32 : index) : i64
    %114 = llvm.mul %7, %113  : i64
    %115 = llvm.add %114, %8  : i64
    %116 = llvm.getelementptr %52[%115] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %117 = llvm.load %116 : !llvm.ptr -> f32
    %118 = llvm.fcmp "oeq" %107, %5 : f32
    %119 = llvm.fcmp "oeq" %112, %5 : f32
    %120 = llvm.fcmp "oeq" %117, %5 : f32
    %121 = llvm.and %118, %119  : i1
    %122 = llvm.and %121, %120  : i1
    %123 = llvm.zext %122 : i1 to i32
    %124 = llvm.sub %4, %123  : i32
    llvm.call @free(%52) : (!llvm.ptr) -> ()
    llvm.call @free(%35) : (!llvm.ptr) -> ()
    llvm.call @free(%18) : (!llvm.ptr) -> ()
    llvm.return %124 : i32
  }
}

