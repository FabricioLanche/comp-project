#include <stdio.h>
#include <stdlib.h>

#include "../matmul.h"

#define N 64

int main(void) {
  const size_t n2 = N * N;
  float *A = (float *) malloc(sizeof(float) * n2);
  float *B = (float *) malloc(sizeof(float) * n2);
  float *C = (float *) malloc(sizeof(float) * n2);
  float *R = (float *) malloc(sizeof(float) * n2);

  for (size_t i = 0; i < n2; i++) {
    A[i] = 1.0f;
    B[i] = 1.0f;
  }

  mm_strassen(N, A, B, C);
  matmul_f32(N, N, N, A, B, R);

  int ok = 1;
  for (size_t i = 0; i < n2; i++)
    if (C[i] != R[i]) {
      ok = 0;
      break;
    }

  printf("test_3 gcc (clasico ref vs strassen) -> %s\n", ok ? "0 (correcto)" : "1 (fallo)");
  free(A);
  free(B);
  free(C);
  free(R);
  return ok ? 0 : 1;
}