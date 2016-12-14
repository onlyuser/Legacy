#include "matrix.h"

void matrixCopy(float **result, float **matrix)
{
	long i;
	long j;

	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			result[i][j] = matrix[i][j];
}

float **matrixAlloc()
{
	long i;
	float **result;

	result = new float *[4];
	for (i = 0; i < 4; i++)
		result[i] = new float[4];
	return result;
}

void matrixFree(float **matrix)
{
	long i;

	for (i = 0; i < 4; i++)
		delete []matrix[i];
	delete []matrix;
}

float **matrixAlloc(long row, long col)
{
	int i;
	float **result;

	result = new float *[row];
	for (i = 0; i < row; i++)
		result[i] = new float[col];
	return result;
}

void matrixFree(float **matrix, long row)
{
	int i;

	for (i = 0; i < row; i++)
		delete []matrix[i];
	delete []matrix;
}

void matrixMult(float **result, float **matrixA, float **matrixB)
{
	long i;
	long j;
	float **tempA;

	tempA = matrixAlloc();
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			tempA[i][j] =
				matrixA[i][0] * matrixB[0][j] +
				matrixA[i][1] * matrixB[1][j] +
				matrixA[i][2] * matrixB[2][j] +
				matrixA[i][3] * matrixB[3][j];
	matrixCopy(result, tempA);
	matrixFree(tempA);
}

void matrixScale(float **result, float **matrix, float scale)
{
	long i;

	for (i = 0; i < 3; i++)
		vectorScale(result[i], matrix[i], scale);
}

void matrixTranspose(float **result, float **matrix)
{
	int i;
	int j;
	float **tempA;

	tempA = matrixAlloc();
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			tempA[i][j] = matrix[j][i];
	matrixCopy(result, tempA);
	matrixFree(tempA);
}

void matrixMinor(float **result, float **matrix, long row, long col, long pRow, long pCol)
{
	int i;
	int j;
	long tempA;
	long tempB;

	tempA = 0;
	for (i = 0; i < row; i++)
		if (i != pRow)
		{
			tempB = 0;
			for (j = 0; j < col; j++)
				if (j != pCol)
				{
					result[tempA][tempB] = matrix[i][j];
					tempB++;
				}
			tempA++;
		}
}

float matrixCofact(float **minor, float **matrix, long size, long pRow, long pCol)
{
	float result;

	matrixMinor(minor, matrix, size, size, pRow, pCol);
	result = (float) pow(-1, pRow + pCol) * matrixDet(minor, size - 1);
	return result;
}

float matrixDet(float **matrix, long size)
{
	int i;
	float result;
	float **minor;

	if (size > 1)
	{
		minor = matrixAlloc(size - 1, size - 1);
		result = 0;
		for (i = 0; i < size; i++)
			result += matrix[0][i] * matrixCofact(minor, matrix, size, 0, i);
		matrixFree(minor, size - 1);
	}
	else
		result = matrix[0][0];
	return result;
}

void matrixInv(float **result, float **matrix)
{
	int i;
	int j;
	float **matrixA;
	float **minor;
	float temp;

	matrixA = matrixAlloc();
	minor = matrixAlloc(3, 3);
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			matrixA[i][j] = matrixCofact(minor, matrix, 4, i, j);
	matrixFree(minor, 3);
	temp = matrixDet(matrixA, 4);
	if (temp != 0)
	{
		matrixScale(matrixA, matrixA, 1 / temp);
		matrixTranspose(result, matrixA);
	}
	else
		matrixNull(result);
	matrixFree(matrixA);
}

void matrixScaling(float **result, float *vector)
{
	long i;

	matrixIdent(result);
	for (i = 0; i < 3; i++)
		result[i][i] = vector[i];
}

void matrixTrans(float **result, float *vector)
{
	long i;

	matrixIdent(result);
	for (i = 0; i < 3; i++)
		result[3][i] = vector[i];
}

void matrixRotate(float **result, char axis, float angle)
{
	float tempA;
	float tempB;

	matrixIdent(result);
	tempA = (float) sin(angle);
	tempB = (float) cos(angle);
	switch (axis)
	{
	case 'x':
		result[1][1] = tempB;
		result[1][2] = tempA;
		result[2][1] = -tempA;
		result[2][2] = tempB;
		break;
	case 'y':
		result[0][0] = tempB;
		result[0][2] = -tempA;
		result[2][0] = tempA;
		result[2][2] = tempB;
		break;
	case 'z':
		result[0][0] = tempB;
		result[0][1] = tempA;
		result[1][0] = -tempA;
		result[1][1] = tempB;
	}
}

void matrixTransEx(float **result, float *trans, float *rot, float *scale)
{
	float **tempA;

	tempA = matrixAlloc();
	matrixScaling(result, scale);
	matrixRotate(tempA, 'z', rot[0]); /* roll */
	matrixMult(result, result, tempA);
	matrixRotate(tempA, 'x', rot[1]); /* pitch */
	matrixMult(result, result, tempA);
	matrixRotate(tempA, 'y', rot[2]); /* yaw */
	matrixMult(result, result, tempA);
	matrixTrans(tempA, trans);
	matrixMult(result, result, tempA);
	matrixFree(tempA);
}

void matrixProj(float **result, long sw, long sh, float aspect, float fov, float n, float f, bool perspect, float zoom)
{
	float cx;
	float cy;
	float h;
	float tempA;
	float tempB;

	cx = (float) sw / 2;
	cy = (float) sh / 2;
	matrixNull(result);
	if (n > 0 && n < f)
	{
		if (perspect)
		{
			h = (float) tan(fov / 2) * n;
			tempA = h / n;
			tempB = f / (n - f);
			result[0][0] = cx / aspect;
			result[1][1] = -cy;
			result[2][0] = -cx * tempA;
			result[2][1] = -cy * tempA;
			result[2][2] = tempA * tempB;
			result[2][3] = -tempA;
			result[3][2] = -h * tempB;
		}
		else
		{
			tempA = 1 / (n - f);
			result[0][0] = zoom / aspect;
			result[1][1] = -zoom;
			result[2][2] = -tempA;
			result[3][0] = cx;
			result[3][1] = cy;
			result[3][2] = n * tempA;
			result[3][3] = 1;
		}
	}
}

void matrixNull(float **result)
{
	long i;
	long j;

	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			result[i][j] = 0;
}

void matrixIdent(float **result)
{
	long i;

	matrixNull(result);
	for (i = 0; i < 4; i++)
		result[i][i] = 1;
}