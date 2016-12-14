#include "misc.h"

PFNGLLOCKARRAYSEXTPROC glLockArraysEXT = NULL;
PFNGLUNLOCKARRAYSEXTPROC glUnlockArraysEXT = NULL;

void init_EXT_CVA()
{
	glLockArraysEXT = (PFNGLLOCKARRAYSEXTPROC) wglGetProcAddress("glLockArraysEXT");
	glUnlockArraysEXT = (PFNGLUNLOCKARRAYSEXTPROC) wglGetProcAddress("glUnlockArraysEXT");
}

long findText(char *text, char *token)
{
	long i;
	long j;
	long result;
	bool stopFlag;

	result = -1;
	for (i = 0; text[i] != 0 && result == -1; i++)
	{
		stopFlag = false;
		for (j = 0; text[i + j] != 0 && token[j] != 0 && !stopFlag; j++)
			if (text[i + j] != token[j])
				stopFlag = true;
		if (!stopFlag)
			result = i;
	}
	return result;
}

void vectorFromAngle(float *result, float *angle)
{
	float *tempA;
	float **tempB;

	tempA = new float[3];
	tempB = matrixAlloc();
	tempA[0] = 0;
	tempA[1] = 0;
	tempA[2] = 1;
	matrixRotate(tempB, 'x', angle[1]);
	vectorMatrixMult(tempA, tempA, tempB);
	matrixRotate(tempB, 'y', angle[2]);
	vectorMatrixMult(tempA, tempA, tempB);
	vectorCopy(result, tempA);
	delete []tempA;
	matrixFree(tempB);
}

void angleFromVector(float *result, float *vector)
{
	float *tempA;
	float *tempB;
	float *tempC;

	tempA = new float[3];
	tempB = new float[3];
	tempC = new float[3];
	tempA[0] = 0;
	tempB[0] = vector[0];
	tempB[1] = 0;
	tempB[2] = vector[2];
	tempA[1] = acosEx(vectorAngle(tempB, vector));
	tempC[0] = 0;
	tempC[1] = 0;
	tempC[2] = 1;
	tempA[2] = acosEx(vectorAngle(tempB, tempC));
	if (vector[0] < 0) tempA[2] *= -1;
	if (vector[1] > 0) tempA[1] *= -1;
	vectorCopy(result, tempA);
	delete []tempA;
	delete []tempB;
	delete []tempC;
}

void makeBox(float **box)
{
	long i;
	long j;
	long k;
	long index;

	index = 2;
	for (k = 0; k < 2; k++)
	{
		for (i = 0; i < 3; i++)
		{
			for (j = 0; j < 3; j++)
			{
				if (j == i)
					box[index][j] = box[k][j];
				else
					box[index][j] = box[1 - k][j];
			}
			index++;
		}
	}
}

void getFaceNorm(float *result, float *vectA, float *vectB, float *vectC)
{
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	vectorSub(tempA, vectB, vectA);
	vectorSub(tempB, vectC, vectA);
	vectorCross(result, tempA, tempB);
	delete []tempA;
	delete []tempB;
}

float vectorPlaneDist(float *vector, float *vectA, float *vectB, float *vectC)
{
	float result;
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	getFaceNorm(tempA, vectA, vectB, vectC);
	vectorSub(tempB, vectA, vector);
	vectorAlong(tempB, tempB, tempA);
	result = vectorMod(tempB);
	delete []tempA;
	delete []tempB;
	return result;
}

long rgb(BYTE r, BYTE g, BYTE b)
{
	long result;

	result = 0;
	result = (result | b) << 8;
	result = (result | g) << 8;
	result = (result | r);
	return result;
}

long colorElem(long color, char name)
{
	long result;

	switch (name)
	{
	case 'r': result = (color & 0xff); break;
	case 'g': result = (color & 0xff00) >> 8; break;
	case 'b': result = (color & 0xff0000) >> 16;
	}
	return result;
}

char *strCpy(char *text)
{
	char *result;

	result = new char[strlen(text) + 1];
	strcpy(result, text);
	return result;
}

char *strCat(char *textA, char *textB)
{
	char *result;

	result = new char[strlen(textA) + strlen(textB) + 1];
	strcpy(result, textA);
	strcat(result, textB);
	return result;
}

char *strLoad(char *filename)
{
	char *result;
	FILE *stream;
	long length;

	result = NULL;
	if (filename != NULL)
		stream = fopen(filename, "rb");
	else
		stream = NULL;
	if (stream != NULL)
	{
		fseek(stream, 0, SEEK_END);
		length = ftell(stream);
		result = strSpace(length);
		fseek(stream, 0, SEEK_SET);
		fread(result, sizeof(char), length, stream);
		fclose(stream);
	}
	if (result == NULL)
		result = strSpace(0);
	return result;
}

char *strScan(char *text, long &start, char *stopTerm)
{
	long i;
	char *result;
	char *tempA;
	long length;
	long lenStop;

	result = NULL;
	length = strlen(text);
	lenStop = strlen(stopTerm);
	for (i = start; i < length - lenStop + 1 && result == NULL; i++)
	{
		tempA = strMid(text, i, lenStop);
		if (strcmp(tempA, stopTerm) == 0)
		{
			result = strMid(text, start, i - start);
			start = i + lenStop;
		}
		delete []tempA;
	}
	if (i == length - lenStop + 1 && result == NULL)
	{
		result = strRight(text, length - start);
		start = length;
	}
	return result;
}

char *strTrim(char *text)
{
	long i;
	long j;
	long length;
	char *result;

	result = NULL;
	length = strlen(text);
	for (i = 0; text[i] != 0 && text[i] == ' '; i++);
	for (j = length - 1; j >= 0 && text[j] == ' '; j--);
	if (j >= i)
		result = strMid(text, i, j - i + 1);
	if (result == NULL)
		result = strSpace(0);
	return result;
}

char *strLeft(char *text, long length)
{
	char *result;

	result = strMid(text, 0, length);
	return result;
}

char *strRight(char *text, long length)
{
	char *result;
	long pLenA;

	pLenA = strlen(text);
	result = strMid(text, pLenA - length, length);
	return result;
}

char *strMid(char *text, long start, long length)
{
	long i;
	char *result;

	result = strSpace(length);
	for (i = 0; i < length; i++)
		result[i] = text[start + i];
	return result;
}

char *strSpace(long length)
{
	long i;
	char *result;

	result = new char[length + 1];
	for (i = 0; i < length; i++)
		result[i] = ' ';
	result[length] = 0;
	return result;
}