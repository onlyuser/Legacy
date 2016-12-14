#include "scene.h"

scene::scene()
{
	/* data */
	mVertex = NULL;
	cVertex = NULL;
	sVertex = NULL;
	mVertColor = NULL;
	mFacePtr = NULL;
	mFaceDepth = NULL;

	/* misc */
	mVertCount = 0;
	mFaceCount = 0;
	mVisFaceCount = 0;
	mDrawMode = 2;
	mDblSided = false;
}

scene::~scene()
{
	/* data */
	if (mVertCount != 0)
	{
		matrixFree(mVertex, mVertCount);
		matrixFree(cVertex, mVertCount);
		matrixFree(sVertex, mVertCount);
		delete []mVertColor;
	}
	if (mVisFaceCount != 0)
	{
		delete []mFacePtr;
		delete []mFaceDepth;
	}
}

void scene::refresh()
{
	mesh *pMesh;

	if (mVertCount != 0)
	{
		matrixFree(mVertex, mVertCount);
		matrixFree(cVertex, mVertCount);
		matrixFree(sVertex, mVertCount);
		delete []mVertColor;
		delete []mFacePtr;
		delete []mFaceDepth;
	}
	mVertCount = 0;
	mFaceCount = 0;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh->mVisible)
		{
			mVertCount += mMeshList.getData()->mVertCount;
			mFaceCount += mMeshList.getData()->mFaceCount;
		}
	}
	mVertex = matrixNull(mVertCount, 4);
	cVertex = matrixNull(mVertCount, 4);
	sVertex = matrixNull(mVertCount, 4);
	mVertColor = new long[mVertCount];
	mFacePtr = new face *[mFaceCount];
	mFaceDepth = new float[mFaceCount];
}

long scene::render(long camIndex, surface *pSurface)
{
	long result;
	camera *pCamera;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	if (mVertCount != 0)
	{
		mVertex = matrixUpdate(mVertex, applyTrans(), mVertCount);
		cVertex = matrixUpdate(cVertex, pCamera->applyTrans(mVertex, mVertCount), mVertCount);
		sVertex = matrixUpdate(sVertex, pCamera->project(cVertex, mVertCount), mVertCount);
		cullFaces(camIndex);
	}
	pSurface->clearScreen();
	if (mVisFaceCount != 0)
	{
		sort(mFaceDepth, mFacePtr, 0, mVisFaceCount - 1);
		drawFaces(pSurface, camIndex);
	}
	result = mVisFaceCount;
	return result;
}

void scene::reset()
{
	mMeshList.clear();
	mCameraList.clear();
	mLightList.clear();
	refresh();
}

float **scene::applyTrans()
{
	int i;
	float **result;
	long index;
	mesh *pMesh;
	float **vertex;

	forceHierarchy();
	result = new float *[mVertCount];
	index = 0;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh->mVisible)
		{
			vertex = pMesh->applyTrans();
			pMesh->mBase = index;
			for (i = 0; i < pMesh->mVertCount; i++)
			{
				result[index] = vertex[i];
				index++;
			}
			delete []vertex;
		}
	}
	return result;
}

void scene::forceHierarchy()
{
	mesh *pMesh;
	bool more;

	do
	{
		more = false;
		for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
		{
			pMesh = mMeshList.getData();
			if (pMesh->mParent != NULL)
			{
				if (pMesh->mParent->mChanged && !pMesh->mChanged)
				{
					pMesh->buildTrans();
					more = true;
				}
			}
		}
	} while (more);
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		pMesh->mChanged = false;
	}
}

