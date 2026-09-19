#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_sstr(%arg0: tensor<64x64xf32>, %arg1: tensor<64x64xf32>, %arg2: tensor<64x64xf32>) -> tensor<64x64xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    %extracted_slice = tensor.extract_slice %arg0[0, 0] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_0 = tensor.extract_slice %arg0[32, 0] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_1 = tensor.extract_slice %arg0[0, 32] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_2 = tensor.extract_slice %arg0[32, 32] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_3 = tensor.extract_slice %arg1[0, 0] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_4 = tensor.extract_slice %arg1[32, 0] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_5 = tensor.extract_slice %arg1[0, 32] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %extracted_slice_6 = tensor.extract_slice %arg1[32, 32] [32, 32] [1, 1] : tensor<64x64xf32> to tensor<32x32xf32>
    %0 = tensor.empty() : tensor<32x32xf32>
    %1 = linalg.fill ins(%cst : f32) outs(%0 : tensor<32x32xf32>) -> tensor<32x32xf32>
    %2 = tensor.empty() : tensor<32x32xf32>
    %3 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_3, %extracted_slice_6 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%2 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %4 = tensor.empty() : tensor<32x32xf32>
    %5 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice, %extracted_slice_2 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%4 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_7 = tensor.extract_slice %5[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_8 = tensor.extract_slice %5[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_9 = tensor.extract_slice %5[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_10 = tensor.extract_slice %5[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_11 = tensor.extract_slice %3[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_12 = tensor.extract_slice %3[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_13 = tensor.extract_slice %3[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_14 = tensor.extract_slice %3[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %6 = tensor.empty() : tensor<16x16xf32>
    %7 = linalg.fill ins(%cst : f32) outs(%6 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %8 = tensor.empty() : tensor<16x16xf32>
    %9 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_11, %extracted_slice_14 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%8 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %10 = tensor.empty() : tensor<16x16xf32>
    %11 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_7, %extracted_slice_10 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%10 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %12 = linalg.matmul ins(%11, %9 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %13 = tensor.empty() : tensor<16x16xf32>
    %14 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_8, %extracted_slice_10 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%13 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %15 = linalg.matmul ins(%14, %extracted_slice_11 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %16 = tensor.empty() : tensor<16x16xf32>
    %17 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_13, %extracted_slice_14 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%16 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %18 = linalg.matmul ins(%extracted_slice_7, %17 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %19 = tensor.empty() : tensor<16x16xf32>
    %20 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_12, %extracted_slice_11 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%19 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %21 = linalg.matmul ins(%extracted_slice_10, %20 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %22 = tensor.empty() : tensor<16x16xf32>
    %23 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_7, %extracted_slice_9 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%22 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %24 = linalg.matmul ins(%23, %extracted_slice_14 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %25 = tensor.empty() : tensor<16x16xf32>
    %26 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_11, %extracted_slice_13 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%25 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %27 = tensor.empty() : tensor<16x16xf32>
    %28 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_8, %extracted_slice_7 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%27 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %29 = linalg.matmul ins(%28, %26 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %30 = tensor.empty() : tensor<16x16xf32>
    %31 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_12, %extracted_slice_14 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%30 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %32 = tensor.empty() : tensor<16x16xf32>
    %33 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_9, %extracted_slice_10 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%32 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %34 = linalg.matmul ins(%33, %31 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%7 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %35 = tensor.empty() : tensor<16x16xf32>
    %36 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%12, %21 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%35 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %37 = tensor.empty() : tensor<16x16xf32>
    %38 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%36, %24 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%37 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %39 = tensor.empty() : tensor<16x16xf32>
    %40 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%38, %34 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%39 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %41 = tensor.empty() : tensor<16x16xf32>
    %42 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%18, %24 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%41 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %43 = tensor.empty() : tensor<16x16xf32>
    %44 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%15, %21 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%43 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %45 = tensor.empty() : tensor<16x16xf32>
    %46 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%12, %15 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%45 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %47 = tensor.empty() : tensor<16x16xf32>
    %48 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%46, %18 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%47 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %49 = tensor.empty() : tensor<16x16xf32>
    %50 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%48, %29 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%49 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice = tensor.insert_slice %40 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_15 = tensor.insert_slice %42 into %inserted_slice[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_16 = tensor.insert_slice %44 into %inserted_slice_15[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_17 = tensor.insert_slice %50 into %inserted_slice_16[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %51 = tensor.empty() : tensor<32x32xf32>
    %52 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_0, %extracted_slice_2 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%51 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_18 = tensor.extract_slice %52[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_19 = tensor.extract_slice %52[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_20 = tensor.extract_slice %52[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_21 = tensor.extract_slice %52[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_22 = tensor.extract_slice %extracted_slice_3[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_23 = tensor.extract_slice %extracted_slice_3[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_24 = tensor.extract_slice %extracted_slice_3[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_25 = tensor.extract_slice %extracted_slice_3[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %53 = tensor.empty() : tensor<16x16xf32>
    %54 = linalg.fill ins(%cst : f32) outs(%53 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %55 = tensor.empty() : tensor<16x16xf32>
    %56 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_22, %extracted_slice_25 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%55 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %57 = tensor.empty() : tensor<16x16xf32>
    %58 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_18, %extracted_slice_21 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%57 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %59 = linalg.matmul ins(%58, %56 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %60 = tensor.empty() : tensor<16x16xf32>
    %61 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_19, %extracted_slice_21 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%60 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %62 = linalg.matmul ins(%61, %extracted_slice_22 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %63 = tensor.empty() : tensor<16x16xf32>
    %64 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_24, %extracted_slice_25 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%63 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %65 = linalg.matmul ins(%extracted_slice_18, %64 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %66 = tensor.empty() : tensor<16x16xf32>
    %67 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_23, %extracted_slice_22 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%66 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %68 = linalg.matmul ins(%extracted_slice_21, %67 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %69 = tensor.empty() : tensor<16x16xf32>
    %70 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_18, %extracted_slice_20 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%69 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %71 = linalg.matmul ins(%70, %extracted_slice_25 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %72 = tensor.empty() : tensor<16x16xf32>
    %73 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_22, %extracted_slice_24 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%72 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %74 = tensor.empty() : tensor<16x16xf32>
    %75 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_19, %extracted_slice_18 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%74 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %76 = linalg.matmul ins(%75, %73 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %77 = tensor.empty() : tensor<16x16xf32>
    %78 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_23, %extracted_slice_25 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%77 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %79 = tensor.empty() : tensor<16x16xf32>
    %80 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_20, %extracted_slice_21 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%79 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %81 = linalg.matmul ins(%80, %78 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%54 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %82 = tensor.empty() : tensor<16x16xf32>
    %83 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%59, %68 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%82 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %84 = tensor.empty() : tensor<16x16xf32>
    %85 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%83, %71 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%84 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %86 = tensor.empty() : tensor<16x16xf32>
    %87 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%85, %81 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%86 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %88 = tensor.empty() : tensor<16x16xf32>
    %89 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%65, %71 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%88 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %90 = tensor.empty() : tensor<16x16xf32>
    %91 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%62, %68 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%90 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %92 = tensor.empty() : tensor<16x16xf32>
    %93 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%59, %62 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%92 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %94 = tensor.empty() : tensor<16x16xf32>
    %95 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%93, %65 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%94 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %96 = tensor.empty() : tensor<16x16xf32>
    %97 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%95, %76 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%96 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_26 = tensor.insert_slice %87 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_27 = tensor.insert_slice %89 into %inserted_slice_26[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_28 = tensor.insert_slice %91 into %inserted_slice_27[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_29 = tensor.insert_slice %97 into %inserted_slice_28[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %98 = tensor.empty() : tensor<32x32xf32>
    %99 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_5, %extracted_slice_6 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%98 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_30 = tensor.extract_slice %extracted_slice[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_31 = tensor.extract_slice %extracted_slice[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_32 = tensor.extract_slice %extracted_slice[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_33 = tensor.extract_slice %extracted_slice[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_34 = tensor.extract_slice %99[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_35 = tensor.extract_slice %99[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_36 = tensor.extract_slice %99[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_37 = tensor.extract_slice %99[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %100 = tensor.empty() : tensor<16x16xf32>
    %101 = linalg.fill ins(%cst : f32) outs(%100 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %102 = tensor.empty() : tensor<16x16xf32>
    %103 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_34, %extracted_slice_37 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%102 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %104 = tensor.empty() : tensor<16x16xf32>
    %105 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_30, %extracted_slice_33 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%104 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %106 = linalg.matmul ins(%105, %103 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %107 = tensor.empty() : tensor<16x16xf32>
    %108 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_31, %extracted_slice_33 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%107 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %109 = linalg.matmul ins(%108, %extracted_slice_34 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %110 = tensor.empty() : tensor<16x16xf32>
    %111 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_36, %extracted_slice_37 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%110 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %112 = linalg.matmul ins(%extracted_slice_30, %111 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %113 = tensor.empty() : tensor<16x16xf32>
    %114 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_35, %extracted_slice_34 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%113 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %115 = linalg.matmul ins(%extracted_slice_33, %114 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %116 = tensor.empty() : tensor<16x16xf32>
    %117 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_30, %extracted_slice_32 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%116 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %118 = linalg.matmul ins(%117, %extracted_slice_37 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %119 = tensor.empty() : tensor<16x16xf32>
    %120 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_34, %extracted_slice_36 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%119 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %121 = tensor.empty() : tensor<16x16xf32>
    %122 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_31, %extracted_slice_30 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%121 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %123 = linalg.matmul ins(%122, %120 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %124 = tensor.empty() : tensor<16x16xf32>
    %125 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_35, %extracted_slice_37 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%124 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %126 = tensor.empty() : tensor<16x16xf32>
    %127 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_32, %extracted_slice_33 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%126 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %128 = linalg.matmul ins(%127, %125 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%101 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %129 = tensor.empty() : tensor<16x16xf32>
    %130 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%106, %115 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%129 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %131 = tensor.empty() : tensor<16x16xf32>
    %132 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%130, %118 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%131 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %133 = tensor.empty() : tensor<16x16xf32>
    %134 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%132, %128 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%133 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %135 = tensor.empty() : tensor<16x16xf32>
    %136 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%112, %118 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%135 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %137 = tensor.empty() : tensor<16x16xf32>
    %138 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%109, %115 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%137 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %139 = tensor.empty() : tensor<16x16xf32>
    %140 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%106, %109 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%139 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %141 = tensor.empty() : tensor<16x16xf32>
    %142 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%140, %112 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%141 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %143 = tensor.empty() : tensor<16x16xf32>
    %144 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%142, %123 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%143 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_38 = tensor.insert_slice %134 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_39 = tensor.insert_slice %136 into %inserted_slice_38[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_40 = tensor.insert_slice %138 into %inserted_slice_39[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_41 = tensor.insert_slice %144 into %inserted_slice_40[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %145 = tensor.empty() : tensor<32x32xf32>
    %146 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_4, %extracted_slice_3 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%145 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_42 = tensor.extract_slice %extracted_slice_2[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_43 = tensor.extract_slice %extracted_slice_2[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_44 = tensor.extract_slice %extracted_slice_2[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_45 = tensor.extract_slice %extracted_slice_2[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_46 = tensor.extract_slice %146[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_47 = tensor.extract_slice %146[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_48 = tensor.extract_slice %146[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_49 = tensor.extract_slice %146[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %147 = tensor.empty() : tensor<16x16xf32>
    %148 = linalg.fill ins(%cst : f32) outs(%147 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %149 = tensor.empty() : tensor<16x16xf32>
    %150 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_46, %extracted_slice_49 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%149 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %151 = tensor.empty() : tensor<16x16xf32>
    %152 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_42, %extracted_slice_45 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%151 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %153 = linalg.matmul ins(%152, %150 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %154 = tensor.empty() : tensor<16x16xf32>
    %155 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_43, %extracted_slice_45 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%154 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %156 = linalg.matmul ins(%155, %extracted_slice_46 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %157 = tensor.empty() : tensor<16x16xf32>
    %158 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_48, %extracted_slice_49 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%157 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %159 = linalg.matmul ins(%extracted_slice_42, %158 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %160 = tensor.empty() : tensor<16x16xf32>
    %161 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_47, %extracted_slice_46 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%160 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %162 = linalg.matmul ins(%extracted_slice_45, %161 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %163 = tensor.empty() : tensor<16x16xf32>
    %164 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_42, %extracted_slice_44 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%163 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %165 = linalg.matmul ins(%164, %extracted_slice_49 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %166 = tensor.empty() : tensor<16x16xf32>
    %167 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_46, %extracted_slice_48 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%166 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %168 = tensor.empty() : tensor<16x16xf32>
    %169 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_43, %extracted_slice_42 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%168 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %170 = linalg.matmul ins(%169, %167 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %171 = tensor.empty() : tensor<16x16xf32>
    %172 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_47, %extracted_slice_49 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%171 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %173 = tensor.empty() : tensor<16x16xf32>
    %174 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_44, %extracted_slice_45 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%173 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %175 = linalg.matmul ins(%174, %172 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%148 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %176 = tensor.empty() : tensor<16x16xf32>
    %177 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%153, %162 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%176 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %178 = tensor.empty() : tensor<16x16xf32>
    %179 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%177, %165 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%178 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %180 = tensor.empty() : tensor<16x16xf32>
    %181 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%179, %175 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%180 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %182 = tensor.empty() : tensor<16x16xf32>
    %183 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%159, %165 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%182 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %184 = tensor.empty() : tensor<16x16xf32>
    %185 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%156, %162 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%184 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %186 = tensor.empty() : tensor<16x16xf32>
    %187 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%153, %156 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%186 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %188 = tensor.empty() : tensor<16x16xf32>
    %189 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%187, %159 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%188 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %190 = tensor.empty() : tensor<16x16xf32>
    %191 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%189, %170 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%190 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_50 = tensor.insert_slice %181 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_51 = tensor.insert_slice %183 into %inserted_slice_50[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_52 = tensor.insert_slice %185 into %inserted_slice_51[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_53 = tensor.insert_slice %191 into %inserted_slice_52[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %192 = tensor.empty() : tensor<32x32xf32>
    %193 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice, %extracted_slice_1 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%192 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_54 = tensor.extract_slice %193[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_55 = tensor.extract_slice %193[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_56 = tensor.extract_slice %193[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_57 = tensor.extract_slice %193[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_58 = tensor.extract_slice %extracted_slice_6[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_59 = tensor.extract_slice %extracted_slice_6[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_60 = tensor.extract_slice %extracted_slice_6[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_61 = tensor.extract_slice %extracted_slice_6[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %194 = tensor.empty() : tensor<16x16xf32>
    %195 = linalg.fill ins(%cst : f32) outs(%194 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %196 = tensor.empty() : tensor<16x16xf32>
    %197 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_58, %extracted_slice_61 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%196 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %198 = tensor.empty() : tensor<16x16xf32>
    %199 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_54, %extracted_slice_57 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%198 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %200 = linalg.matmul ins(%199, %197 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %201 = tensor.empty() : tensor<16x16xf32>
    %202 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_55, %extracted_slice_57 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%201 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %203 = linalg.matmul ins(%202, %extracted_slice_58 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %204 = tensor.empty() : tensor<16x16xf32>
    %205 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_60, %extracted_slice_61 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%204 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %206 = linalg.matmul ins(%extracted_slice_54, %205 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %207 = tensor.empty() : tensor<16x16xf32>
    %208 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_59, %extracted_slice_58 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%207 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %209 = linalg.matmul ins(%extracted_slice_57, %208 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %210 = tensor.empty() : tensor<16x16xf32>
    %211 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_54, %extracted_slice_56 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%210 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %212 = linalg.matmul ins(%211, %extracted_slice_61 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %213 = tensor.empty() : tensor<16x16xf32>
    %214 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_58, %extracted_slice_60 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%213 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %215 = tensor.empty() : tensor<16x16xf32>
    %216 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_55, %extracted_slice_54 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%215 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %217 = linalg.matmul ins(%216, %214 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %218 = tensor.empty() : tensor<16x16xf32>
    %219 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_59, %extracted_slice_61 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%218 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %220 = tensor.empty() : tensor<16x16xf32>
    %221 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_56, %extracted_slice_57 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%220 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %222 = linalg.matmul ins(%221, %219 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%195 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %223 = tensor.empty() : tensor<16x16xf32>
    %224 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%200, %209 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%223 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %225 = tensor.empty() : tensor<16x16xf32>
    %226 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%224, %212 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%225 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %227 = tensor.empty() : tensor<16x16xf32>
    %228 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%226, %222 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%227 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %229 = tensor.empty() : tensor<16x16xf32>
    %230 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%206, %212 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%229 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %231 = tensor.empty() : tensor<16x16xf32>
    %232 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%203, %209 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%231 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %233 = tensor.empty() : tensor<16x16xf32>
    %234 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%200, %203 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%233 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %235 = tensor.empty() : tensor<16x16xf32>
    %236 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%234, %206 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%235 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %237 = tensor.empty() : tensor<16x16xf32>
    %238 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%236, %217 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%237 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_62 = tensor.insert_slice %228 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_63 = tensor.insert_slice %230 into %inserted_slice_62[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_64 = tensor.insert_slice %232 into %inserted_slice_63[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_65 = tensor.insert_slice %238 into %inserted_slice_64[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %239 = tensor.empty() : tensor<32x32xf32>
    %240 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_3, %extracted_slice_5 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%239 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %241 = tensor.empty() : tensor<32x32xf32>
    %242 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_0, %extracted_slice : tensor<32x32xf32>, tensor<32x32xf32>) outs(%241 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_66 = tensor.extract_slice %242[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_67 = tensor.extract_slice %242[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_68 = tensor.extract_slice %242[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_69 = tensor.extract_slice %242[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_70 = tensor.extract_slice %240[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_71 = tensor.extract_slice %240[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_72 = tensor.extract_slice %240[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_73 = tensor.extract_slice %240[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %243 = tensor.empty() : tensor<16x16xf32>
    %244 = linalg.fill ins(%cst : f32) outs(%243 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %245 = tensor.empty() : tensor<16x16xf32>
    %246 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_70, %extracted_slice_73 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%245 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %247 = tensor.empty() : tensor<16x16xf32>
    %248 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_66, %extracted_slice_69 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%247 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %249 = linalg.matmul ins(%248, %246 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %250 = tensor.empty() : tensor<16x16xf32>
    %251 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_67, %extracted_slice_69 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%250 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %252 = linalg.matmul ins(%251, %extracted_slice_70 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %253 = tensor.empty() : tensor<16x16xf32>
    %254 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_72, %extracted_slice_73 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%253 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %255 = linalg.matmul ins(%extracted_slice_66, %254 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %256 = tensor.empty() : tensor<16x16xf32>
    %257 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_71, %extracted_slice_70 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%256 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %258 = linalg.matmul ins(%extracted_slice_69, %257 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %259 = tensor.empty() : tensor<16x16xf32>
    %260 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_66, %extracted_slice_68 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%259 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %261 = linalg.matmul ins(%260, %extracted_slice_73 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %262 = tensor.empty() : tensor<16x16xf32>
    %263 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_70, %extracted_slice_72 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%262 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %264 = tensor.empty() : tensor<16x16xf32>
    %265 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_67, %extracted_slice_66 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%264 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %266 = linalg.matmul ins(%265, %263 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %267 = tensor.empty() : tensor<16x16xf32>
    %268 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_71, %extracted_slice_73 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%267 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %269 = tensor.empty() : tensor<16x16xf32>
    %270 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_68, %extracted_slice_69 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%269 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %271 = linalg.matmul ins(%270, %268 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%244 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %272 = tensor.empty() : tensor<16x16xf32>
    %273 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%249, %258 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%272 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %274 = tensor.empty() : tensor<16x16xf32>
    %275 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%273, %261 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%274 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %276 = tensor.empty() : tensor<16x16xf32>
    %277 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%275, %271 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%276 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %278 = tensor.empty() : tensor<16x16xf32>
    %279 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%255, %261 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%278 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %280 = tensor.empty() : tensor<16x16xf32>
    %281 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%252, %258 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%280 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %282 = tensor.empty() : tensor<16x16xf32>
    %283 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%249, %252 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%282 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %284 = tensor.empty() : tensor<16x16xf32>
    %285 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%283, %255 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%284 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %286 = tensor.empty() : tensor<16x16xf32>
    %287 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%285, %266 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%286 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_74 = tensor.insert_slice %277 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_75 = tensor.insert_slice %279 into %inserted_slice_74[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_76 = tensor.insert_slice %281 into %inserted_slice_75[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_77 = tensor.insert_slice %287 into %inserted_slice_76[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %288 = tensor.empty() : tensor<32x32xf32>
    %289 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_4, %extracted_slice_6 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%288 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %290 = tensor.empty() : tensor<32x32xf32>
    %291 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_1, %extracted_slice_2 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%290 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %extracted_slice_78 = tensor.extract_slice %291[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_79 = tensor.extract_slice %291[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_80 = tensor.extract_slice %291[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_81 = tensor.extract_slice %291[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_82 = tensor.extract_slice %289[0, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_83 = tensor.extract_slice %289[16, 0] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_84 = tensor.extract_slice %289[0, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %extracted_slice_85 = tensor.extract_slice %289[16, 16] [16, 16] [1, 1] : tensor<32x32xf32> to tensor<16x16xf32>
    %292 = tensor.empty() : tensor<16x16xf32>
    %293 = linalg.fill ins(%cst : f32) outs(%292 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %294 = tensor.empty() : tensor<16x16xf32>
    %295 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_82, %extracted_slice_85 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%294 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %296 = tensor.empty() : tensor<16x16xf32>
    %297 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_78, %extracted_slice_81 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%296 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %298 = linalg.matmul ins(%297, %295 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %299 = tensor.empty() : tensor<16x16xf32>
    %300 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_79, %extracted_slice_81 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%299 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %301 = linalg.matmul ins(%300, %extracted_slice_82 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %302 = tensor.empty() : tensor<16x16xf32>
    %303 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_84, %extracted_slice_85 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%302 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %304 = linalg.matmul ins(%extracted_slice_78, %303 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %305 = tensor.empty() : tensor<16x16xf32>
    %306 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_83, %extracted_slice_82 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%305 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %307 = linalg.matmul ins(%extracted_slice_81, %306 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %308 = tensor.empty() : tensor<16x16xf32>
    %309 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_78, %extracted_slice_80 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%308 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %310 = linalg.matmul ins(%309, %extracted_slice_85 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %311 = tensor.empty() : tensor<16x16xf32>
    %312 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_82, %extracted_slice_84 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%311 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %313 = tensor.empty() : tensor<16x16xf32>
    %314 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_79, %extracted_slice_78 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%313 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %315 = linalg.matmul ins(%314, %312 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %316 = tensor.empty() : tensor<16x16xf32>
    %317 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_83, %extracted_slice_85 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%316 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %318 = tensor.empty() : tensor<16x16xf32>
    %319 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%extracted_slice_80, %extracted_slice_81 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%318 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %320 = linalg.matmul ins(%319, %317 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%293 : tensor<16x16xf32>) -> tensor<16x16xf32>
    %321 = tensor.empty() : tensor<16x16xf32>
    %322 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%298, %307 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%321 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %323 = tensor.empty() : tensor<16x16xf32>
    %324 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%322, %310 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%323 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %325 = tensor.empty() : tensor<16x16xf32>
    %326 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%324, %320 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%325 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %327 = tensor.empty() : tensor<16x16xf32>
    %328 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%304, %310 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%327 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %329 = tensor.empty() : tensor<16x16xf32>
    %330 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%301, %307 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%329 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %331 = tensor.empty() : tensor<16x16xf32>
    %332 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%298, %301 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%331 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %333 = tensor.empty() : tensor<16x16xf32>
    %334 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%332, %304 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%333 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %335 = tensor.empty() : tensor<16x16xf32>
    %336 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%334, %315 : tensor<16x16xf32>, tensor<16x16xf32>) outs(%335 : tensor<16x16xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<16x16xf32>
    %inserted_slice_86 = tensor.insert_slice %326 into %1[0, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_87 = tensor.insert_slice %328 into %inserted_slice_86[0, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_88 = tensor.insert_slice %330 into %inserted_slice_87[16, 0] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %inserted_slice_89 = tensor.insert_slice %336 into %inserted_slice_88[16, 16] [16, 16] [1, 1] : tensor<16x16xf32> into tensor<32x32xf32>
    %337 = tensor.empty() : tensor<32x32xf32>
    %338 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%inserted_slice_17, %inserted_slice_53 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%337 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %339 = tensor.empty() : tensor<32x32xf32>
    %340 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%338, %inserted_slice_65 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%339 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %341 = tensor.empty() : tensor<32x32xf32>
    %342 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%340, %inserted_slice_89 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%341 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %343 = tensor.empty() : tensor<32x32xf32>
    %344 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%inserted_slice_41, %inserted_slice_65 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%343 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %345 = tensor.empty() : tensor<32x32xf32>
    %346 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%inserted_slice_29, %inserted_slice_53 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%345 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %347 = tensor.empty() : tensor<32x32xf32>
    %348 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%inserted_slice_17, %inserted_slice_29 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%347 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.subf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %349 = tensor.empty() : tensor<32x32xf32>
    %350 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%348, %inserted_slice_41 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%349 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %351 = tensor.empty() : tensor<32x32xf32>
    %352 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%350, %inserted_slice_77 : tensor<32x32xf32>, tensor<32x32xf32>) outs(%351 : tensor<32x32xf32>) {
    ^bb0(%in: f32, %in_94: f32, %out: f32):
      %353 = arith.addf %in, %in_94 : f32
      linalg.yield %353 : f32
    } -> tensor<32x32xf32>
    %inserted_slice_90 = tensor.insert_slice %342 into %arg2[0, 0] [32, 32] [1, 1] : tensor<32x32xf32> into tensor<64x64xf32>
    %inserted_slice_91 = tensor.insert_slice %344 into %inserted_slice_90[0, 32] [32, 32] [1, 1] : tensor<32x32xf32> into tensor<64x64xf32>
    %inserted_slice_92 = tensor.insert_slice %346 into %inserted_slice_91[32, 0] [32, 32] [1, 1] : tensor<32x32xf32> into tensor<64x64xf32>
    %inserted_slice_93 = tensor.insert_slice %352 into %inserted_slice_92[32, 32] [32, 32] [1, 1] : tensor<32x32xf32> into tensor<64x64xf32>
    return %inserted_slice_93 : tensor<64x64xf32>
  }
  func.func @main() -> i32 {
    %c1_i32 = arith.constant 1 : i32
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant 6.400000e+01 : f32
    %c0 = arith.constant 0 : index
    %c31 = arith.constant 31 : index
    %c63 = arith.constant 63 : index
    %0 = tensor.empty() : tensor<64x64xf32>
    %1 = linalg.fill ins(%cst : f32) outs(%0 : tensor<64x64xf32>) -> tensor<64x64xf32>
    %2 = tensor.empty() : tensor<64x64xf32>
    %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<64x64xf32>) -> tensor<64x64xf32>
    %4 = tensor.empty() : tensor<64x64xf32>
    %5 = linalg.fill ins(%cst_0 : f32) outs(%4 : tensor<64x64xf32>) -> tensor<64x64xf32>
    %6 = call @matmul_sstr(%1, %3, %5) : (tensor<64x64xf32>, tensor<64x64xf32>, tensor<64x64xf32>) -> tensor<64x64xf32>
    %extracted = tensor.extract %6[%c0, %c0] : tensor<64x64xf32>
    %extracted_2 = tensor.extract %6[%c0, %c31] : tensor<64x64xf32>
    %extracted_3 = tensor.extract %6[%c31, %c31] : tensor<64x64xf32>
    %extracted_4 = tensor.extract %6[%c63, %c0] : tensor<64x64xf32>
    %extracted_5 = tensor.extract %6[%c63, %c63] : tensor<64x64xf32>
    %7 = arith.cmpf oeq, %extracted, %cst_1 : f32
    %8 = arith.cmpf oeq, %extracted_2, %cst_1 : f32
    %9 = arith.cmpf oeq, %extracted_3, %cst_1 : f32
    %10 = arith.cmpf oeq, %extracted_4, %cst_1 : f32
    %11 = arith.cmpf oeq, %extracted_5, %cst_1 : f32
    %12 = arith.andi %7, %8 : i1
    %13 = arith.andi %9, %10 : i1
    %14 = arith.andi %12, %13 : i1
    %15 = arith.andi %14, %11 : i1
    %16 = arith.extui %15 : i1 to i32
    %17 = arith.subi %c1_i32, %16 : i32
    return %17 : i32
  }
}
