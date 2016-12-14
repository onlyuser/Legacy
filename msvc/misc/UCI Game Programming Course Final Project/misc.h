#ifndef H_MISC
#define H_MISC

#include <windows.h> /* BYTE :: various */
#include <stdio.h> /* fopen() :: various */
#include <math.h> /* pow() + sin() :: various */

#define BIG_NUMBER (32767)
#define PI ((float) 3.14159)
#define toDeg(angle) (angle * 180 / PI)
#define toRad(angle) (angle * PI / 180)
#define sgn(value) ((value == 0) ? 0 : ((value > 0) ? 1 : -1))
#define acosEx(value) ((fabs(value) > 0.999) ? ((value > 0) ? 0 : PI) : (float) acos(value))
#define normSide(vector, origin, normal) (vectorDot(vector, normal) > vectorDot(origin, normal))

enum eMov
{
	MOV_POS,
	MOV_ROT,
	MOV_SCALE,
	MOV_VEL,
	MOV_ANGVEL,
	MOV_ACC,
	MOV_ANGACC
};

enum eDir
{
	DIR_BACK,
	DIR_FRONT,
	DIR_LEFT,
	DIR_RIGHT,
	DIR_TOP,
	DIR_BOTTOM,
	DIR_RADIAL
};

struct face
{
	long a;
	long b;
	long c;
};

struct partSys
{
	float mFreq;
	float mBucket;
	long mColor;
	float mSize;
	float mSpeed;
	float mSpread;
	long mTicks;
};

#include "list.h"
#include "sort.h"
#include "vector.h"
#include "matrix.h"
#include "object.h"
#include "image.h"
#include "material.h"
#include "treeNode.h"

typedef void (APIENTRY *PFNGLLOCKARRAYSEXTPROC) (int first, int count);
typedef void (APIENTRY *PFNGLUNLOCKARRAYSEXTPROC) (void);

void init_EXT_CVA();
long findText(char *text, char *token);
void vectorFromAngle(float *result, float *angle);
void angleFromVector(float *result, float *vector);
void makeBox(float **box);
void getFaceNorm(float *result, float *vectA, float *vectB, float *vectC);
float vectorPlaneDist(float *vector, float *vectA, float *vectB, float *vectC);
long rgb(BYTE r, BYTE g, BYTE b);
long colorElem(long color, char name);
char *strCpy(char *text);
char *strCat(char *textA, char *textB);
char *strLoad(char *filename);
char *strScan(char *text, long &start, char *stopTerm);
char *strTrim(char *text);
char *strLeft(char *text, long length);
char *strRight(char *text, long length);
char *strMid(char *text, long start, long length);
char *strSpace(long length);

#endif