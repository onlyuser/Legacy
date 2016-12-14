#include "scene.h"

long scene::addPoly(float radius, long lngSteps, long latSteps)
{
	int i;
	int j;
	int k;
	long result;
	mesh *pMesh;
	float lngAngle;
	float latAngle;
	float *vector;
	float **pVertex;
	face *pFace;
	long count;
	long faceCount;
	long width;
	long height;

	vector = new float[3];
	result = addMesh(1, 1);
	mMeshList.toIndex(result);
	pMesh = mMeshList.getData();
	width = lngSteps;
	height = latSteps + 1;
	count = width * height;
	faceCount = width * (height - 1) * 2;

	pVertex = matrixAlloc(count, 3);
	count = 0;
	for (i = 0; i <= latSteps; i++)
	{
		latAngle = -PI / 2 + (float) i / latSteps * PI;
		for (j = 0; j < lngSteps; j++)
		{
			lngAngle = (float) j / lngSteps * PI * 2;
			vector[0] = 0;
			vector[1] = latAngle;
			vector[2] = lngAngle;
			vector = vectorUpdate(vector, vectorFromAngles(vector));
			vector = vectorUpdate(vector, vectorScale(vector, 3, radius));
			for (k = 0; k < 3; k++)
				pVertex[count][k] = vector[k];
			count++;
		}
	}
	matrixFree(pMesh->mVertex, 1);
	pMesh->mVertex = pVertex;
	pMesh->mVertCount = count;

	pFace = new face[faceCount];
	count = 0;
	for (i = 0; i < faceCount; i += 2)
	{
		pFace[i].a = count;
		pFace[i].b = count + width;
		pFace[i].c = count + width + 1;
		if ((count + 1) % width == 0)
			pFace[i].c = (pFace[i].c % width) + (pFace[i].c / width - 1) * width;
		pFace[i + 1].a = pFace[i].c;
		pFace[i + 1].b = count + 1;
		pFace[i + 1].c = pFace[i].a;
		if ((count + 1) % width == 0)
			pFace[i + 1].b =
				(pFace[i + 1].b % width) +
				(pFace[i + 1].b / width - 1) * width;
		count++;
	}
	delete [](pMesh->mFace);
	pMesh->mFace = new face[faceCount];
	for (i = 0; i < faceCount; i++)
	{
		pMesh->mFace[i].a = pFace[i].a;
		pMesh->mFace[i].b = pFace[i].b;
		pMesh->mFace[i].c = pFace[i].c;
	}
	pMesh->mFaceCount = faceCount;
	delete []pFace;

	delete []vector;
	fixMesh(result);
	refresh();
	setColor(result, -1, 0xFFFFFF, 3);
	return result;
}

void scene::fixMesh(long meshIndex)
{
	fixVertices(meshIndex);
	fixFaces(meshIndex);
}

void scene::fixVertices(long meshIndex)
{
	int i;
	int j;
	mesh *pMesh;
	long match;
	long count;
	face *pFace;
	float **pVertex;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	count = 0;
	for (i = 0; i < pMesh->mVertCount; i++)
	{
		match = -1;
		for (j = 0; j < i; j++)
			if (vectorDistance(pMesh->mVertex[j], pMesh->mVertex[i], 3) < 0.001)
			{
				match = j;
				break;
			}
		if (match == -1) /* if vertex is unique */
		{
			for (j = 0; j < 3; j++)
				pMesh->mVertex[count][j] = pMesh->mVertex[i][j];
			for (j = 0; j < pMesh->mFaceCount; j++)
			{
				pFace = &(pMesh->mFace[j]);
				if (pFace->a == i) pFace->a = count;
				if (pFace->b == i) pFace->b = count;
				if (pFace->c == i) pFace->c = count;
			}
			count++;
		}
		else
			for (j = 0; j < pMesh->mFaceCount; j++)
			{
				pFace = &(pMesh->mFace[j]);
				if (pFace->a == i) pFace->a = match;
				if (pFace->b == i) pFace->b = match;
				if (pFace->c == i) pFace->c = match;
			}
	}
	pVertex = matrixAlloc(count, 3);
	for (i = 0; i < count; i++)
		for (j = 0; j < 3; j++)
			pVertex[i][j] = pMesh->mVertex[i][j];
	matrixFree(pMesh->mVertex, pMesh->mVertCount);
	pMesh->mVertex = pVertex;
	pMesh->mVertCount = count;
}

void scene::fixFaces(long meshIndex)
{
	int i;
	mesh *pMesh;
	long count;
	face *pFace;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	count = 0;
	for (i = 0; i < pMesh->mFaceCount; i++)
	{
		pFace = &(pMesh->mFace[i]);
		if (
			pFace->a != pFace->b &&
			pFace->b != pFace->c &&
			pFace->c != pFace->a
		) /* if face is legal */
		{
			pMesh->mFace[count].a = pMesh->mFace[i].a;
			pMesh->mFace[count].b = pMesh->mFace[i].b;
			pMesh->mFace[count].c = pMesh->mFace[i].c;
			count++;
		}
	}
	pFace = new face[count];
	for (i = 0; i < count; i++)
	{
		pFace[i].a = pMesh->mFace[i].a;
		pFace[i].b = pMesh->mFace[i].b;
		pFace[i].c = pMesh->mFace[i].c;
		pFace[i].mColor = pMesh->mFace[i].mColor;
		pFace[i].mAlpha = pMesh->mFace[i].mAlpha;
		pFace[i].mShade = pMesh->mFace[i].mShade;
		pFace[i].mBase = pMesh->mFace[i].mBase;
	}
	delete [](pMesh->mFace);
	pMesh->mFace = pFace;
	pMesh->mFaceCount = count;
}
