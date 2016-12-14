#include "object.h"

object::object()
{
	mTransform = matrixIdent(4);
	mOrigin = vectorNull(3);
	mAngle = vectorNull(3);
	mScale = vectorUnit(3);

	mParent = NULL;
	mChanged = false;
}

object::~object()
{
	matrixFree(mTransform, 4);
	delete []mOrigin;
	delete []mAngle;
	delete []mScale;
}

float **object::applyTrans(float **vertex, long count, bool padIdent)
{
	int i;
	int j;
	float **result;
	float *tempA;

	result = new float *[count];
	tempA = new float[4];
	tempA[3] = 1;
	for (i = 0; i < count; i++)
	{
		if (padIdent)
		{
			for (j = 0; j < 3; j++)
				tempA[j] = vertex[i][j];
			result[i] = vectorMatrixMult(tempA, mTransform, 4);
		}
		else
			result[i] = vectorMatrixMult(vertex[i], mTransform, 4);
	}
	delete []tempA;
	return result;
}

void object::buildTransEx(bool invert)
{
	mTransform = matrixUpdate(mTransform, matrixTransform(mScale, mOrigin, mAngle), 4);
	if (invert)
		mTransform = matrixUpdate(mTransform, matrixInv(mTransform, 4), 4);
	if (mParent != NULL)
		mTransform = matrixUpdate(mTransform, matrixMult(mTransform, mParent->mTransform, 4), 4);
	mChanged = true;
}
