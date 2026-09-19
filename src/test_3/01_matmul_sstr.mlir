// =============================================================
// 01_matmul_sstr.mlir  (test_4 — dialecto sstr + Strassen)
// MATMUL: C[64x64] = A[64x64] x B[64x64]
//
// Este archivo es el mismo algoritmo que src/test_4/matmul.c pero escrito
// en el nivel de abstraccion sstr: en vez de escribir los bucles, se declara
// un solo sstr.matmul y el pass sstr-expand decide la implementacion.
//
// A y B de unos -> C = 64.0 en toda celda (64 sumas de 1*1).
// =============================================================

// ============  KERNEL: operacion del dialecto sstr  ============

func.func @matmul_sstr(
    %A: tensor<64x64xf32>,
    %B: tensor<64x64xf32>,
    %init: tensor<64x64xf32>) -> tensor<64x64xf32> {
  // 1 op del dialecto propio; el pass sstr-expand la baja a linalg.
  %C = sstr.matmul %A, %B init %init
       {method = "strassen", cutoff = 16 : i64}
       : tensor<64x64xf32>, tensor<64x64xf32>, tensor<64x64xf32> -> tensor<64x64xf32>
  return %C : tensor<64x64xf32>
}

// =============  DRIVER (invocacion): 64x64 unos -> 64.0  =============
// @main devuelve 0 si correcto, 1 si no.

func.func @main() -> i32 {
  %c1   = arith.constant 1.0 : f32
  %c0   = arith.constant 0.0 : f32
  %c64  = arith.constant 64.0 : f32
  %c16  = arith.constant 16.0 : f32

  %r0   = arith.constant 0 : index
  %r31  = arith.constant 31 : index
  %r63  = arith.constant 63 : index

  // A y B de unos.
  %Ae = tensor.empty() : tensor<64x64xf32>
  %A  = linalg.fill ins(%c1 : f32) outs(%Ae : tensor<64x64xf32>) -> tensor<64x64xf32>
  %Be = tensor.empty() : tensor<64x64xf32>
  %B  = linalg.fill ins(%c1 : f32) outs(%Be : tensor<64x64xf32>) -> tensor<64x64xf32>

  // init (ceros) + llamada al kernel sstr.
  %Ce   = tensor.empty() : tensor<64x64xf32>
  %init = linalg.fill ins(%c0 : f32) outs(%Ce : tensor<64x64xf32>) -> tensor<64x64xf32>
  %C    = func.call @matmul_sstr(%A, %B, %init) :
          (tensor<64x64xf32>, tensor<64x64xf32>, tensor<64x64xf32>) -> tensor<64x64xf32>

  // Verificamos esquinas y un punto del medio; todos deben dar 64.0.
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
  %fallo = arith.subi %uno_i, %ok_i : i32   // 1 si fallo, 0 si ok

  return %fallo : i32
}