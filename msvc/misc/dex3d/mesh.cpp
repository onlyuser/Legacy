#include "mesh.h"

mesh::mesh(long vertCount, long faceCount)
{
	/* data */
	mVertex = matrixAlloc(vertCount, 3);
	mFace = new face[faceCount];

	/* misc */
	mVertCount = vertCount;
	mFaceCount = faceCount;
	mBase = 0;
	mVisible = true;
}

mesh::~mesh()
{
	/* data */
	matrixFree(mVertex, mVertCount);
	delete []mFace;
}

void mesh::setAxis(float *axis)
{
	int i;
	int j;
	float *delta;

	delta = vectorSubtract(axis, mOrigin, 3);
	for (i = 0; i < mVertCount; i++)
		for (j = 0; j < 3; j++)
			mVertex[i][j] -= delta[j];
	for (i = 0; i < 3; i++)
		mOrigin[i] = axis[i];
	delete []delta;
}

void mesh::centerAxis()
{
	int i;
	int j;
	float *max;
	float *min;
	float *center;

	max = new float[3];
	min = new float[3];
	for (i = 0; i < 3; i++)
	{
		max[i] = mVertex[0][i];
		min[i] = mVertex[0][i];
	}
	for (i = 1; i < mVertCount; i++)
	{
		for (j = 0; j < 3; j++)
		{
			if (mVertex[i][j] > max[j])
				max[j] = mVertex[i][j];
			if (mVertex[i][j] < min[j])
				min[j] = mVertex[i][j];
		}
	}
	center = vectorAdd(max, min, 3);
	center = vectorUpdate(center, vectorScale(center, 3, 0.5));
	center = vectorUpdate(center, vectorAdd(center, mOrigin, 3));
	setAxis(center);
	delete []center;
	delete []max;
	delete []min;
}

float **mesh::applyTrans()
{
	float **result;

	result = object::applyTrans(mVertex, mVertCount, true);
	return result;
}

void mesh::buildTrans()
{
	object::buildTransEx(false);
}
