func.func @matmul_sstr(
    %A: tensor<64x64xf32>,
    %B: tensor<64x64xf32>,
    %init: tensor<64x64xf32>) -> tensor<64x64xf32> {
    %C = sstr.matmul %A, %B init %init
      {method = "strassen", cutoff = 16 : i64}
      : tensor<64x64xf32>, tensor<64x64xf32>, tensor<64x64xf32> -> tensor<64x64xf32>
  return %C : tensor<64x64xf32>
}