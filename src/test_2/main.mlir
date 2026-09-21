func.func @main() -> i32 {
  %c1   = arith.constant 1.0 : f32
  %c0   = arith.constant 0.0 : f32
  %c64  = arith.constant 64.0 : f32

  %r0   = arith.constant 0 : index
  %r31  = arith.constant 31 : index
  %r63  = arith.constant 63 : index

  %Ae = tensor.empty() : tensor<64x64xf32>
  %A  = linalg.fill ins(%c1 : f32) outs(%Ae : tensor<64x64xf32>) -> tensor<64x64xf32>
  %Be = tensor.empty() : tensor<64x64xf32>
  %B  = linalg.fill ins(%c1 : f32) outs(%Be : tensor<64x64xf32>) -> tensor<64x64xf32>

  %Ce   = tensor.empty() : tensor<64x64xf32>
  %init = linalg.fill ins(%c0 : f32) outs(%Ce : tensor<64x64xf32>) -> tensor<64x64xf32>
  %C    = func.call @matmul_sstr(%A, %B, %init) :
          (tensor<64x64xf32>, tensor<64x64xf32>, tensor<64x64xf32>) -> tensor<64x64xf32>

  %d1 = tensor.extract %C[%r0, %r0] : tensor<64x64xf32>
  %d2 = tensor.extract %C[%r0, %r31] : tensor<64x64xf32>
  %d3 = tensor.extract %C[%r31, %r31] : tensor<64x64xf32>
  %d4 = tensor.extract %C[%r63, %r0] : tensor<64x64xf32>
  %d5 = tensor.extract %C[%r63, %r63] : tensor<64x64xf32>

  %ok1 = arith.cmpf oeq, %d1, %c64 : f32
  %ok2 = arith.cmpf oeq, %d2, %c64 : f32
  %ok3 = arith.cmpf oeq, %d3, %c64 : f32
  %ok4 = arith.cmpf oeq, %d4, %c64 : f32
  %ok5 = arith.cmpf oeq, %d5, %c64 : f32
  %ok_a = arith.andi %ok1, %ok2 : i1
  %ok_b = arith.andi %ok3, %ok4 : i1
  %ok_c = arith.andi %ok_a, %ok_b : i1
  %ok   = arith.andi %ok_c, %ok5 : i1

  %uno_i = arith.constant 1 : i32
  %ok_i  = arith.extui %ok : i1 to i32
  %fallo = arith.subi %uno_i, %ok_i : i32

  return %fallo : i32
}