void scene::cullFaces(long camIndex)
{
	int i;
	camera *pCamera;
	float fovHalfTan;
	mesh *pMesh;
	face *pFace;
	float *vectFaceNormal;
	float *vectFaceCenter;
	float *vectToCamera;
	long indexA;
	long indexB;
	long indexC;
	float scrA;
	float scrB;
	float scrC;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	fovHalfTan = (float) tan(pCamera->mFov / 2);
	mVisFaceCount = 0;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		for (i = 0; i < pMesh->mFaceCount; i++)
		{
			pFace = &(pMesh->mFace[i]);
			pFace->mBase = pMesh->mBase;
			indexA = pMesh->mBase + pFace->a;
			indexB = pMesh->mBase + pFace->b;
			indexC = pMesh->mBase + pFace->c;
			if (
				sVertex[indexA][2] > 0 && sVertex[indexA][2] < 1 &&
				sVertex[indexB][2] > 0 && sVertex[indexB][2] < 1 &&
				sVertex[indexC][2] > 0 && sVertex[indexC][2] < 1
			)
			{
				scrA = fovHalfTan * cVertex[indexA][2];
				scrB = fovHalfTan * cVertex[indexB][2];
				scrC = fovHalfTan * cVertex[indexC][2];
				if (
					(
						fabs(cVertex[indexA][0]) < scrA &&
						fabs(cVertex[indexA][1]) < scrA
					) ||
					(
						fabs(cVertex[indexB][0]) < scrB &&
						fabs(cVertex[indexB][1]) < scrB
					) ||
					(
						fabs(cVertex[indexC][0]) < scrC &&
						fabs(cVertex[indexC][1]) < scrC
					)
				)
				{
					vectFaceNormal =
						faceNormal(
							mVertex[indexA],
							mVertex[indexB],
							mVertex[indexC]
						);
					vectFaceCenter =
						faceCenter(
							mVertex[indexA],
							mVertex[indexB],
							mVertex[indexC]
						);
					vectToCamera = vectorSubtract(pCamera->mOrigin, vectFaceCenter, 3);
					if (vectorAngle(vectFaceNormal, vectToCamera, 3) > 0 || mDblSided)
					{
						mVisFaceCount++;
						mFacePtr[mVisFaceCount - 1] = pFace;
						mFaceDepth[mVisFaceCount - 1] =
							sVertex[indexA][2] +
							sVertex[indexB][2] +
							sVertex[indexC][2];
						pFace->mShade =
							shadeFace(
								vectFaceNormal,
								vectFaceCenter,
								vectToCamera,
								pFace->mColor,
								pFace->mAlpha,
								camIndex
							);
					}
					delete []vectFaceNormal;
					delete []vectFaceCenter;
					delete []vectToCamera;
				}
			}
		}
	}
}

long scene::shadeFace(float *vectFaceNormal, float *vectFaceCenter, float *vectToCamera, long color, float alpha, long camIndex)
{
	int i;
	long result;
	camera *pCamera;
	float *sumColor;
	light *pLight;
	float *vectLight;
	float *vectReflect;
	float *vectToLight;
	float tempA;
	float tempB;
	float tempC;
	float tempD;
	long intensity;

	if (mLightList.count() != 0)
	{
		mCameraList.toIndex(camIndex);
		pCamera = mCameraList.getData();
		sumColor = vectorNull(3);
		for (mLightList.moveFirst(); !mLightList.eof(); mLightList.moveNext())
		{
			pLight = mLightList.getData();
			if (pLight->mEnabled)
			{
				vectLight = vectorSubtract(vectFaceCenter, pLight->mOrigin, 3);
				vectToLight = vectorScale(vectLight, 3, -1);
				tempA = vectorAngle(vectToLight, vectFaceNormal, 3);
				if (tempA > 0)
				{
					if (pCamera->mFog)
					{
						tempC = vectorModulus(vectToLight, 3);
						tempC = (tempC - pLight->mNear) / pLight->mFar;
						if (tempC > 1) tempC = 1;
						if (tempC < 0) tempC = 0;
						tempD = vectorModulus(vectToCamera, 3);
						tempD = (tempD - pCamera->mNear) / pCamera->mFar;
						if (tempD > 1) tempD = 1;
						if (tempD < 0) tempD = 0;
						tempA *= (1 - tempC) * (1 - tempD);
					}
					sumColor[0] += colorElem(pLight->mColor, 'r') * tempA;
					sumColor[1] += colorElem(pLight->mColor, 'g') * tempA;
					sumColor[2] += colorElem(pLight->mColor, 'b') * tempA;
					if (pCamera->mReflect)
					{
						vectReflect = vectorReflect(vectLight, vectFaceNormal, 3);
						tempB = vectorAngle(vectReflect, vectToCamera, 3);
						if (tempB > 0)
						{
							tempB = (float) pow(tempB, alpha);
							if (pCamera->mFog)
								tempB *= tempA;
							intensity = colorIntensity(pLight->mColor);
							sumColor[0] += intensity * tempB;
							sumColor[1] += intensity * tempB;
							sumColor[2] += intensity * tempB;
						}
						delete []vectReflect;
					}
				}
				delete []vectLight;
				delete []vectToLight;
			}
		}
		for (i = 0; i < 3; i++)
			if (sumColor[i] > 255)
				sumColor[i] = 255;
		result = rgb((long) sumColor[0], (long) sumColor[1], (long) sumColor[2]);
		delete []sumColor;
		result = colorSect(color, result);
	}
	else
		result = color;
	return result;
}

