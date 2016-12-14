#include "camera.h"

camera::camera(long width, long height)
{
	/* data */
	mTransEx = matrixAlloc();
	mProj = matrixAlloc();
	mTarget = new float[3];
	vectorNull(mTarget);
	mFrust = matrixAlloc(8, 3);
	mFrustEx = matrixAlloc(8, 3);
	mNorm = matrixAlloc(4, 3);
	mNormEx = matrixAlloc(4, 3);

	/* attributes */
	mWidth = width;
	mHeight = height;
	setParams(toRad(90), (float) width / height, (float) 1, 10000, 50);
}

camera::~camera()
{
	/* data */
	matrixFree(mTransEx);
	matrixFree(mProj);
	delete []mTarget;
	matrixFree(mFrust, 8);
	matrixFree(mFrustEx, 8);
	matrixFree(mNorm, 4);
	matrixFree(mNormEx, 4);
}

void camera::setParams(float fov, float aspect, float pNear, float pFar, float range)
{
	mFov = fov;
	mAspect = aspect;
	mNear = pNear;
	mFar = pFar;
	mRange = range;
	calcFrust();
	mChanged = true;
}

void camera::calcFrust()
{
	long i;

	mFrust[0][2] = mNear;
	mFrust[1][2] = mFar;
	mFrust[1][1] = mFar * (float) tan(mFov / 2);
	mFrust[1][0] = mFrust[1][1] * mAspect;
	mFrust[0][1] = mFrust[1][1] * -1;
	mFrust[0][0] = mFrust[1][0] * -1;
	makeBox(mFrust);
	for (i = 0; i < 8; i++)
	{
		mFrust[i][0] *= (mFrust[i][2] / mFrust[1][2]);
		mFrust[i][1] *= (mFrust[i][2] / mFrust[1][2]);
	}
	/* left */
	mNorm[0][0] = (float) cos(mFov / 2 * mAspect);
	mNorm[0][1] = 0;
	mNorm[0][2] = (float) -sin(mFov / 2 * mAspect);
	/* right */
	mNorm[1][0] = -mNorm[0][0];
	mNorm[1][1] = mNorm[0][1];
	mNorm[1][2] = mNorm[0][2];
	/* top */
	mNorm[2][0] = 0;
	mNorm[2][1] = (float) cos(mFov / 2);
	mNorm[2][2] = (float) -sin(mFov / 2);
	/* bottom */
	mNorm[3][0] = mNorm[2][0];
	mNorm[3][1] = -mNorm[2][1];
	mNorm[3][2] = mNorm[2][2];
}

bool camera::canSee(float **box)
{
	int i;
	bool result;

	result = false;
	for (i = 0; i < 8; i++)
		if
			(
				!normSide(box[i], mOrigin, mNormEx[0]) &&
				!normSide(box[i], mOrigin, mNormEx[1]) &&
				!normSide(box[i], mOrigin, mNormEx[2]) &&
				!normSide(box[i], mOrigin, mNormEx[3])
			)
		{
			result = true;
			i = 8;
		}
	return result;
}

void camera::orbit(float *origin, float radius, float lngAngle, float latAngle)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = 0;
	tempA[1] = latAngle;
	tempA[2] = lngAngle;
	vectorFromAngle(tempA, tempA);
	vectorScale(tempA, tempA, -radius);
	vectorAdd(mOrigin, origin, tempA);
	mAngle[0] = 0;
	mAngle[1] = latAngle;
	mAngle[2] = lngAngle;
	buildTrans();
	delete []tempA;
}

void camera::lookAt(float *vector)
{
	object::pointAt(vector);
	buildTrans();
}

void camera::setVector(float *origin, float *vector)
{
	float *tempA;

	tempA = new float[3];
	move(MOV_POS, origin);
	vectorAdd(tempA, origin, vector);
	lookAt(tempA);
	delete []tempA;
}

void camera::setBank(float offset)
{
	mAngle[0] = offset;
	mChanged = true;
}

void camera::buildTrans()
{
	float *tempA;
	float *tempB;

	tempA = new float[3];
	tempB = new float[3];
	vectorNull(tempA);
	vectorUnit(tempB);
	matrixTransEx(mTrans, tempA, mAngle, tempB);
	matrixTrans(mTransEx, mOrigin);
	matrixMult(mTransEx, mTrans, mTransEx);
	matrixInv(mTransEx, mTransEx);
	matrixProj(mProj, mWidth, mHeight, mAspect, mFov, mNear, mFar, true, 0);
	matrixMult(mProj, mTransEx, mProj);
	vectorFromAngle(tempA, mAngle);
	vectorAdd(mTarget, mOrigin, tempA);
	mChanged = true;
	delete []tempA;
	delete []tempB;
}

void camera::applyTrans()
{
	long i;

	object::applyTrans(mFrustEx, mFrust, 8, false, NULL);
	for (i = 0; i < 4; i++)
		vectorMatrixMult(mNormEx[i], mNorm[i], mTrans);
}