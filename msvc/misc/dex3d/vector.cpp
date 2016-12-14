#include "vector.h"

float *vectorUpdate(float *vectA, float *vectB)
{
	delete []vectA;
	return vectB;
}

float *vectorAdd(float *vectA, float *vectB, long length)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = vectA[i] + vectB[i];
	return result;
}

float *vectorSubtract(float *vectA, float *vectB, long length)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = vectA[i] - vectB[i];
	return result;
}

float *vectorScale(float *vector, long length, float scale)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = vector[i] * scale;
	return result;
}

float *vectorInterp(float *vectA, float *vectB, long length, float alpha)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = vectA[i] + (vectB[i] - vectA[i]) * alpha;
	return result;
}

/*
float vectorDotProduct(float *vectA, float *vectB, long length)
{
	int i;
	float result;

	result = 0;
	for (i = 0; i < length; i++)
		result += vectA[i] * vectB[i];
	return result;
}
*/

/* returns length of vector */
/*
float vectorModulus(float *vector, long length)
{
	float result;

	result = vectorDotProduct(vector, vector, length);
	result = (float) pow(result, 0.5);
	return result;
}
*/

/*
float vectorDistance(float *vectA, float *vectB, long length)
{
	float result;
	float *vectC;

	vectC = vectorSubtract(vectA, vectB, length);
	result = vectorModulus(vectC, length);
	delete []vectC;
	return result;
}
*/

float *vectorNormalize(float *vector, long length)
{
	float *result;
	float tempA;
	float tempB;

	tempA = vectorModulus(vector, length);
	if (tempA != 0)
	{
		tempB = 1 / tempA;
		result = vectorScale(vector, length, tempB);
	}
	else
		result = vectorNull(length);
	return result;
}

/* returns normal of surface formed by vectA and vectB */
float *vectorCrossProduct(float *vectA, float *vectB)
{
	/*
	int i;
	float *result;
	float **matrixA;

	matrixA = matrixAlloc(3, 3);
	for (i = 0; i < 3; i++)
	{
		matrixA[1][i] = vectA[i];
		matrixA[2][i] = vectB[i];
	}
	for (i = 0; i < 3; i++)
		matrixA[0][i] = matrixCofact(matrixA, 3, 3, 0, i);
	result = matrixRow(matrixA, 3, 0);
	matrixFree(matrixA, 3);
	*/

	/* NEW OPTIMIZED CODE */
	float *result;

	result = new float[3];
	result[0] = vectA[1] * vectB[2] - vectA[2] * vectB[1];
	result[1] = vectA[2] * vectB[0] - vectA[0] * vectB[2];
	result[2] = vectA[0] * vectB[1] - vectA[1] * vectB[0];
	return result;
}

float *vectorMatrixMult(float *vector, float **matrix, long row)
{
	/*
	int i;
	float *result;
	float **matrixA;
	float *vectA;

	result = new float[row];
	matrixA = matrixTranspose(matrix, row);
	for (i = 0; i < row; i++)
	{
		vectA = matrixRow(matrixA, row, i);
		result[i] = vectorDotProduct(vector, vectA, row);
		delete []vectA;
	}
	matrixFree(matrixA, row);
	*/

	/* NEW OPTIMIZED CODE */
	int i;
	float *result;

	result = new float[4];
	for (i = 0; i < 4; i++)
		result[i] =
			vector[0] * matrix[0][i] +
			vector[1] * matrix[1][i] +
			vector[2] * matrix[2][i] +
			vector[3] * matrix[3][i];
	return result;
}

/* returns cosine of angle between vectA and vectB */
/* (NOTE: zero is orthogonal, one is parallel) */
/* (use this as the alpha value for face shading) */
float vectorAngle(float *vectA, float *vectB, long length)
{
	float result;
	float *vectC;
	float *vectD;

	vectC = vectorNormalize(vectA, length);
	vectD = vectorNormalize(vectB, length);
	result = vectorDotProduct(vectC, vectD, length);
	delete []vectC;
	delete []vectD;
	return result;
}

/* returns component of vectA along direction of vectB */
float *vectorCompAlong(float *vectA, float *vectB, long length)
{
	float *result;
	float *vectC;
	float temp;

	vectC = vectorNormalize(vectB, length);
	temp = vectorDotProduct(vectA, vectC, length);
	result = vectorScale(vectC, length, temp);
	delete []vectC;
	return result;
}

/* returns other component of vectA */
float *vectorCompOrthog(float *vectA, float *vectB, long length)
{
	float *result;
	float *vectC;

	vectC = vectorCompAlong(vectA, vectB, length);
	result = vectorSubtract(vectA, vectC, length);
	delete []vectC;
	return result;
}

/* returns reflection of vectA off surface with normal vectB */
float *vectorReflect(float *vectA, float *vectB, long length)
{
	float *result;
	float *vectC;
	float *vectD;

	vectC = vectorCompAlong(vectA, vectB, length);
	vectD = vectorScale(vectC, length, -2);
	result = vectorAdd(vectA, vectD, length);
	delete []vectC;
	delete []vectD;
	return result;
}

float *vectorNull(long length)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = 0;
	return result;
}

float *vectorUnit(long length)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = 1;
	return result;
}

float *vectorRandom(long length)
{
	int i;
	float *result;

	result = new float[length];
	for (i = 0; i < length; i++)
		result[i] = randEx(0, 1);
	return result;
}
