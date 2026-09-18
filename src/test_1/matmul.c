// =============================================================
// matmul.c — PROGRAMA ORIGEN (lenguaje C)
// Este es el "fragmento de codigo" que lectquiza la pelicula:
// src/01_matmul_linalg.mlir es la realizacion de ESTE programa en
// los dialectos de MLIR (ver mapeo abajo).
//
// Matriz 3x4 x 4x5 = 3x5, todos de 1.0 -> resultado 4.0 en cada celda.
//
// MAPEO 1:1 con src/01_matmul_linalg.mlir
//   C[i][j] += A[i][k]*B[k][j]        -> linalg.generic (cuerpo: a*b + c)
//   bucle i (0..2)                    -> iterator_types "parallel" (d0)
//   bucle j (0..4)                    -> iterator_types "parallel" (d1)
//   bucle k (0..3), se SUMA          -> iterator_types "reduction" (d2)
//   i, k  indexan A                  -> affine_map (d0,d1,d2) -> (d0,d2)
//   k, j  indexan B                  -> affine_map (d0,d1,d2) -> (d2,d1)
//   i, j  escriben C                 -> affine_map (d0,d1,d2) -> (d0,d1)
//   bucle i,j que inicializa C = 0   -> linalg.fill
//   main (driver)                    -> func.func @main en 01
// =============================================================

#include <stdio.h>

void matmul_f32(
    const float A[3][4], const float B[4][5], float C[3][5]) {
  // Inicializa C = 0  (equivale a linalg.fill en 01).
  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 5; j++)
      C[i][j] = 0.0f;

  // Producto punto (equivale a linalg.generic en 01).
  for (int i = 0; i < 3; i++)                // parallel (d0)
    for (int j = 0; j < 5; j++) {            // parallel (d1)
      for (int k = 0; k < 4; k++)            // reduction (d2)
        C[i][j] += A[i][k] * B[k][j];        //   cuerpo: a*b + c
    }
}

int main(void) {
  float A[3][4], B[4][5], C[3][5];
  for (int i = 0; i < 3; i++)
    for (int k = 0; k < 4; k++)
      A[i][k] = 1.0f;
  for (int k = 0; k < 4; k++)
    for (int j = 0; j < 5; j++)
      B[k][j] = 1.0f;

  matmul_f32(A, B, C);

  int ok = 1;
  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 5; j++)
      if (C[i][j] != 4.0f) ok = 0;

  printf("gcc (camino clasico) -> %s\n", ok ? "0 (correcto)" : "1 (fallo)");
  return ok ? 0 : 1;
}