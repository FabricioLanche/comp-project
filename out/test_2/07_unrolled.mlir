#map = affine_map<(d0) -> (d0 + 1)>
#map1 = affine_map<(d0) -> (d0 + 2)>
#map2 = affine_map<(d0) -> (d0 + 3)>
#map3 = affine_map<(d0) -> (d0 + 4)>
#map4 = affine_map<(d0) -> (d0 + 5)>
#map5 = affine_map<(d0) -> (d0 + 6)>
#map6 = affine_map<(d0) -> (d0 + 7)>
#map7 = affine_map<(d0) -> (d0 + 8)>
#map8 = affine_map<(d0) -> (d0 + 9)>
#map9 = affine_map<(d0) -> (d0 + 10)>
#map10 = affine_map<(d0) -> (d0 + 11)>
#map11 = affine_map<(d0) -> (d0 + 12)>
#map12 = affine_map<(d0) -> (d0 + 13)>
#map13 = affine_map<(d0) -> (d0 + 14)>
#map14 = affine_map<(d0) -> (d0 + 15)>
module {
  func.func @matmul_f32(%arg0: memref<8x16xf32>, %arg1: memref<16x32xf32>, %arg2: memref<8x32xf32>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg3 = 0 to 8 {
      affine.for %arg4 = 0 to 32 {
        affine.store %cst, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %0 = affine.load %arg0[%arg3, %c0] : memref<8x16xf32>
        %1 = affine.load %arg1[%c0, %arg4] : memref<16x32xf32>
        %2 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %3 = arith.mulf %0, %1 : f32
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %5 = affine.apply #map(%c0)
        %6 = affine.load %arg0[%arg3, %5] : memref<8x16xf32>
        %7 = affine.load %arg1[%5, %arg4] : memref<16x32xf32>
        %8 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %9 = arith.mulf %6, %7 : f32
        %10 = arith.addf %8, %9 : f32
        affine.store %10, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %11 = affine.apply #map1(%c0)
        %12 = affine.load %arg0[%arg3, %11] : memref<8x16xf32>
        %13 = affine.load %arg1[%11, %arg4] : memref<16x32xf32>
        %14 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %15 = arith.mulf %12, %13 : f32
        %16 = arith.addf %14, %15 : f32
        affine.store %16, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %17 = affine.apply #map2(%c0)
        %18 = affine.load %arg0[%arg3, %17] : memref<8x16xf32>
        %19 = affine.load %arg1[%17, %arg4] : memref<16x32xf32>
        %20 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %21 = arith.mulf %18, %19 : f32
        %22 = arith.addf %20, %21 : f32
        affine.store %22, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %23 = affine.apply #map3(%c0)
        %24 = affine.load %arg0[%arg3, %23] : memref<8x16xf32>
        %25 = affine.load %arg1[%23, %arg4] : memref<16x32xf32>
        %26 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %27 = arith.mulf %24, %25 : f32
        %28 = arith.addf %26, %27 : f32
        affine.store %28, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %29 = affine.apply #map4(%c0)
        %30 = affine.load %arg0[%arg3, %29] : memref<8x16xf32>
        %31 = affine.load %arg1[%29, %arg4] : memref<16x32xf32>
        %32 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %33 = arith.mulf %30, %31 : f32
        %34 = arith.addf %32, %33 : f32
        affine.store %34, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %35 = affine.apply #map5(%c0)
        %36 = affine.load %arg0[%arg3, %35] : memref<8x16xf32>
        %37 = affine.load %arg1[%35, %arg4] : memref<16x32xf32>
        %38 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %39 = arith.mulf %36, %37 : f32
        %40 = arith.addf %38, %39 : f32
        affine.store %40, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %41 = affine.apply #map6(%c0)
        %42 = affine.load %arg0[%arg3, %41] : memref<8x16xf32>
        %43 = affine.load %arg1[%41, %arg4] : memref<16x32xf32>
        %44 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %45 = arith.mulf %42, %43 : f32
        %46 = arith.addf %44, %45 : f32
        affine.store %46, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %47 = affine.apply #map7(%c0)
        %48 = affine.load %arg0[%arg3, %47] : memref<8x16xf32>
        %49 = affine.load %arg1[%47, %arg4] : memref<16x32xf32>
        %50 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %51 = arith.mulf %48, %49 : f32
        %52 = arith.addf %50, %51 : f32
        affine.store %52, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %53 = affine.apply #map8(%c0)
        %54 = affine.load %arg0[%arg3, %53] : memref<8x16xf32>
        %55 = affine.load %arg1[%53, %arg4] : memref<16x32xf32>
        %56 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %57 = arith.mulf %54, %55 : f32
        %58 = arith.addf %56, %57 : f32
        affine.store %58, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %59 = affine.apply #map9(%c0)
        %60 = affine.load %arg0[%arg3, %59] : memref<8x16xf32>
        %61 = affine.load %arg1[%59, %arg4] : memref<16x32xf32>
        %62 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %63 = arith.mulf %60, %61 : f32
        %64 = arith.addf %62, %63 : f32
        affine.store %64, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %65 = affine.apply #map10(%c0)
        %66 = affine.load %arg0[%arg3, %65] : memref<8x16xf32>
        %67 = affine.load %arg1[%65, %arg4] : memref<16x32xf32>
        %68 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %69 = arith.mulf %66, %67 : f32
        %70 = arith.addf %68, %69 : f32
        affine.store %70, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %71 = affine.apply #map11(%c0)
        %72 = affine.load %arg0[%arg3, %71] : memref<8x16xf32>
        %73 = affine.load %arg1[%71, %arg4] : memref<16x32xf32>
        %74 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %75 = arith.mulf %72, %73 : f32
        %76 = arith.addf %74, %75 : f32
        affine.store %76, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %77 = affine.apply #map12(%c0)
        %78 = affine.load %arg0[%arg3, %77] : memref<8x16xf32>
        %79 = affine.load %arg1[%77, %arg4] : memref<16x32xf32>
        %80 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %81 = arith.mulf %78, %79 : f32
        %82 = arith.addf %80, %81 : f32
        affine.store %82, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %83 = affine.apply #map13(%c0)
        %84 = affine.load %arg0[%arg3, %83] : memref<8x16xf32>
        %85 = affine.load %arg1[%83, %arg4] : memref<16x32xf32>
        %86 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %87 = arith.mulf %84, %85 : f32
        %88 = arith.addf %86, %87 : f32
        affine.store %88, %arg2[%arg3, %arg4] : memref<8x32xf32>
        %89 = affine.apply #map14(%c0)
        %90 = affine.load %arg0[%arg3, %89] : memref<8x16xf32>
        %91 = affine.load %arg1[%89, %arg4] : memref<16x32xf32>
        %92 = affine.load %arg2[%arg3, %arg4] : memref<8x32xf32>
        %93 = arith.mulf %90, %91 : f32
        %94 = arith.addf %92, %93 : f32
        affine.store %94, %arg2[%arg3, %arg4] : memref<8x32xf32>
      }
    }
    return
  }
}

