#include "mesh.h"

mesh::mesh(long vertCnt, long faceCnt)
{
	/* data */
	update(matrixAlloc(vertCnt, 3), new face[faceCnt], vertCnt, faceCnt, false, true);
	mBox = matrixAlloc(8, 3);
	mBoxEx = matrixAlloc(8, 3);
	mAttrib = matrixAlloc(4, 4);
	mPartSys.mFreq = 0;
	mPartSys.mBucket = 0;
	mTreeNode = NULL;
	mName = NULL;
	mTag = NULL;

	/* attributes */
	mRadius = 0;
	setParams(0x808080, 0xC0C0C0, 0xFFFFFF, 0x0, 64);
	mMapDir = 0;
	mSkyBox = false;
	mVisible = true;
	mInFrust = false;
	mNext = NULL;

	/* default */
	setColor(0xFFFFFF);
}

mesh::~mesh()
{
	/* data */
	update(NULL, NULL, 0, 0, true, false);
	matrixFree(mBox, 8);
	matrixFree(mBoxEx, 8);
	matrixFree(mAttrib, 4);
	if (mTreeNode != NULL)
		delete mTreeNode;
	if (mName != NULL)
		delete []mName;
	if (mTag != NULL)
		delete []mTag;

	/* default */
	for (mChildList.moveFirst(); !mChildList.eof(); mChildList.remove());
}

void mesh::update(float **pVertex, face *pFace, long pVertCnt, long pFaceCnt, bool first, bool final)
{
	if (first)
	{
		matrixFree(mVertex, mVertCnt);
		matrixFree(mNormal, mVertCnt);
		matrixFree(mAnchor, mVertCnt);
		matrixFree(mColor, mVertCnt);
		matrixFree(mBuffer, mVertCnt);
		matrixFree(mShine, mVertCnt);
		//===================
		delete []mBulkVertex;
		delete []mBulkNormal;
		delete []mBulkAnchor;
		delete []mBulkFace;
		//===================
		delete []mFace;
	}
	if (final)
	{
		mVertex = pVertex;
		mNormal = matrixAlloc(pVertCnt, 3);
		mAnchor = matrixAlloc(pVertCnt, 2);
		mColor = matrixAlloc(pVertCnt, 3);
		mBuffer = matrixAlloc(pVertCnt, 3);
		mShine = matrixAlloc(pVertCnt, 3);
		//====================================
		mBulkVertex = new float[pVertCnt * 3];
		mBulkNormal = new float[pVertCnt * 3];
		mBulkAnchor = new float[pVertCnt * 3];
		mBulkFace = new long[pFaceCnt * 3];
		//====================================
		mFace = pFace;
		mVertCnt = pVertCnt;
		mFaceCnt = pFaceCnt;
	}
}

void mesh::setParams(long ambient, long diffuse, long specular, long emission, float shininess)
{
	mAmbient = ambient;
	mDiffuse = diffuse;
	mSpecular = specular;
	mEmission = emission;
	mShininess = shininess;
	refresh();
}

void mesh::refresh()
{
	mAttrib[0][0] = (float) colorElem(mAmbient, 'r') / 255;
	mAttrib[0][1] = (float) colorElem(mAmbient, 'g') / 255;
	mAttrib[0][2] = (float) colorElem(mAmbient, 'b') / 255;
	mAttrib[0][3] = 1;
	mAttrib[1][0] = (float) colorElem(mDiffuse, 'r') / 255;
	mAttrib[1][1] = (float) colorElem(mDiffuse, 'g') / 255;
	mAttrib[1][2] = (float) colorElem(mDiffuse, 'b') / 255;
	mAttrib[1][3] = 1;
	mAttrib[2][0] = (float) colorElem(mSpecular, 'r') / 255;
	mAttrib[2][1] = (float) colorElem(mSpecular, 'g') / 255;
	mAttrib[2][2] = (float) colorElem(mSpecular, 'b') / 255;
	mAttrib[2][3] = 1;
	mAttrib[3][0] = (float) colorElem(mEmission, 'r') / 255;
	mAttrib[3][1] = (float) colorElem(mEmission, 'g') / 255;
	mAttrib[3][2] = (float) colorElem(mEmission, 'b') / 255;
	mAttrib[3][3] = 1;
}

