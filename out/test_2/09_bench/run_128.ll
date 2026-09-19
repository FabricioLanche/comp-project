; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare void @free(ptr)

declare ptr @malloc(i64)

define void @matmul_f32(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) {
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %0, 0
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, ptr %1, 1
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 %2, 2
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %3, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %5, 4, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %4, 3, 1
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %6, 4, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %7, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %8, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %9, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %10, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %12, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %11, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 %13, 4, 1
  %36 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %14, 0
  %37 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %36, ptr %15, 1
  %38 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %37, i64 %16, 2
  %39 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %38, i64 %17, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %39, i64 %19, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %40, i64 %18, 3, 1
  %42 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %41, i64 %20, 4, 1
  br label %43

43:                                               ; preds = %55, %21
  %44 = phi i64 [ %56, %55 ], [ 0, %21 ]
  %45 = icmp slt i64 %44, 128
  br i1 %45, label %46, label %57

46:                                               ; preds = %43
  br label %47

47:                                               ; preds = %50, %46
  %48 = phi i64 [ %54, %50 ], [ 0, %46 ]
  %49 = icmp slt i64 %48, 128
  br i1 %49, label %50, label %55

50:                                               ; preds = %47
  %51 = mul i64 %44, 128
  %52 = add i64 %51, %48
  %53 = getelementptr float, ptr %15, i64 %52
  store float 0.000000e+00, ptr %53, align 4
  %54 = add i64 %48, 1
  br label %47

55:                                               ; preds = %47
  %56 = add i64 %44, 1
  br label %43

57:                                               ; preds = %43
  br label %58

58:                                               ; preds = %90, %57
  %59 = phi i64 [ %91, %90 ], [ 0, %57 ]
  %60 = icmp slt i64 %59, 128
  br i1 %60, label %61, label %92

61:                                               ; preds = %58
  br label %62

62:                                               ; preds = %88, %61
  %63 = phi i64 [ %89, %88 ], [ 0, %61 ]
  %64 = icmp slt i64 %63, 128
  br i1 %64, label %65, label %90

65:                                               ; preds = %62
  br label %66

66:                                               ; preds = %69, %65
  %67 = phi i64 [ %87, %69 ], [ 0, %65 ]
  %68 = icmp slt i64 %67, 128
  br i1 %68, label %69, label %88

69:                                               ; preds = %66
  %70 = mul i64 %59, 128
  %71 = add i64 %70, %67
  %72 = getelementptr float, ptr %1, i64 %71
  %73 = load float, ptr %72, align 4
  %74 = mul i64 %67, 128
  %75 = add i64 %74, %63
  %76 = getelementptr float, ptr %8, i64 %75
  %77 = load float, ptr %76, align 4
  %78 = mul i64 %59, 128
  %79 = add i64 %78, %63
  %80 = getelementptr float, ptr %15, i64 %79
  %81 = load float, ptr %80, align 4
  %82 = fmul float %73, %77
  %83 = fadd float %81, %82
  %84 = mul i64 %59, 128
  %85 = add i64 %84, %63
  %86 = getelementptr float, ptr %15, i64 %85
  store float %83, ptr %86, align 4
  %87 = add i64 %67, 1
  br label %66

88:                                               ; preds = %66
  %89 = add i64 %63, 1
  br label %62

90:                                               ; preds = %62
  %91 = add i64 %59, 1
  br label %58

92:                                               ; preds = %58
  ret void
}

define i32 @main() {
  %1 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i32 16384) to i64))
  %2 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, i64 128, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, i64 128, 3, 1
  %7 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %6, i64 128, 4, 0
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, i64 1, 4, 1
  %9 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i32 16384) to i64))
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %9, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %9, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 0, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 128, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 128, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 128, 4, 0
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 1, 4, 1
  %17 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i32 16384) to i64))
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %17, 0
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, ptr %17, 1
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 0, 2
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 128, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 128, 3, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, i64 128, 4, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 1, 4, 1
  br label %25

25:                                               ; preds = %37, %0
  %26 = phi i64 [ %38, %37 ], [ 0, %0 ]
  %27 = icmp slt i64 %26, 128
  br i1 %27, label %28, label %39

28:                                               ; preds = %25
  br label %29

29:                                               ; preds = %32, %28
  %30 = phi i64 [ %36, %32 ], [ 0, %28 ]
  %31 = icmp slt i64 %30, 128
  br i1 %31, label %32, label %37

32:                                               ; preds = %29
  %33 = mul i64 %26, 128
  %34 = add i64 %33, %30
  %35 = getelementptr float, ptr %1, i64 %34
  store float 1.000000e+00, ptr %35, align 4
  %36 = add i64 %30, 1
  br label %29

37:                                               ; preds = %29
  %38 = add i64 %26, 1
  br label %25

39:                                               ; preds = %25
  br label %40

40:                                               ; preds = %52, %39
  %41 = phi i64 [ %53, %52 ], [ 0, %39 ]
  %42 = icmp slt i64 %41, 128
  br i1 %42, label %43, label %54

43:                                               ; preds = %40
  br label %44

44:                                               ; preds = %47, %43
  %45 = phi i64 [ %51, %47 ], [ 0, %43 ]
  %46 = icmp slt i64 %45, 128
  br i1 %46, label %47, label %52

47:                                               ; preds = %44
  %48 = mul i64 %41, 128
  %49 = add i64 %48, %45
  %50 = getelementptr float, ptr %9, i64 %49
  store float 1.000000e+00, ptr %50, align 4
  %51 = add i64 %45, 1
  br label %44

52:                                               ; preds = %44
  %53 = add i64 %41, 1
  br label %40

54:                                               ; preds = %40
  %55 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 0
  %56 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 1
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 2
  %58 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 3, 0
  %59 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 3, 1
  %60 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 4, 0
  %61 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %8, 4, 1
  %62 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 0
  %63 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %64 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 2
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 0
  %66 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 1
  %67 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 0
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 1
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 0
  %70 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %71 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 2
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 3, 0
  %73 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 3, 1
  %74 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 4, 0
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 4, 1
  call void @matmul_f32(ptr %55, ptr %56, i64 %57, i64 %58, i64 %59, i64 %60, i64 %61, ptr %62, ptr %63, i64 %64, i64 %65, i64 %66, i64 %67, i64 %68, ptr %69, ptr %70, i64 %71, i64 %72, i64 %73, i64 %74, i64 %75)
  %76 = getelementptr float, ptr %17, i64 0
  %77 = load float, ptr %76, align 4
  %78 = getelementptr float, ptr %17, i64 127
  %79 = load float, ptr %78, align 4
  %80 = getelementptr float, ptr %17, i64 16320
  %81 = load float, ptr %80, align 4
  %82 = fcmp oeq float %77, 1.280000e+02
  %83 = fcmp oeq float %79, 1.280000e+02
  %84 = fcmp oeq float %81, 1.280000e+02
  %85 = and i1 %82, %83
  %86 = and i1 %85, %84
  %87 = zext i1 %86 to i32
  %88 = sub i32 1, %87
  call void @free(ptr %17)
  call void @free(ptr %9)
  call void @free(ptr %1)
  ret i32 %88
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
