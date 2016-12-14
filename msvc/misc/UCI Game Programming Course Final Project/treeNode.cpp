#include "treeNode.h"

treeNode::treeNode(face *pFace, bool *dirty, long faceCnt, float **vertex, float *min, float *max, long minThresh)
{
	long i;
	long j;
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	mBox = matrixAlloc(8, 3);
	mFace = new face *[faceCnt];
	mFaceCnt = 0;
	for (i = 0; i < faceCnt; i++)
		if
			(
				vectorBounded(vertex[pFace[i].a], min, max) ||
				vectorBounded(vertex[pFace[i].b], min, max) ||
				vectorBounded(vertex[pFace[i].c], min, max)
			)
				mFaceCnt++;
	vectorSub(tempA, max, min);
	vectorScale(tempA, tempA, 0.5);
	for (i = 0; i < 2; i++)
	{
		vectorCopy(mBox[0], min);
		if (i == 0)
			vectorAdd(mBox[1], mBox[0], tempA);
		else
			vectorCopy(mBox[1], max);
		makeBox(mBox);
		if (i == 0)
		{
			if (mFaceCnt >= minThresh)
			{
				mChild = new treeNode *[8];
				for (j = 0; j < 8; j++)
				{
					vectorAdd(tempB, mBox[j], tempA);
					mChild[j] = new treeNode(pFace, dirty, faceCnt, vertex, mBox[j], tempB, minThresh);
				}
				mLeaf = false;
			}
			else
				mLeaf = true;
		}
	}
	if (mLeaf)
	{
		mFaceCnt = 0;
		for (i = 0; i < faceCnt; i++)
			if
				(
					vectorBounded(vertex[pFace[i].a], min, max) ||
					vectorBounded(vertex[pFace[i].b], min, max) ||
					vectorBounded(vertex[pFace[i].c], min, max)
				)
					if (!dirty[i])
					{
						mFace[mFaceCnt] = &(pFace[i]);
						mFaceCnt++;
						dirty[i] = true;
					}
	}
	mInFrust = false;
	delete []tempA;
	delete []tempB;
}

treeNode::~treeNode()
{
	long i;

	matrixFree(mBox, 8);
	delete []mFace;
	if (!mLeaf)
	{
		for (i = 0; i < 8; i++)
			delete mChild[i];
		delete []mChild;
	}
}