void mesh::setName(char *name, char *tag)
{
	if (mName != NULL)
		delete []mName;
	if (mTag != NULL)
		delete []mTag;
	mName = strCpy(name);
	mTag = strCpy(tag);
}

void mesh::setVertex(long index, float x, float y, float z)
{
	mVertex[index][0] = x;
	mVertex[index][1] = y;
	mVertex[index][2] = z;
}

void mesh::setFace(long index, long a, long b, long c)
{
	mFace[index].a = a;
	mFace[index].b = b;
	mFace[index].c = c;
}

void mesh::setColor(long color)
{
	long i;
	float *tempA;

	tempA = new float[3];
	tempA[0] = (float) colorElem(color, 'r') / 255;
	tempA[1] = (float) colorElem(color, 'g') / 255;
	tempA[2] = (float) colorElem(color, 'b') / 255;
	for (i = 0; i < mVertCnt; i++)
		vectorCopy(mColor[i], tempA);
	delete []tempA;
}

void mesh::populate()
{
	long i;
	long j;
	long index;

	index = 0;
	for (i = 0; i < mVertCnt; i++)
	{
		for (j = 0; j < 3; j++)
		{
			mBulkVertex[index + j] = mVertex[i][j];
			mBulkNormal[index + j] = mNormal[i][j];
			mBulkAnchor[index + j] = mAnchor[i][j];
		}
		index += 3;
	}
	index = 0;
	for (i = 0; i < mFaceCnt; i++)
	{
		mBulkFace[index + 0] = mFace[i].a;
		mBulkFace[index + 1] = mFace[i].b;
		mBulkFace[index + 2] = mFace[i].c;
		index += 3;
	}
}

void mesh::lock()
{
	calcNormal();
	calcBox();
	calcAnchor();
	populate();
}

void mesh::partition(long minThresh)
{
	long i;
	bool *mDirty;

	mDirty = new bool[mFaceCnt];
	for (i = 0; i < mFaceCnt; i++)
		mDirty[i] = false;
	imprint();
	mTreeNode = new treeNode(mFace, mDirty, mFaceCnt, mVertex, mBox[0], mBox[1], minThresh);
	delete []mDirty;
}

void mesh::calcNormal()
{
	long i;
	float *tempA;

	tempA = new float[3];
	for (i = 0; i < mVertCnt; i++)
		vectorNull(mNormal[i]);
	for (i = 0; i < mFaceCnt; i++)
	{
		getFaceNorm(tempA, mVertex[mFace[i].a], mVertex[mFace[i].b], mVertex[mFace[i].c]);
		vectorAdd(mNormal[mFace[i].a], mNormal[mFace[i].a], tempA);
		vectorAdd(mNormal[mFace[i].b], mNormal[mFace[i].b], tempA);
		vectorAdd(mNormal[mFace[i].c], mNormal[mFace[i].c], tempA);
	}
	for (i = 0; i < mVertCnt; i++)
		vectorNorm(mNormal[i], mNormal[i]);
	delete []tempA;
}

void mesh::calcBox()
{
	long i;
	long j;

	for (i = 0; i < 3; i++)
	{
		mBox[0][i] = BIG_NUMBER;
		mBox[1][i] = -BIG_NUMBER;
	}
	for (i = 0; i < mVertCnt; i++)
		for (j = 0; j < 3; j++)
		{
			if (mVertex[i][j] < mBox[0][j]) mBox[0][j] = mVertex[i][j];
			if (mVertex[i][j] > mBox[1][j]) mBox[1][j] = mVertex[i][j];
		}
	makeBox(mBox);
	mRadius = vectorDist(mBox[0], mBox[1]) / 2;
}

