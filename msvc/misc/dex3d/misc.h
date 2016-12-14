#ifndef H_MISC
#define H_MISC

#define randEx(lower, upper) ((float) rand() / RAND_MAX * (upper - lower) + lower)
#define PI ((float) 3.14159)
#define toDegree(angle) (angle * 180 / PI)
#define toRadian(angle) (angle * PI / 180)

#include <windows.h>
#include <stdio.h> // sprintf :: various
#include <math.h> // pow + sin :: various
#include <stdlib.h> // rand :: randEx
#include "shared.h" // VB_CALL + VB_FUNC :: various
#include "list.h"
#include "sort.h"
#include "vector.h"
#include "matrix.h"
#include "object.h"

struct face
{
	long a;
	long b;
	long c;
	long mColor;
	float mAlpha;
	long mShade;
	long mBase;
};

float *vectorFromAngles(float *);
float *faceCenter(float *, float *, float *);
float *faceNormal(float *, float *, float *);
long rgb(long, long, long);
long colorElem(long, char);
long colorIntensity(long);
float *vectorFromColor(long);
long colorAdd(long, long);
long colorScale(long, float);
long colorInterp(long, long, float);
long colorSect(long, long);
long colorNull();
long colorRandom();

#endif
