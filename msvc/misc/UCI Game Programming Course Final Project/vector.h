#ifndef H_VECTOR
#define H_VECTOR

#include "misc.h"

#define vectorAlloc() (new float[3])
#define vectorFree(v) (delete []v)
#define vectorMod(v) ((float) pow(v[0] * v[0] + v[1] * v[1] + v[2] * v[2], 0.5))
#define vectorDot(a, b) (a[0] * b[0] + a[1] * b[1] + a[2] * b[2])
#define vectorDist(a, b) ((float) pow((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]), 0.5))
#define vectorDirty(v) (v[0] != 0 || v[1] != 0 || v[2] != 0)
#define isBounded(value, min, max) (value >= min && value <= max)
#define vectorBounded(v, min, max) (isBounded(v[0], min[0], max[0]) && isBounded(v[1], min[1], max[1]) && isBounded(v[2], min[2], max[2]))
#define vectorMax(v, a, b) (v[0] = max(a[0], b[0]), v[1] = max(a[1], b[1]), v[2] = max(a[2], b[2]))

void vectorCopy(float *result, float *vector);
void vectorAdd(float *result, float *vectA, float *vectB);
void vectorSub(float *result, float *vectA, float *vectB);
void vectorScale(float *result, float *vectA, float scale);
void vectorMult(float *result, float *vectA, float *vectB);
void vectorLock(float *result, float *vector, float min, float max);
void vectorWrap(float *result, float *vector, float min, float max);
void vectorInterp(float *result, float *vectA, float *vectB, float alpha);
void vectorNorm(float *result, float *vectA);
void vectorCross(float *result, float *vectA, float *vectB);
void vectorMatrixMult(float *result, float *vector, float **matrix);
void vectorMatrixMultEx(float *result, float *vector, float **matrix);
float vectorAngle(float *vectA, float *vectB);
void vectorAlong(float *result, float *vectA, float *vectB);
void vectorOrthog(float *result, float *vectA, float *vectB);
void vectorReflect(float *result, float *vectA, float *vectB);
void vectorNull(float *result);
void vectorUnit(float *result);
void vectorRand(float *result);
void vectorRandEx(float *result, float radius);

#endif