#include "vector.h"

void vectorCopy(float *result, float *vector)
{
	result[0] = vector[0];
	result[1] = vector[1];
	result[2] = vector[2];
}

void vectorAdd(float *result, float *vectA, float *vectB)
{
	result[0] = vectA[0] + vectB[0];
	result[1] = vectA[1] + vectB[1];
	result[2] = vectA[2] + vectB[2];
}

void vectorSub(float *result, float *vectA, float *vectB)
{
	result[0] = vectA[0] - vectB[0];
	result[1] = vectA[1] - vectB[1];
	result[2] = vectA[2] - vectB[2];
}

void vectorScale(float *result, float *vectA, float scale)
{
	result[0] = vectA[0] * scale;
	result[1] = vectA[1] * scale;
	result[2] = vectA[2] * scale;
}

void vectorMult(float *result, float *vectA, float *vectB)
{
	result[0] = vectA[0] * vectB[0];
	result[1] = vectA[1] * vectB[1];
	result[2] = vectA[2] * vectB[2];
}

void vectorLock(float *result, float *vector, float min, float max)
{
	vectorCopy(result, vector);
	if (result[0] < min) result[0] = min;
	if (result[1] < min) result[1] = min;
	if (result[2] < min) result[2] = min;
	if (result[0] > max) result[0] = max;
	if (result[1] > max) result[1] = max;
	if (result[2] > max) result[2] = max;
}

void vectorWrap(float *result, float *vector, float min, float max)
{
	float range;

	range = max - min;
	vectorCopy(result, vector);
	if (result[0] < min) result[0] += range;
	if (result[1] < min) result[1] += range;
	if (result[2] < min) result[2] += range;
	if (result[0] > max) result[0] -= range;
	if (result[1] > max) result[1] -= range;
	if (result[2] > max) result[2] -= range;
}

void vectorInterp(float *result, float *vectA, float *vectB, float alpha)
{
	result[0] = vectA[0] + (vectB[0] - vectA[0]) * alpha;
	result[1] = vectA[1] + (vectB[1] - vectA[1]) * alpha;
	result[2] = vectA[2] + (vectB[2] - vectA[2]) * alpha;
}

void vectorNorm(float *result, float *vector)
{
	float length;
	float scale;

	length = vectorMod(vector);
	if (length != 0)
		scale = 1 / length;
	else
		scale = 1;
	vectorScale(result, vector, scale);
}

/* gets normal of surface formed by vectA and vectB */
void vectorCross(float *result, float *vectA, float *vectB)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = vectA[1] * vectB[2] - vectA[2] * vectB[1];
	tempA[1] = vectA[2] * vectB[0] - vectA[0] * vectB[2];
	tempA[2] = vectA[0] * vectB[1] - vectA[1] * vectB[0];
	vectorCopy(result, tempA);
	delete []tempA;
}

void vectorMatrixMult(float *result, float *vector, float **matrix)
{
	long i;
	float *tempA;

	tempA = new float[4];
	for (i = 0; i < 4; i++)
		tempA[i] =
			vector[0] * matrix[0][i] +
			vector[1] * matrix[1][i] +
			vector[2] * matrix[2][i] + matrix[3][i];
	vectorCopy(result, tempA);
	delete []tempA;
}

void vectorMatrixMultEx(float *result, float *vector, float **matrix)
{
	long i;
	float *tempA;

	tempA = new float[4];
	for (i = 0; i < 4; i++)
		tempA[i] =
			vector[0] * matrix[0][i] +
			vector[1] * matrix[1][i] +
			vector[2] * matrix[2][i] + matrix[3][i];
	vectorCopy(result, tempA);
	result[3] = tempA[3];
	delete []tempA;
}

/* gets cosine of angle between vectA and vectB */
/* (NOTE: zero is orthogonal, one is parallel) */
/* (NOTE: the radian angle is the arccos) */
float vectorAngle(float *vectA, float *vectB)
{
	float result;
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	vectorNorm(tempA, vectA);
	vectorNorm(tempB, vectB);
	result = vectorDot(tempA, tempB);
	delete []tempA;
	delete []tempB;
	return result;
}

/* gets component of vectA along direction of vectB */
void vectorAlong(float *result, float *vectA, float *vectB)
{
	float scale;

	scale = vectorDot(vectA, vectB) / vectorDot(vectB, vectB);
	vectorScale(result, vectB, scale);
}

/* gets other component of vectA */
void vectorOrthog(float *result, float *vectA, float *vectB)
{
	float *tempA;

	tempA = new float[3];
	vectorAlong(tempA, vectA, vectB);
	vectorSub(result, vectA, tempA);
	delete []tempA;
}

/* gets reflection of vectA off surface with normal vectB */
void vectorReflect(float *result, float *vectA, float *vectB)
{
	float *tempA;

	tempA = new float[3];
	vectorAlong(tempA, vectA, vectB);
	vectorScale(tempA, tempA, -2);
	vectorAdd(result, vectA, tempA);
	delete []tempA;
}

void vectorNull(float *result)
{
	result[0] = 0;
	result[1] = 0;
	result[2] = 0;
}

void vectorUnit(float *result)
{
	result[0] = 1;
	result[1] = 1;
	result[2] = 1;
}

void vectorRand(float *result)
{
	result[0] = randEx(0, 1);
	result[1] = randEx(0, 1);
	result[2] = randEx(0, 1);
}

void vectorRandEx(float *result, float radius)
{
	result[0] = randEx(-radius, radius);
	result[1] = randEx(-radius, radius);
	result[2] = randEx(-radius, radius);
}