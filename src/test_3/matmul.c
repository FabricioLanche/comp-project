// =============================================================
// matmul.c  (test_2 — matrices MAS GRANDES)
// Programa origen: 8x16 x 16x32 = 8x32, de unos -> C = 16.0.
// src/origen de test_1/01_matmul_linalg.mlir es su version en MLIR.
// MAPEO 1:1 con la version MLIR (identico al test_1):
//   bucles i,j (parallel), bucle k (reduction),
//   indices -> affine_maps, init -> linalg.fill, main -> @main.
// =============================================================

#include <stdio.h>

void matmul_f32(
    const float A[8][16], const float B[16][32], float C[8][32]) {
  for (int i = 0; i < 8; i++)
    for (int j = 0; j < 32; j++)
      C[i][j] = 0.0f;

  for (int i = 0; i < 8; i++)                 // parallel (d0)
    for (int j = 0; j < 32; j++) {            // parallel (d1)
      for (int k = 0; k < 16; k++)            // reduction (d2)
        C[i][j] += A[i][k] * B[k][j];         //   cuerpo: a*b + c
    }
}

int main(void) {
  float A[8][16], B[16][32], C[8][32];
  for (int i = 0; i < 8; i++)
    for (int k = 0; k < 16; k++)
      A[i][k] = 1.0f;
  for (int k = 0; k < 16; k++)
    for (int j = 0; j < 32; j++)
      B[k][j] = 1.0f;

  matmul_f32(A, B, C);

  int ok = 1;
  for (int i = 0; i < 8; i++)
    for (int j = 0; j < 32; j++)
      if (C[i][j] != 16.0f) ok = 0;

  printf("test_2 gcc (camino clasico) -> %s\n",
         ok ? "0 (correcto)" : "1 (fallo)");
  return ok ? 0 : 1;
}