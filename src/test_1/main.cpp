#include <stdio.h>

#include "../matmul.h"

int main(void) {
  float A[3 * 4], B[4 * 5], C[3 * 5];

  for (int i = 0; i < 3; i++)
    for (int k = 0; k < 4; k++)
      A[i * 4 + k] = 1.0f;
  for (int k = 0; k < 4; k++)
    for (int j = 0; j < 5; j++)
      B[k * 5 + j] = 1.0f;

  matmul_f32(3, 5, 4, A, B, C);

  int ok = 1;
  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 5; j++)
      if (C[i * 5 + j] != 4.0f) ok = 0;

  printf("test_1 gcc (camino clasico) -> %s\n",
         ok ? "0 (correcto)" : "1 (fallo)");
  return ok ? 0 : 1;
}