void mesh::calcAnchor()
{
	long i;
	float *tempA;

	tempA = new float[3];
	vectorSub(tempA, mBox[1], mBox[0]);
	switch (mMapDir)
	{
	case 0:
		/* back */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = 1 - (mVertex[i][0] - mBox[0][0]) / tempA[0];
			mAnchor[i][1] = (mVertex[i][1] - mBox[0][1]) / tempA[1];
		}
		break;
	case 1:
		/* front */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = (mVertex[i][0] - mBox[0][0]) / tempA[0];
			mAnchor[i][1] = (mVertex[i][1] - mBox[0][1]) / tempA[1];
		}
		break;
	case 2:
		/* left */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = 1 - (mVertex[i][2] - mBox[0][2]) / tempA[2];
			mAnchor[i][1] = (mVertex[i][1] - mBox[0][1]) / tempA[1];
		}
		break;
	case 3:
		/* right */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = (mVertex[i][2] - mBox[0][2]) / tempA[2];
			mAnchor[i][1] = (mVertex[i][1] - mBox[0][1]) / tempA[1];
		}
		break;
	case 4:
		/* top */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = 1 - (mVertex[i][0] - mBox[0][0]) / tempA[0];
			mAnchor[i][1] = (mVertex[i][2] - mBox[0][2]) / tempA[2];
		}
		break;
	case 5:
		/* bottom */
		for (i = 0; i < mVertCnt; i++)
		{
			mAnchor[i][0] = (mVertex[i][0] - mBox[0][0]) / tempA[0];
			mAnchor[i][1] = (mVertex[i][2] - mBox[0][2]) / tempA[2];
		}
		break;
	case 6:
		/* radial */
		calcRadial();
	}
	delete []tempA;
}

void mesh::calcRadial()
{
	long i;
	float *tempA;

	tempA = new float[3];
	for (i = 0; i < mVertCnt; i++)
	{
		angleFromVector(tempA, mVertex[i]);
		mAnchor[i][0] = (tempA[2] - (-PI)) / (PI * 2);
		mAnchor[i][1] = 1 - (tempA[1] - (-PI / 2)) / PI;
	}
	delete []tempA;
}

void mesh::setTexture(long *texture, long width, long height, long mapDir, bool skybox)
{
	mTexture.setParams(texture, width, height, NULL);
	mMapDir = mapDir;
	mSkyBox = skybox;
	lock();
}

void mesh::setSprite(long *sprite, long width, long height, long *mask, float scale)
{
	mSprite.setParams(sprite, width, height, mask);
	mSprite.move(0, 0, 0, scale, 0);
}

void mesh::setAxis(float *vector)
{
	int i;
	float *tempA;

	tempA = new float[3];
	vectorSub(tempA, vector, mOrigin);
	for (i = 0; i < mVertCnt; i++)
		vectorSub(mVertex[i], mVertex[i], tempA);
	vectorCopy(mOrigin, vector);
	lock();
	applyTrans();
	delete []tempA;
}

void mesh::centAxis()
{
	float *tempA;

	tempA = new float[3];
	vectorAdd(tempA, mBox[0], mBox[1]);
	vectorScale(tempA, tempA, 0.5);
	vectorAdd(tempA, tempA, mOrigin);
	setAxis(tempA);
	delete []tempA;
}

void mesh::imprint()
{
	buildTrans();
	object::applyTrans(mVertex, mVertex, mVertCnt, false, NULL);
	vectorNull(mOrigin);
	vectorNull(mAngle);
	vectorUnit(mScale);
	buildTrans();
	lock();
	applyTrans();
}

void mesh::setSpan(float *vector)
{
	long i;
	float *tempA;

	tempA = new float[3];
	vectorSub(tempA, mBox[1], mBox[0]);
	for (i = 0; i < 3; i++)
		mScale[i] = vector[i] / tempA[i];
	imprint();
	delete []tempA;
}

void mesh::setBox(float *vector)
{
	float *tempA;

	tempA = new float[3];
	vectorCopy(tempA, mOrigin);
	imprint();
	setSpan(vector);
	centAxis();
	vectorCopy(mOrigin, tempA);
	delete []tempA;
}

void mesh::align(float pos, long opCode)
{
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	vectorSub(tempA, mBox[1], mBox[0]);
	vectorScale(tempA, tempA, 0.5);
	vectorNull(tempB);
	switch (opCode)
	{
	case 0: tempB[2] = pos - mOrigin[2] - tempA[2]; break;
	case 1: tempB[2] = pos - mOrigin[2] + tempA[2]; break;
	case 2: tempB[0] = pos - mOrigin[0] - tempA[0]; break;
	case 3: tempB[0] = pos - mOrigin[0] + tempA[0]; break;
	case 4: tempB[1] = pos - mOrigin[1] - tempA[1]; break;
	case 5: tempB[1] = pos - mOrigin[1] + tempA[1];
	}
	vectorAdd(mOrigin, mOrigin, tempB);
	buildTrans();
	delete []tempA;
	delete []tempB;
}

