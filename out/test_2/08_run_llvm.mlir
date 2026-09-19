module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @matmul_f32(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(512 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %4 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %5 = llvm.insertvalue %arg0, %4[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg1, %5[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg2, %6[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.insertvalue %arg3, %7[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %9 = llvm.insertvalue %arg5, %8[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg4, %9[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg6, %10[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %13 = llvm.insertvalue %arg7, %12[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg8, %13[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg9, %14[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %arg10, %15[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.insertvalue %arg12, %16[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg11, %17[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg13, %18[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %21 = llvm.insertvalue %arg14, %20[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg15, %21[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg16, %22[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %arg17, %23[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %arg19, %24[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %arg18, %25[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.insertvalue %arg20, %26[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%2 : i64)
  ^bb1(%28: i64):  // 2 preds: ^bb0, ^bb5
    %29 = llvm.icmp "slt" %28, %1 : i64
    llvm.cond_br %29, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%2 : i64)
  ^bb3(%30: i64):  // 2 preds: ^bb2, ^bb4
    %31 = llvm.icmp "slt" %30, %1 : i64
    llvm.cond_br %31, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %32 = llvm.mlir.constant(512 : index) : i64
    %33 = llvm.mul %28, %32  : i64
    %34 = llvm.add %33, %30  : i64
    %35 = llvm.getelementptr %arg15[%34] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %3, %35 : f32, !llvm.ptr
    %36 = llvm.add %30, %0  : i64
    llvm.br ^bb3(%36 : i64)
  ^bb5:  // pred: ^bb3
    %37 = llvm.add %28, %0  : i64
    llvm.br ^bb1(%37 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%2 : i64)
  ^bb7(%38: i64):  // 2 preds: ^bb6, ^bb14
    %39 = llvm.icmp "slt" %38, %1 : i64
    llvm.cond_br %39, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%2 : i64)
  ^bb9(%40: i64):  // 2 preds: ^bb8, ^bb13
    %41 = llvm.icmp "slt" %40, %1 : i64
    llvm.cond_br %41, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%2 : i64)
  ^bb11(%42: i64):  // 2 preds: ^bb10, ^bb12
    %43 = llvm.icmp "slt" %42, %1 : i64
    llvm.cond_br %43, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %44 = llvm.mlir.constant(512 : index) : i64
    %45 = llvm.mul %38, %44  : i64
    %46 = llvm.add %45, %42  : i64
    %47 = llvm.getelementptr %arg1[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %48 = llvm.load %47 : !llvm.ptr -> f32
    %49 = llvm.mlir.constant(512 : index) : i64
    %50 = llvm.mul %42, %49  : i64
    %51 = llvm.add %50, %40  : i64
    %52 = llvm.getelementptr %arg8[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %53 = llvm.load %52 : !llvm.ptr -> f32
    %54 = llvm.mlir.constant(512 : index) : i64
    %55 = llvm.mul %38, %54  : i64
    %56 = llvm.add %55, %40  : i64
    %57 = llvm.getelementptr %arg15[%56] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %58 = llvm.load %57 : !llvm.ptr -> f32
    %59 = llvm.fmul %48, %53  : f32
    %60 = llvm.fadd %58, %59  : f32
    %61 = llvm.mlir.constant(512 : index) : i64
    %62 = llvm.mul %38, %61  : i64
    %63 = llvm.add %62, %40  : i64
    %64 = llvm.getelementptr %arg15[%63] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %60, %64 : f32, !llvm.ptr
    %65 = llvm.add %42, %0  : i64
    llvm.br ^bb11(%65 : i64)
  ^bb13:  // pred: ^bb11
    %66 = llvm.add %40, %0  : i64
    llvm.br ^bb9(%66 : i64)
  ^bb14:  // pred: ^bb9
    %67 = llvm.add %38, %0  : i64
    llvm.br ^bb7(%67 : i64)
  ^bb15:  // pred: ^bb7
    llvm.return
  }
  llvm.func @main() -> i32 {
    %0 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(256 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(512 : index) : i64
    %5 = llvm.mlir.constant(1 : i32) : i32
    %6 = llvm.mlir.constant(5.120000e+02 : f32) : f32
    %7 = llvm.mlir.constant(511 : index) : i64
    %8 = llvm.mlir.constant(512 : index) : i64
    %9 = llvm.mlir.constant(512 : index) : i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = llvm.mlir.constant(262144 : index) : i64
    %12 = llvm.mlir.zero : !llvm.ptr
    %13 = llvm.getelementptr %12[262144] : (!llvm.ptr) -> !llvm.ptr, f32
    %14 = llvm.ptrtoint %13 : !llvm.ptr to i64
    %15 = llvm.call @malloc(%14) : (i64) -> !llvm.ptr
    %16 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %15, %16[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %15, %17[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.mlir.constant(0 : index) : i64
    %20 = llvm.insertvalue %19, %18[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %8, %20[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %9, %21[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %9, %22[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %10, %23[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mlir.constant(512 : index) : i64
    %26 = llvm.mlir.constant(512 : index) : i64
    %27 = llvm.mlir.constant(1 : index) : i64
    %28 = llvm.mlir.constant(262144 : index) : i64
    %29 = llvm.mlir.zero : !llvm.ptr
    %30 = llvm.getelementptr %29[262144] : (!llvm.ptr) -> !llvm.ptr, f32
    %31 = llvm.ptrtoint %30 : !llvm.ptr to i64
    %32 = llvm.call @malloc(%31) : (i64) -> !llvm.ptr
    %33 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %34 = llvm.insertvalue %32, %33[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.insertvalue %32, %34[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.mlir.constant(0 : index) : i64
    %37 = llvm.insertvalue %36, %35[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %25, %37[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %26, %38[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.insertvalue %26, %39[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.insertvalue %27, %40[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.mlir.constant(512 : index) : i64
    %43 = llvm.mlir.constant(512 : index) : i64
    %44 = llvm.mlir.constant(1 : index) : i64
    %45 = llvm.mlir.constant(262144 : index) : i64
    %46 = llvm.mlir.zero : !llvm.ptr
    %47 = llvm.getelementptr %46[262144] : (!llvm.ptr) -> !llvm.ptr, f32
    %48 = llvm.ptrtoint %47 : !llvm.ptr to i64
    %49 = llvm.call @malloc(%48) : (i64) -> !llvm.ptr
    %50 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %51 = llvm.insertvalue %49, %50[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.insertvalue %49, %51[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.mlir.constant(0 : index) : i64
    %54 = llvm.insertvalue %53, %52[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.insertvalue %42, %54[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.insertvalue %43, %55[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.insertvalue %43, %56[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.insertvalue %44, %57[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%1 : i64)
  ^bb1(%59: i64):  // 2 preds: ^bb0, ^bb5
    %60 = llvm.icmp "slt" %59, %4 : i64
    llvm.cond_br %60, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%1 : i64)
  ^bb3(%61: i64):  // 2 preds: ^bb2, ^bb4
    %62 = llvm.icmp "slt" %61, %4 : i64
    llvm.cond_br %62, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %63 = llvm.mlir.constant(512 : index) : i64
    %64 = llvm.mul %59, %63  : i64
    %65 = llvm.add %64, %61  : i64
    %66 = llvm.getelementptr %15[%65] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %0, %66 : f32, !llvm.ptr
    %67 = llvm.add %61, %3  : i64
    llvm.br ^bb3(%67 : i64)
  ^bb5:  // pred: ^bb3
    %68 = llvm.add %59, %3  : i64
    llvm.br ^bb1(%68 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%1 : i64)
  ^bb7(%69: i64):  // 2 preds: ^bb6, ^bb11
    %70 = llvm.icmp "slt" %69, %4 : i64
    llvm.cond_br %70, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%1 : i64)
  ^bb9(%71: i64):  // 2 preds: ^bb8, ^bb10
    %72 = llvm.icmp "slt" %71, %4 : i64
    llvm.cond_br %72, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %73 = llvm.mlir.constant(512 : index) : i64
    %74 = llvm.mul %69, %73  : i64
    %75 = llvm.add %74, %71  : i64
    %76 = llvm.getelementptr %32[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %0, %76 : f32, !llvm.ptr
    %77 = llvm.add %71, %3  : i64
    llvm.br ^bb9(%77 : i64)
  ^bb11:  // pred: ^bb9
    %78 = llvm.add %69, %3  : i64
    llvm.br ^bb7(%78 : i64)
  ^bb12:  // pred: ^bb7
    %79 = llvm.extractvalue %24[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %80 = llvm.extractvalue %24[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %81 = llvm.extractvalue %24[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %82 = llvm.extractvalue %24[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %83 = llvm.extractvalue %24[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.extractvalue %24[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %85 = llvm.extractvalue %24[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.extractvalue %41[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.extractvalue %41[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %88 = llvm.extractvalue %41[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.extractvalue %41[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.extractvalue %41[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %91 = llvm.extractvalue %41[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.extractvalue %41[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %93 = llvm.extractvalue %58[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %94 = llvm.extractvalue %58[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %95 = llvm.extractvalue %58[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %96 = llvm.extractvalue %58[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.extractvalue %58[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %98 = llvm.extractvalue %58[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.extractvalue %58[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @matmul_f32(%79, %80, %81, %82, %83, %84, %85, %86, %87, %88, %89, %90, %91, %92, %93, %94, %95, %96, %97, %98, %99) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i64, i64) -> ()
    %100 = llvm.mlir.constant(512 : index) : i64
    %101 = llvm.mul %1, %100  : i64
    %102 = llvm.add %101, %1  : i64
    %103 = llvm.getelementptr %49[%102] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %104 = llvm.load %103 : !llvm.ptr -> f32
    %105 = llvm.mlir.constant(512 : index) : i64
    %106 = llvm.mul %1, %105  : i64
    %107 = llvm.add %106, %7  : i64
    %108 = llvm.getelementptr %49[%107] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %109 = llvm.load %108 : !llvm.ptr -> f32
    %110 = llvm.mlir.constant(512 : index) : i64
    %111 = llvm.mul %7, %110  : i64
    %112 = llvm.add %111, %2  : i64
    %113 = llvm.getelementptr %49[%112] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %114 = llvm.load %113 : !llvm.ptr -> f32
    %115 = llvm.fcmp "oeq" %104, %6 : f32
    %116 = llvm.fcmp "oeq" %109, %6 : f32
    %117 = llvm.fcmp "oeq" %114, %6 : f32
    %118 = llvm.and %115, %116  : i1
    %119 = llvm.and %118, %117  : i1
    %120 = llvm.zext %119 : i1 to i32
    %121 = llvm.sub %5, %120  : i32
    llvm.call @free(%49) : (!llvm.ptr) -> ()
    llvm.call @free(%32) : (!llvm.ptr) -> ()
    llvm.call @free(%15) : (!llvm.ptr) -> ()
    llvm.return %121 : i32
  }
}

