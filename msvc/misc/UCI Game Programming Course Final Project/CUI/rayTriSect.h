#ifndef H_RAYTRISECT
#define H_RAYTRISECT

#include "../misc.h"

float segTriSect(float *origin, float *dir, float dist, float *vectA, float *vectB, float *vectC);
bool rayTriSect(float &r, float &s, float &t, float *origin, float *dir, float *vectA, float *vectB, float *vectC);

#endif