void mesh::flipFaces()
{
	int i;
	long tempA;

	for (i = 0; i < mFaceCnt; i++)
	{
		tempA = mFace[i].b;
		mFace[i].b = mFace[i].c;
		mFace[i].c = tempA;
	}
	lock();
}

void mesh::normalize(float radius)
{
	long i;

	for (i = 0; i < mVertCnt; i++)
	{
		vectorNorm(mVertex[i], mVertex[i]);
		vectorScale(mVertex[i], mVertex[i], radius);
	}
	lock();
}

void mesh::merge(mesh *pMesh)
{
	long i;
	long pVertCnt;
	long pFaceCnt;
	float **pVertex;
	face *pFace;

	pVertCnt = mVertCnt + pMesh->mVertCnt;
	pFaceCnt = mFaceCnt + pMesh->mFaceCnt;
	pVertex = matrixAlloc(pVertCnt, 3);
	pFace = new face[pFaceCnt];
	for (i = 0; i < mVertCnt; i++)
		vectorCopy(pVertex[i], mVertex[i]);
	for (i = 0; i < mFaceCnt; i++)
		pFace[i] = mFace[i];
	for (i = 0; i < pMesh->mVertCnt; i++)
		vectorCopy(pVertex[mVertCnt + i], pMesh->mVertex[i]);
	for (i = 0; i < pMesh->mFaceCnt; i++)
	{
		pFace[mFaceCnt + i].a = pMesh->mFace[i].a + mVertCnt;
		pFace[mFaceCnt + i].b = pMesh->mFace[i].b + mVertCnt;
		pFace[mFaceCnt + i].c = pMesh->mFace[i].c + mVertCnt;
	}
	update(pVertex, pFace, pVertCnt, pFaceCnt, true, true);
	lock();
}

void mesh::tessByFace(long iters)
{
	long i;
	long j;
	float *tempA;
	long pVertCnt;
	long pFaceCnt;
	float **pVertex;
	face *pFace;
	long tempB;
	long tempC;

	tempA = new float[3];
	for (i = 0; i < iters; i++)
	{
		pVertCnt = mVertCnt + mFaceCnt;
		pFaceCnt = mFaceCnt * 3;
		pVertex = matrixAlloc(pVertCnt, 3);
		pFace = new face[pFaceCnt];
		for (j = 0; j < mVertCnt; j++)
			vectorCopy(pVertex[j], mVertex[j]);
		tempB = mVertCnt;
		tempC = 0;
		for (j = 0; j < mFaceCnt; j++)
		{
			vectorNull(tempA);
			vectorAdd(tempA, tempA, mVertex[mFace[j].a]);
			vectorAdd(tempA, tempA, mVertex[mFace[j].b]);
			vectorAdd(tempA, tempA, mVertex[mFace[j].c]);
			vectorScale(pVertex[tempB], tempA, (float) 1 / 3);
			pFace[tempC].a = mFace[j].a;
			pFace[tempC].b = mFace[j].b;
			pFace[tempC].c = tempB;
			tempC++;
			pFace[tempC].a = mFace[j].b;
			pFace[tempC].b = mFace[j].c;
			pFace[tempC].c = tempB;
			tempC++;
			pFace[tempC].a = mFace[j].c;
			pFace[tempC].b = mFace[j].a;
			pFace[tempC].c = tempB;
			tempC++;
			tempB++;
		}
		update(pVertex, pFace, pVertCnt, pFaceCnt, true, true);
	}
	lock();
	delete []tempA;
}

