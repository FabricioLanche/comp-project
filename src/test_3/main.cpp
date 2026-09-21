#include <stdio.h>

#include "../matmul.h"

#ifndef SIZE
#define SIZE 256
#endif

int main(void) {
  float A[SIZE * SIZE], B[SIZE * SIZE], C[SIZE * SIZE];

  for (int i = 0; i < SIZE; i++)
    for (int k = 0; k < SIZE; k++)
      A[i * SIZE + k] = 1.0f;
  for (int k = 0; k < SIZE; k++)
    for (int j = 0; j < SIZE; j++)
      B[k * SIZE + j] = 1.0f;

  matmul_f32(SIZE, SIZE, SIZE, A, B, C);

  int ok = 1;
  for (int i = 0; i < SIZE; i++)
    for (int j = 0; j < SIZE; j++)
      if (C[i * SIZE + j] != (float)SIZE) ok = 0;

  printf("test_2 gcc (camino clasico, SIZE=%d) -> %s\n", SIZE,
         ok ? "0 (correcto)" : "1 (fallo)");
  return ok ? 0 : 1;
}