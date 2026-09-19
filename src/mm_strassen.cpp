#include <stdlib.h>
#include "matmul.h"

static void qcpy(int m, const float *src, int stride, float *dst) {
  for (int i = 0; i < m; i++)
    for (int j = 0; j < m; j++)
      dst[i * m + j] = src[i * stride + j];
}

static void add_sub(int m, const float *X, const float *Y, float *Z, int sign) {
  const int cnt = m * m;
  for (int i = 0; i < cnt; i++)
    Z[i] = (sign > 0) ? (X[i] + Y[i]) : (X[i] - Y[i]);
}

static float *ws_base = NULL;
static float *ws_cursor = NULL;

static void mm_strassen_rec(int n, const float *A, const float *B, float *C) {
  if (n <= 16) {
    matmul_f32(n, n, n, A, B, C);
    return;
  }

  const int m = n / 2;
  float *node = ws_cursor;
  ws_cursor += 17 * m * m;

  float *qa = node;
  float *qb = node + 1 * m * m;
  float *qc = node + 2 * m * m;
  float *qd = node + 3 * m * m;
  float *qe = node + 4 * m * m;
  float *qf = node + 5 * m * m;
  float *qg = node + 6 * m * m;
  float *qh = node + 7 * m * m;
  float *t0 = node + 8 * m * m;
  float *t1 = node + 9 * m * m;
  float *p1 = node + 10 * m * m;
  float *p2 = node + 11 * m * m;
  float *p3 = node + 12 * m * m;
  float *p4 = node + 13 * m * m;
  float *p5 = node + 14 * m * m;
  float *p6 = node + 15 * m * m;
  float *p7 = node + 16 * m * m;

  qcpy(m, A, n, qa);
  qcpy(m, A + m, n, qb);
  qcpy(m, A + m * n, n, qc);
  qcpy(m, A + m * n + m, n, qd);
  qcpy(m, B, n, qe);
  qcpy(m, B + m, n, qf);
  qcpy(m, B + m * n, n, qg);
  qcpy(m, B + m * n + m, n, qh);

  add_sub(m, qa, qd, t0, +1);
  add_sub(m, qe, qh, t1, +1);
  mm_strassen_rec(m, t0, t1, p1);

  add_sub(m, qc, qd, t0, +1);
  mm_strassen_rec(m, t0, qe, p2);

  add_sub(m, qf, qh, t0, -1);
  mm_strassen_rec(m, qa, t0, p3);

  add_sub(m, qg, qe, t0, -1);
  mm_strassen_rec(m, qd, t0, p4);

  add_sub(m, qa, qb, t0, +1);
  mm_strassen_rec(m, t0, qh, p5);

  add_sub(m, qc, qa, t0, -1);
  add_sub(m, qe, qf, t1, +1);
  mm_strassen_rec(m, t0, t1, p6);

  add_sub(m, qb, qd, t0, -1);
  add_sub(m, qg, qh, t1, +1);
  mm_strassen_rec(m, t0, t1, p7);

  for (int i = 0; i < m; i++)
    for (int j = 0; j < m; j++) {
      C[i * n + j] = p1[i * m + j] + p4[i * m + j] - p5[i * m + j] + p7[i * m + j];
      C[i * n + j + m] = p3[i * m + j] + p5[i * m + j];
      C[(m + i) * n + j] = p2[i * m + j] + p4[i * m + j];
      C[(m + i) * n + j + m] = p1[i * m + j] - p2[i * m + j] + p3[i * m + j] + p6[i * m + j];
    }
}

void mm_strassen(int n, const float *A, const float *B, float *C) {
  if (ws_base == NULL) {
    ws_base = (float *) malloc(sizeof(float) * (1u << 20));
    ws_cursor = ws_base;
  }
  ws_cursor = ws_base;
  mm_strassen_rec(n, A, B, C);
}