void mesh::tessByEdge(long iters)
{
	long i;
	long j;
	long pVertCnt;
	long pFaceCnt;
	float **pVertex;
	face *pFace;
	long tempA;
	long tempB;

	for (i = 0; i < iters; i++)
	{
		pVertCnt = mVertCnt + 3 * mFaceCnt;
		pFaceCnt = mFaceCnt * 4;
		pVertex = matrixAlloc(pVertCnt, 3);
		pFace = new face[pFaceCnt];
		for (j = 0; j < mVertCnt; j++)
			vectorCopy(pVertex[j], mVertex[j]);
		tempA = mVertCnt;
		tempB = 0;
		for (j = 0; j < mFaceCnt; j++)
		{
			vectorInterp(pVertex[tempA + 0], mVertex[mFace[j].a], mVertex[mFace[j].b], (float) 0.5);
			vectorInterp(pVertex[tempA + 1], mVertex[mFace[j].b], mVertex[mFace[j].c], (float) 0.5);
			vectorInterp(pVertex[tempA + 2], mVertex[mFace[j].c], mVertex[mFace[j].a], (float) 0.5);
			pFace[tempB].a = mFace[j].a;
			pFace[tempB].b = tempA + 0;
			pFace[tempB].c = tempA + (0 + 2) % 3;
			tempB++;
			pFace[tempB].a = mFace[j].b;
			pFace[tempB].b = tempA + 1;
			pFace[tempB].c = tempA + (1 + 2) % 3;
			tempB++;
			pFace[tempB].a = mFace[j].c;
			pFace[tempB].b = tempA + 2;
			pFace[tempB].c = tempA + (2 + 2) % 3;
			tempB++;
			pFace[tempB].a = tempA + 0;
			pFace[tempB].b = tempA + 1;
			pFace[tempB].c = tempA + 2;
			tempB++;
			tempA += 3;
		}
		update(pVertex, pFace, pVertCnt, pFaceCnt, true, true);
	}
	lock();
}

//==========//
// RADIANCE //
//==========//

void mesh::tessByColor(float maxRatio)
{
	long i;
	bool *tessFlag;
	float maxDist;
	long tessCnt;
	long pVertCnt;
	long pFaceCnt;
	float **pVertex;
	face *pFace;
	long tempA;
	long tempB;

	tessFlag = new bool[mFaceCnt];
	maxDist = (float) pow(3 * (float) pow(255, 2), 0.5) * maxRatio;
	for (i = 0; i < mFaceCnt; i++)
		tessFlag[i] = false;
	tessCnt = 0;
	for (i = 0; i < mFaceCnt; i++)
		if
			(
				vectorDist(mColor[mFace[i].a], mColor[mFace[i].b]) > maxDist ||
				vectorDist(mColor[mFace[i].b], mColor[mFace[i].c]) > maxDist ||
				vectorDist(mColor[mFace[i].c], mColor[mFace[i].a]) > maxDist
			)
		{
			tessFlag[i] = true;
			tessCnt++;
		}
	if (tessCnt != 0)
	{
		pVertCnt = mVertCnt + 3 * tessCnt;
		pFaceCnt = tessCnt * 4;
		pVertex = matrixAlloc(pVertCnt, 3);
		pFace = new face[pFaceCnt];
		for (i = 0; i < mVertCnt; i++)
			vectorCopy(pVertex[i], mVertex[i]);
		tempA = mVertCnt;
		tempB = 0;
		for (i = 0; i < mFaceCnt; i++)
		{
			if (tessFlag[i])
			{
				vectorInterp(pVertex[tempA + 0], mVertex[mFace[i].a], mVertex[mFace[i].b], (float) 0.5);
				vectorInterp(pVertex[tempA + 1], mVertex[mFace[i].b], mVertex[mFace[i].c], (float) 0.5);
				vectorInterp(pVertex[tempA + 2], mVertex[mFace[i].c], mVertex[mFace[i].a], (float) 0.5);
				pFace[tempB].a = mFace[i].a;
				pFace[tempB].b = tempA + 0;
				pFace[tempB].c = tempA + (0 + 2) % 3;
				tempB++;
				pFace[tempB].a = mFace[i].b;
				pFace[tempB].b = tempA + 1;
				pFace[tempB].c = tempA + (1 + 2) % 3;
				tempB++;
				pFace[tempB].a = mFace[i].c;
				pFace[tempB].b = tempA + 2;
				pFace[tempB].c = tempA + (2 + 2) % 3;
				tempB++;
				pFace[tempB].a = tempA + 0;
				pFace[tempB].b = tempA + 1;
				pFace[tempB].c = tempA + 2;
				tempB++;
				tempA += 3;
			}
			else
			{
				pFace[tempB] = mFace[i];
				tempB++;
			}
		}
		update(pVertex, pFace, pVertCnt, pFaceCnt, true, true);
		lock();
	}
	delete []tessFlag;
}

void mesh::applyTrans()
{
	object::applyTrans(mBoxEx, mBox, 8, false, NULL);
}