void scene::calcGradients(long camIndex)
{
	int i;
	int j;
	float **vectVertNormal;
	float **vectVertColor;
	float *vectVertAlpha;
	long *vectVertTally;
	mesh *pMesh;
	face *pFace;
	float *vectFaceNormal;
	float *vectFaceColor;
	long index;
	float *vectToCamera;
	camera *pCamera;
	long indexA;
	long indexB;
	long indexC;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	vectVertNormal = matrixNull(mVertCount, 3);
	vectVertColor = matrixNull(mVertCount, 3);
	vectVertAlpha = vectorNull(mVertCount);
	vectVertTally = new long[mVertCount];
	for (i = 0; i < mVertCount; i++)
		vectVertTally[i] = 0;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		for (i = 0; i < pMesh->mFaceCount; i++)
		{
			pFace = &(pMesh->mFace[i]);
			indexA = pMesh->mBase + pFace->a;
			indexB = pMesh->mBase + pFace->b;
			indexC = pMesh->mBase + pFace->c;
			vectFaceNormal =
				faceNormal(
					mVertex[indexA],
					mVertex[indexB],
					mVertex[indexC]
				);
			vectFaceColor = vectorFromColor(pFace->mColor);
			for (j = 0; j < 3; j++)
			{
				switch (j)
				{
				case 0: index = indexA; break;
				case 1: index = indexB; break;
				case 2: index = indexC;
				}
				vectVertNormal[index] =
					vectorUpdate(
						vectVertNormal[index],
						vectorAdd(vectVertNormal[index], vectFaceNormal, 3)
					);
				vectVertColor[index] =
					vectorUpdate(
						vectVertColor[index],
						vectorAdd(vectVertColor[index], vectFaceColor, 3)
					);
				vectVertAlpha[index] += pFace->mAlpha;
				vectVertTally[index]++;
			}
			delete []vectFaceNormal;
			delete []vectFaceColor;
		}
	}
	for (i = 0; i < mVertCount; i++)
	{
		if (vectVertTally[i] != 0)
		{
			vectVertNormal[i] =
				vectorUpdate(
					vectVertNormal[i],
					vectorScale(vectVertNormal[i], 3, (float) 1 / vectVertTally[i])
				);
			vectVertColor[i] =
				vectorUpdate(
					vectVertColor[i],
					vectorScale(vectVertColor[i], 3, (float) 1 / vectVertTally[i])
				);
			vectVertAlpha[i] /= vectVertTally[i];
		}
		vectToCamera = vectorSubtract(pCamera->mOrigin, mVertex[i], 3);
		mVertColor[i] =
			shadeFace(
				vectVertNormal[i],
				mVertex[i],
				vectToCamera,
				rgb((long) vectVertColor[i][0], (long) vectVertColor[i][1], (long) vectVertColor[i][2]),
				vectVertAlpha[i],
				camIndex
			);
		delete []vectToCamera;
	}
	matrixFree(vectVertNormal, mVertCount);
	matrixFree(vectVertColor, mVertCount);
	delete []vectVertAlpha;
	delete []vectVertTally;
}

void scene::drawFaces(surface *pSurface, long camIndex)
{
	int i;
	long indexA;
	long indexB;
	long indexC;

	switch (mDrawMode)
	{
	case 0:
		for (i = mVisFaceCount - 1; i >= 0; i--)
		{
			indexA = mFacePtr[i]->mBase + mFacePtr[i]->a;
			indexB = mFacePtr[i]->mBase + mFacePtr[i]->b;
			indexC = mFacePtr[i]->mBase + mFacePtr[i]->c;
			drawTriangleEx(
				pSurface,
				(long) sVertex[indexA][0],
				(long) sVertex[indexA][1],
				(long) sVertex[indexB][0],
				(long) sVertex[indexB][1],
				(long) sVertex[indexC][0],
				(long) sVertex[indexC][1],
				mFacePtr[i]->mShade
			);
		}
		break;
	case 1:
		for (i = mVisFaceCount - 1; i >= 0; i--)
		{
			indexA = mFacePtr[i]->mBase + mFacePtr[i]->a;
			indexB = mFacePtr[i]->mBase + mFacePtr[i]->b;
			indexC = mFacePtr[i]->mBase + mFacePtr[i]->c;
			pSurface->drawTriangle(
				(long) sVertex[indexA][0],
				(long) sVertex[indexA][1],
				(long) sVertex[indexB][0],
				(long) sVertex[indexB][1],
				(long) sVertex[indexC][0],
				(long) sVertex[indexC][1],
				mFacePtr[i]->mShade
			);
		}
		break;
	case 2:
		calcGradients(camIndex);
		for (i = mVisFaceCount - 1; i >= 0; i--)
		{
			indexA = mFacePtr[i]->mBase + mFacePtr[i]->a;
			indexB = mFacePtr[i]->mBase + mFacePtr[i]->b;
			indexC = mFacePtr[i]->mBase + mFacePtr[i]->c;
			pSurface->drawGradient(
				(long) sVertex[indexA][0],
				(long) sVertex[indexA][1],
				(long) sVertex[indexB][0],
				(long) sVertex[indexB][1],
				(long) sVertex[indexC][0],
				(long) sVertex[indexC][1],
				mVertColor[indexA],
				mVertColor[indexB],
				mVertColor[indexC]
			);
		}
	}
}
