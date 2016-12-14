#ifndef H_VECTOR
#define H_VECTOR

#include "misc.h"

/* NEW OPTIMIZED CODE */
#define vectorModulus(v, x) ((float) pow(v[0] * v[0] + v[1] * v[1] + v[2] * v[2], 0.5))
#define vectorDotProduct(a, b, x) (a[0] * b[0] + a[1] * b[1] + a[2] * b[2])
#define vectorDistance(a, b, x) ((float) pow((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]), 0.5))

float *vectorUpdate(float *, float *);
float *vectorAdd(float *, float *, long);
float *vectorSubtract(float *, float *, long);
float *vectorScale(float *, long, float);
float *vectorInterp(float *, float *, long, float);
//float vectorDotProduct(float *, float *, long);
//float vectorModulus(float *, long);
//float vectorDistance(float *, float *, long);
float *vectorNormalize(float *, long);
float *vectorCrossProduct(float *, float *);
float *vectorMatrixMult(float *, float **, long);
float vectorAngle(float *, float *, long);
float *vectorCompAlong(float *, float *, long);
float *vectorCompOrthog(float *, float *, long);
float *vectorReflect(float *, float *, long);
float *vectorNull(long);
float *vectorUnit(long);
float *vectorRandom(long);

#endif
