#include "scene.h"

void scene::loadMatLib(char *filename)
{
	long i;
	long j;
	BYTE *tempA;
	char *text;
	long pLenA;
	long pLenB;
	char *tokenA;
	char *tokenB;
	char *tokenC;
	long indexA;
	long indexB;
	material *pMaterial;

	tempA = new BYTE[3];
	mMatList.clear();
	text = strLoad(filename);
	pLenA = strlen(text);
	i = 0;
	while (i < pLenA)
	{
		tokenA = strScan(text, i, "\r\n");
		if (strlen(tokenA) != 0)
		{
			if (tokenA[0] == 34)
			{
				pMaterial = new material();
				pLenB = strlen(tokenA);
				pMaterial->mName = strMid(tokenA, 1, pLenB - 2);
				indexA = 0;
			}
			else
			{
				if (indexA != 5)
				{
					indexB = 0;
					pLenB = strlen(tokenA);
					j = 0;
					while (j < pLenB)
					{
						tokenB = strScan(tokenA, j, ",");
						tokenC = strTrim(tokenB);
						switch (indexB)
						{
						case 0: tempA[0] = (BYTE) (atof(tokenC) * 255); break;
						case 1: tempA[1] = (BYTE) (atof(tokenC) * 255); break;
						case 2: tempA[2] = (BYTE) (atof(tokenC) * 255);
						case 3:
							switch (indexA)
							{
							case 1: pMaterial->mAmbient = rgb(tempA[0], tempA[1], tempA[2]); break;
							case 2: pMaterial->mDiffuse = rgb(tempA[0], tempA[1], tempA[2]); break;
							case 3: pMaterial->mSpecular = rgb(tempA[0], tempA[1], tempA[2]); break;
							case 4: pMaterial->mEmission = rgb(tempA[0], tempA[1], tempA[2]);
							}
						}
						indexB++;
						delete []tokenB;
						delete []tokenC;
					}
				}
				else
				{
					pMaterial->mShininess = (float) atof(tokenA);
					mMatList.add(pMaterial);
				}
			}
			indexA++;
		}
		delete []tokenA;
	}
	delete []tempA;
	delete []text;
}