// =============================================================
// 01_matmul_linalg.mlir
// MATMUL: C[3x5] = A[3x4] x B[4x5]
//   C(i,j) = sum_k A(i,k) * B(k,j)
//
// Este archivo es la REALIZACION en dialectos MLIR del programa
// fuente src/matmul.c (ver el mapeo 1:1 en los comentarios de ese
// archivo). Lo que aqui se escribe a nivel de tensores (sin bucles)
// es justamente lo que el compilador re-genera al bajar de nivel.
//
// Este archivo esta escrito en el dialecto "linalg": describe la
// computacion a nivel de tensores, SIN escribir los bucles a mano.
// MLIR lo entiende de forma declarativa (que se computa), y luego
// toda la maquinaria lo baja a bucles (affine) y a codigo de maquina.
// =============================================================

// Funcion con 3 buffers (memrefs) como argumentos.
func.func @matmul_f32(%A: memref<3x4xf32>, %B: memref<4x5xf32>, %C: memref<3x5xf32>) {

  // Constantes que se usan abajo.
  %cst = arith.constant 0.0 : f32      // cero
  %cst_1 = arith.constant 1.0 : f32    // uno (no usado; de ejemplo)

  // 1) linalg.fill: inicializa C con 0.
  //    Es un op "named": no hay que pedirle bucles, el compilador los genera.
  linalg.fill ins(%cst : f32) outs(%C : memref<3x5xf32>)

  // 2) linalg.generic: la operacion "generica" de linalg.
  //    Compone la suma producto:
  //      - ins  = entradas A y B
  //      - outs = C (acumulador)
  //      - indexing_maps = como se indexa cada operando (ver cabecera)
  //      - iterator_types = "parallel" (i,j) y "reduction" (k)
  //      - ^bb0: el "cuerpo" de la operacion sobre 1 elemento c/u,
  //        recibe (a, b, c) y devuelve a*b + c  (acumulacion).
  linalg.generic {
    indexing_maps = [
      affine_map<(d0, d1, d2) -> (d0, d2)>,   // A(i,k)
      affine_map<(d0, d1, d2) -> (d2, d1)>,   // B(k,j)
      affine_map<(d0, d1, d2) -> (d0, d1)>    // C(i,j)
    ],
    iterator_types = ["parallel", "parallel", "reduction"]
  } ins(%A, %B : memref<3x4xf32>, memref<4x5xf32>)
    outs(%C : memref<3x5xf32>) {
  ^bb0(%a: f32, %b: f32, %c: f32):
    %prod = arith.mulf %a, %b : f32          // a*b
    %0 = arith.addf %c, %prod : f32          // c + a*b  (acumular)
    linalg.yield %0 : f32
  }

  return
}

// =============================================================
// DRIVER (invocación): punto de entrada para ejecutar el kernel.
// A y B se llenan con 1.0, corre @matmul_f32 y verifica que C sea 4.0.
// @main devuelve 0 si el resultado es correcto, 1 si no.
//
// Uso (parte del pipeline de run.sh):
//   mlir-cpu-runner-18 out/10_run_llvm.mlir -e main -entry-point-result=i32
//   Salida: 0 = matmul correcto
//
// Nota: los archivos .mlir no tienen #include; este driver comparte
// el mismo "modulo" (archivo) con el kernel, imitando un link.
// =============================================================

// El resultado esperado: 3x4 unos x 4x5 unos = 4.0 en toda C.
func.func @main() -> i32 {
  %uno = arith.constant 1.0 : f32
  %cero = arith.constant 0.0 : f32

  %A = memref.alloc() : memref<3x4xf32>
  %B = memref.alloc() : memref<4x5xf32>
  %C = memref.alloc() : memref<3x5xf32>

  linalg.fill ins(%uno : f32) outs(%A : memref<3x4xf32>)
  linalg.fill ins(%uno : f32) outs(%B : memref<4x5xf32>)

  func.call @matmul_f32(%A, %B, %C) : (memref<3x4xf32>, memref<4x5xf32>, memref<3x5xf32>) -> ()

  // Verificamos esquinas y centro: todas deben ser 4.0.
  %r0 = arith.constant 0 : index
  %r1 = arith.constant 1 : index
  %r2 = arith.constant 2 : index
  %r4 = arith.constant 4 : index
  %c4 = arith.constant 4.0 : f32

  %d_a = memref.load %C[%r0, %r0] : memref<3x5xf32>
  %d_b = memref.load %C[%r0, %r4] : memref<3x5xf32>
  %d_c = memref.load %C[%r2, %r2] : memref<3x5xf32>

  %ok1 = arith.cmpf oeq, %d_a, %c4 : f32
  %ok2 = arith.cmpf oeq, %d_b, %c4 : f32
  %ok3 = arith.cmpf oeq, %d_c, %c4 : f32
  %ok_a = arith.andi %ok1, %ok2 : i1
  %ok = arith.andi %ok_a, %ok3 : i1

  %uno_i = arith.constant 1 : i32
  %ok_i = arith.extui %ok : i1 to i32
  %fallo = arith.subi %uno_i, %ok_i : i32   // 1 si fallo, 0 si ok

  // Limpieza opcional de memoria (no estricta para la demo).
  memref.dealloc %C : memref<3x5xf32>
  memref.dealloc %B : memref<4x5xf32>
  memref.dealloc %A : memref<3x4xf32>

  return %fallo : i32
}