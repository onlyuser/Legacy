#include "matrix.h"

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

void matrixCopy(float **result, float **matrix)
{
	long i;
	long j;

	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			result[i][j] = matrix[i][j];
}

float **matrixUpdate(float **matrixA, float **matrixB, long row)
{
	matrixFree(matrixA, row);
	return matrixB;
}

float **matrixTranspose(float **matrix, long row)
{
	int i;
	int j;
	float **result;

	result = matrixAlloc(row, row);
	for (i = 0; i < row; i++)
		for (j = 0; j < row; j++)
			result[j][i] = matrix[i][j];
	return result;
}

float *matrixRow(float **matrix, long col, long pRow)
{
	int i;
	float *result;

	result = new float[col];
	for (i = 0; i <= col; i++)
		result[i] = matrix[pRow][i];
	return result;
}

float **matrixScale(float **matrix, long row, long col, float scale)
{
	int i;
	int j;
	float **result;

	result = matrixAlloc(row, col);
	for (i = 0; i < row; i++)
		for (j = 0; j < col; j++)
			result[i][j] = matrix[i][j] * scale;
	return result;
}

float **matrixMult(float **matrixA, float **matrixB, long row)
{
	/*
	int i;
	int j;
	float **result;
	float **matrixC;
	float *vectA;
	float *vectB;

	result = matrixAlloc(row, row);
	matrixC = matrixTranspose(matrixB, row);
	for (i = 0; i < row; i++)
	{
		vectA = matrixRow(matrixA, row, i);
		for (j = 0; j < row; j++)
		{
			vectB = matrixRow(matrixC, row, j);
			result[i][j] = vectorDotProduct(vectA, vectB, row);
			delete []vectB;
		}
		delete []vectA;
	}
	matrixFree(matrixC, row);
	*/

	/* NEW OPTIMIZED CODE */
	int i;
	int j;
	float **result;

	result = matrixAlloc(4, 4);
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			result[i][j] =
				matrixA[i][0] * matrixB[0][j] +
				matrixA[i][1] * matrixB[1][j] +
				matrixA[i][2] * matrixB[2][j] +
				matrixA[i][3] * matrixB[3][j];
	return result;
}

/*
float **matrixMinor(float **matrix, long row, long col, long pRow, long pCol)
{
	int i;
	int j;
	float **result;
	long tempA;
	long tempB;

	result = matrixAlloc(row - 1, col - 1);
	tempA = 0;
	for (i = 0; i < row; i++)
	{
		if (i == pRow)
			tempA--;
		else
		{
			tempB = 0;
			for (j = 0; j < col; j++)
			{				
				if (j == pCol)
					tempB--;
				else
					result[tempA][tempB] = matrix[i][j];
				tempB++;
			}
		}
		tempA++;
	}
	return result;
}

float matrixCofact(float **matrix, long row, long col, long pRow, long pCol)
{
	float result;
	float **matrixA;

	matrixA = matrixMinor(matrix, row, col, pRow, pCol);
	result = (float) pow(-1, pRow + pCol) * matrixDet(matrixA, row - 1);
	matrixFree(matrixA, row - 1);
	return result;
}

float matrixDet(float **matrix, long row)
{
	int i;
	float result;

	if (row > 1)
	{
		result = 0;
		for (i = 0; i < row; i++)
			result += matrix[0][i] * matrixCofact(matrix, row, row, 0, i);
	}
	else
		result = matrix[0][0];
	return result;
}

float **matrixInv(float **matrix, long row)
{
	int i;
	int j;
	float **result;
	float **matrixA;
	float **matrixB;
	float temp;

	matrixA = matrixAlloc(row, row);
	for (i = 0; i < row; i++)
		for (j = 0; j < row; j++)
			matrixA[i][j] = matrixCofact(matrix, row, row, i, j);
	temp = matrixDet(matrixA, row);
	if (temp != 0)
	{
		matrixB = matrixScale(matrixA, row, row, 1 / temp);
		result = matrixTranspose(matrixB, row);
		matrixFree(matrixB, row);
	}
	else
		result = matrixNull(row, row);
	matrixFree(matrixA, row);
	return result;
}
*/

void matrixTranspose(float **result, float **matrix)
{
	int i;
	int j;
	float **tempA;

	tempA = matrixAlloc(4, 4);
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			tempA[i][j] = matrix[j][i];
	matrixCopy(result, tempA);
	matrixFree(tempA, 4);
}

void matrixMinor(float **result, float **matrix, long row, long col, long pRow, long pCol)
{
	int i;
	int j;
	long tempA;
	long tempB;

	tempA = 0;
	for (i = 0; i < row; i++)
	{
		if (i == pRow)
			tempA--;
		else
		{
			tempB = 0;
			for (j = 0; j < col; j++)
			{				
				if (j == pCol)
					tempB--;
				else
					result[tempA][tempB] = matrix[i][j];
				tempB++;
			}
		}
		tempA++;
	}
}

