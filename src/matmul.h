#ifndef MATMUL_H
#define MATMUL_H

void matmul_f32(int M, int N, int K, const float *A, const float *B, float *C);

void mm_strassen(int n, const float *A, const float *B, float *C);

#endif