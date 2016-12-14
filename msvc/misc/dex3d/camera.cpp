#include "camera.h"

camera::camera()
{
	/* data */
	mView = matrixIdent(4);

	/* attributes */
	mFov = toRadian(60);
	mNear = 1;
	mFar = 1200;
	mPerspect = false;
	mZoom = 1;
	mReflect = true;
	mFog = true;

	/* misc */
	mWidth = 640;
	mHeight = 480;
}

camera::~camera()
{
	/* data */
	matrixFree(mView, 4);
}

void camera::setSize(long width, long height)
{
	mWidth = width;
	mHeight = height;
	buildTrans();
}

void camera::orbit(float *origin, float radius, float lngAngle, float latAngle)
{
	int i;
	float *tempA;

	tempA = vectorNull(4);
	tempA[1] = latAngle;
	tempA[2] = -lngAngle;
	tempA[3] = 1;
	tempA = vectorUpdate(tempA, vectorFromAngles(tempA));
	tempA = vectorUpdate(tempA, vectorScale(tempA, 3, -radius));
	tempA = vectorUpdate(tempA, vectorAdd(origin, tempA, 3));
	for (i = 0; i < 3; i++)
		mOrigin[i] = tempA[i];
	mAngle[0] = 0;
	mAngle[1] = latAngle;
	mAngle[2] = -lngAngle;
	buildTrans();
	delete []tempA;
}

float **camera::project(float **vertex, long count)
{
	int i;
	int j;
	float **result;

	result = new float *[count];
	for (i = 0; i < count; i++)
	{
		result[i] = vectorMatrixMult(vertex[i], mView, 4);
		if (result[i][3] != 0)
			for (j = 0; j < 3; j++)
				result[i][j] /= result[i][3];
	}
	return result;
}

float **camera::applyTrans(float **vertex, long count)
{
	float **result;

	result = object::applyTrans(vertex, count, false);
	return result;
}

void camera::buildTrans()
{
	object::buildTransEx(true);
	mView =
		matrixUpdate(
			mView,
			matrixProjection(mWidth, mHeight, (float) 1.5, mFov, mNear, mFar, mPerspect, mZoom),
			4
		);
}