float matrixCofact(float **minor, float **matrix, long row, long col, long pRow, long pCol)
{
	float result;

	matrixMinor(minor, matrix, row, col, pRow, pCol);
	result = (float) pow(-1, pRow + pCol) * matrixDet(minor, row - 1);
	return result;
}

float matrixDet(float **matrix, long row)
{
	int i;
	float result;
	float **minor;

	if (row > 1)
	{
		minor = matrixAlloc(row - 1, row - 1);
		result = 0;
		for (i = 0; i < row; i++)
			result += matrix[0][i] * matrixCofact(minor, matrix, row, row, 0, i);
		matrixFree(minor, row - 1);
	}
	else
		result = matrix[0][0];
	return result;
}

float **matrixInv(float **matrix, long row)
{
	int i;
	int j;
	float **result;
	float **matrixA;
	float **minor;
	float temp;

	matrixA = matrixAlloc(4, 4);
	minor = matrixAlloc(3, 3);
	for (i = 0; i < 4; i++)
		for (j = 0; j < 4; j++)
			matrixA[i][j] = matrixCofact(minor, matrix, 4, 4, i, j);
	matrixFree(minor, 3);
	temp = matrixDet(matrixA, 4);
	if (temp != 0)
	{
		result = matrixAlloc(4, 4);
		matrixScale2(matrixA, matrixA, 1 / temp);
		matrixTranspose(result, matrixA);
	}
	else
		result = matrixNull(4, 4);
	matrixFree(matrixA, 4);
	return result;
}

void matrixScale2(float **result, float **matrix, float scale)
{
	long i;
	long j;

	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			result[i][j] = matrix[i][j] * scale;

	/*
	for (i = 0; i < 3; i++)
		vectorScale(result[i], matrix[i], scale);
	*/
}

float **matrixScaling(float *vector)
{
	int i;
	float **result;

	result = matrixIdent(4);
	for (i = 0; i < 3; i++)
		result[i][i] = vector[i];
	return result;
}

float **matrixTranslation(float *vector)
{
	int i;
	float **result;

	result = matrixIdent(4);
	for (i = 0; i < 3; i++)
		result[3][i] = vector[i];
	return result;
}

float **matrixRotation(char axis, float angle)
{
	float **result;
	float tempA;
	float tempB;

	result = matrixIdent(4);
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
	return result;
}

float **matrixProjection(long sw, long sh, float aspect, float fov, float n, float f, bool perspect, float zoom)
{
	float **result;
	float cx;
	float cy;
	float h;
	float tempA;
	float tempB;

	cx = (float) sw / 2;
	cy = (float) sh / 2;
	result = matrixNull(4, 4);
	if (n > 0 && n < f)
	{
		if (perspect)
		{
			h = (float) tan(fov / 2) * n;
			tempA = h / n;
			tempB = f / (f - n);
			result[0][0] = cx;
			result[1][1] = -cy * aspect;
			result[2][0] = cx * tempA;
			result[2][1] = cy * tempA;
			result[2][2] = tempA * tempB;
			result[2][3] = tempA;
			result[3][2] = -h * tempB;
		}
		else
		{
			tempA = 1 / (f - n);
			result[0][0] = zoom;
			result[1][1] = -zoom * aspect;
			result[2][2] = tempA;
			result[3][0] = cx;
			result[3][1] = cy;
			result[3][2] = -n * tempA;
			result[3][3] = 1;
		}
	}
	return result;
}

float **matrixTransform(float *scale, float *translate, float *rotate)
{
	float **result;
	float **matrixA;
	float **matrixB;
	float **matrixC;
	float **matrixD;
	float **matrixE;

	matrixA = matrixScaling(scale);
	matrixB = matrixRotation('z', rotate[0]); // roll
	matrixC = matrixRotation('x', rotate[1]); // pitch
	matrixD = matrixRotation('y', rotate[2]); // yaw
	matrixE = matrixTranslation(translate);
	result = matrixIdent(4);
	result = matrixUpdate(result, matrixMult(result, matrixA, 4), 4);
	result = matrixUpdate(result, matrixMult(result, matrixB, 4), 4);
	result = matrixUpdate(result, matrixMult(result, matrixC, 4), 4);
	result = matrixUpdate(result, matrixMult(result, matrixD, 4), 4);
	result = matrixUpdate(result, matrixMult(result, matrixE, 4), 4);
	matrixFree(matrixA, 4);
	matrixFree(matrixB, 4);
	matrixFree(matrixC, 4);
	matrixFree(matrixD, 4);
	matrixFree(matrixE, 4);
	return result;
}

float **matrixNull(long row, long col)
{
	int i;
	int j;
	float **result;

	result = matrixAlloc(row, col);
	for (i = 0; i < row; i++)
		for (j = 0; j < col; j++)
			result[i][j] = 0;
	return result;
}

float **matrixIdent(long row)
{
	int i;
	float **result;

	result = matrixNull(row, row);
	for (i = 0; i < row; i++)
		result[i][i] = 1;
	return result;
}
