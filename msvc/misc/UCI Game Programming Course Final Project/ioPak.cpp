#include "scene.h"

long scene::loadPak(char *filename, char *path)
{
	long i;
	long j;
	long result;
	float *tempA;
	char *tempB;
	bool tempC;
	char *tempD;
	char *text;
	long pLenA;
	long pLenB;
	char *tokenA;
	char *tokenB;
	char *tokenC;
	char *tokenD;
	long indexA;
	long indexB;

	tempA = new float[3];
	text = strLoad(filename);
	indexA = 0;
	pLenA = strlen(text);
	i = 0;
	while (i < pLenA)
	{
		tokenA = strScan(text, i, "\r\n");
		if (strlen(tokenA) != 0)
		{
			if (tokenA[0] == 34)
			{
				tokenB = strMid(tokenA, 1, strlen(tokenA) - 2);
				tokenC = strCat(path, tokenB);
				switch (indexA)
				{
				case 0:
					result = 0;
					if (strcmp(tokenB, "box") == 0)
						result = addBox(1, 1, 1);
					if (strcmp(tokenB, "ramp") == 0)
						result = addRamp(1, 1, 1);
					if (strcmp(tokenB, "sphere") == 0)
						result = addGeo(1, 2);
					if (result == 0)
						result = load3ds(tokenC, -1);
					centAxis(result);
					break;
				case 1:
					if (tempA[1] == 1)
						tempC = true;
					else
						tempC = false;
					setTexture(result, tokenC, (long) tempA[0], tempC);
					break;
				case 2:
					tempD = strCpy(tokenC);
					break;
				case 3:
					setSprite(result, tempD, tokenC, tempA[0]);
					delete []tempD;
					break;
				case 4:
					tempD = strCpy(tokenB);
					break;
				case 5:
					setMeshName(result, tempD, tokenB);
					if (strcmp(tempD, "npc") == 0)
						setMotion(result, 1, true);
					delete []tempD;
				}
				indexA++;
				delete []tokenB;
				delete []tokenC;
			}
			else
			{
				j = 0;
				tempB = strScan(tokenA, j, "=(");
				tokenB = strScan(tokenA, j, ");");
				indexB = 0;
				pLenB = strlen(tokenB);
				j = 0;
				while (j < pLenB)
				{
					tokenC = strScan(tokenB, j, ",");
					tokenD = strTrim(tokenC);
					tempA[indexB] = (float) atof(tokenD);
					indexB++;
					delete []tokenC;
					delete []tokenD;
				}
				if (strcmp(tempB, "flip") == 0)
					if (tempA[0] == 1)
						flipFaces(result);
				if (strcmp(tempB, "angle") == 0)
					moveMesh(
						result,
						MOV_ROT,
						toRad(tempA[0]),
						toRad(tempA[1]),
						toRad(tempA[2])
					);
				if (strcmp(tempB, "origin") == 0)
					moveMesh(result, MOV_POS, tempA[0], tempA[1], tempA[2]);
				if (strcmp(tempB, "box") == 0)
					setBox(result, tempA[0], tempA[1], tempA[2]);
				if (strcmp(tempB, "base") == 0)
					if (tempA[0] == 1)
						alignMesh(result, tempA[1], DIR_BOTTOM);
				if (strcmp(tempB, "visible") == 0)
					if (tempA[0] == 0)
						enableMesh(result, false);
				if (strcmp(tempB, "solid") == 0)
					if (tempA[0] == 0)
						setMotion(result, 0, false);
				delete []tempB;
				delete []tokenB;
			}
		}
		else
			indexA = 0;
		delete []tokenA;
	}
	delete []tempA;
	delete []text;
	return result;
}