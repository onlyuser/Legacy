#include "object.h"

object::object()
{
	/* data */
	mTrans = matrixAlloc();
	mOrigin = new float[3];
	mOriginEx = new float[3];
	mAngle = new float[3];
	mScale = new float[3];
	matrixIdent(mTrans);
	vectorNull(mOrigin);
	vectorNull(mAngle);
	vectorUnit(mScale);

	/* physics */
	mPosVel = new float[3];
	mAngVel = new float[3];
	vectorNull(mPosVel);
	vectorNull(mAngVel);
	mPosAcc = new float[3];
	mAngAcc = new float[3];
	vectorNull(mPosAcc);
	vectorNull(mAngAcc);
	mMovSpdMax = BIG_NUMBER;
	mRotSpdMax = BIG_NUMBER;
	mStyle = 0;
	mCollide = true;
	mTicks = -1;
	mTarget = NULL;

	/* attributes */
	mParent = NULL;
	mChanged = true;
}

object::~object()
{
	/* data */
	matrixFree(mTrans);
	delete []mOrigin;
	delete []mOriginEx;
	delete []mAngle;
	delete []mScale;

	/* physics */
	delete []mPosVel;
	delete []mAngVel;
	delete []mPosAcc;
	delete []mAngAcc;
	if (mTarget != NULL)
		delete []mTarget;
}

void object::move(long opCode, float *vector)
{
	switch (opCode)
	{
	case 0: vectorCopy(mOrigin, vector); break;
	case 1: vectorCopy(mAngle, vector); break;
	case 2: vectorCopy(mScale, vector); break;
	case 3: vectorCopy(mPosVel, vector); break;
	case 4: vectorCopy(mAngVel, vector); break;
	case 5: vectorCopy(mPosAcc, vector); break;
	case 6: vectorCopy(mAngAcc, vector);
	}
	buildTrans();
}

void object::getVector(long opCode, float *vector)
{
	switch (opCode)
	{
	case 0: vectorCopy(vector, mOrigin); break;
	case 1: vectorCopy(vector, mAngle); break;
	case 2: vectorCopy(vector, mScale); break;
	case 3: vectorCopy(vector, mPosVel); break;
	case 4: vectorCopy(vector, mAngVel); break;
	case 5: vectorCopy(vector, mPosAcc); break;
	case 6: vectorCopy(vector, mAngAcc);
	}
}

void object::setMotion(long style, bool collide)
{
	mStyle = style;
	mCollide = collide;
}

void object::goFwd(float dist)
{
	float *tempA;

	tempA = new float[3];
	vectorFromAngle(tempA, mAngle);
	vectorScale(tempA, tempA, dist);
	vectorAdd(mOrigin, mOrigin, tempA);
	delete []tempA;
}

void object::setMaxSpeed(float movSpd, float rotSpd)
{
	mMovSpdMax = movSpd;
	mRotSpdMax = rotSpd;
}

void object::setLife(long ticks)
{
	mTicks = ticks;
}

void object::update()
{
	long i;
	float *tempA;

	/* waypoint */
	if (mTarget != NULL)
	{
		tempA = new float[3];
		vectorSub(tempA, mTarget, mOrigin);
		angleFromVector(tempA, tempA);
		vectorWrap(tempA, tempA, 0, PI * 2);
		vectorSub(tempA, tempA, mAngle);
		for (i = 0; i < 3; i++)
		{
			if (fabs(tempA[i]) > PI)
				tempA[i] *= -1;
			if (tempA[i] != 0)
				mAngVel[i] = (float) fabs(mAngVel[i]) * sgn(tempA[i]);
		}
		delete []tempA;
	}

	/* velocity */
	if (vectorDirty(mPosAcc) || vectorDirty(mAngAcc))
	{
		vectorAdd(mPosVel, mPosVel, mPosAcc);
		vectorAdd(mAngVel, mAngVel, mAngAcc);
		vectorLock(mPosVel, mPosVel, -mMovSpdMax, mMovSpdMax);
		vectorLock(mAngVel, mAngVel, -mRotSpdMax, mRotSpdMax);
	}

	/* position */
	if (vectorDirty(mPosVel) || vectorDirty(mAngVel))
	{
		if (mStyle == 0)
			vectorAdd(mOrigin, mOrigin, mPosVel);
		else
			goFwd(mPosVel[2]);
		vectorAdd(mAngle, mAngle, mAngVel);
		vectorLock(mOrigin, mOrigin, -BIG_NUMBER, BIG_NUMBER);
		vectorWrap(mAngle, mAngle, 0, PI * 2);
		vectorLock(mScale, mScale, 0, BIG_NUMBER);
		buildTrans();
	}

	/* particle */
	if (mTicks > 0)
		mTicks--;
}

void object::applyHier()
{
	object *pObj;

	for (mChildList.moveFirst(); !mChildList.eof(); mChildList.moveNext())
	{
		pObj = mChildList.getData();
		pObj->buildTrans();
		pObj->applyHier();
	}
}

void object::link(object *pObj)
{
	object *pObjEx;

	pObj->mChildList.add(this);
	mParent = pObj;
	for (pObjEx = this; pObjEx->mParent != NULL; pObjEx = pObjEx->mParent)
		pObjEx->mParent->mChanged = false;
	buildTrans();
	applyHier();
}

void object::unlink()
{
	if (mParent != NULL)
		if (mParent->mChildList.find(this))
		{
			mParent->mChildList.remove();
			mParent = NULL;
			buildTrans();
			applyHier();
		}
}

void object::unlinkAll()
{
	object *pObj;

	unlink();
	for (mChildList.moveFirst(); !mChildList.eof(); mChildList.moveNext())
	{
		pObj = mChildList.getData();
		pObj->unlink();
	}
}

void object::pointAt(float *vector)
{
	float *tempA;

	tempA = new float[3];
	vectorSub(tempA, vector, mOrigin);
	angleFromVector(mAngle, tempA);
	buildTrans();
	delete []tempA;
}

void object::buildTrans()
{
	matrixTransEx(mTrans, mOrigin, mAngle, mScale);
	mChanged = true;
	if (mParent != NULL)
	{
		if (!mParent->mChanged)
			mParent->buildTrans();
		matrixMult(mTrans, mTrans, mParent->mTrans);
	}
}

void object::applyTrans(float **result, float **vertex, long vertCnt, bool doProj, float **proj)
{
	long i;
	float **matrixA;
	float *tempA;

	if (doProj)
	{
		matrixA = matrixAlloc();
		tempA = new float[4];
		matrixMult(matrixA, mTrans, proj);
		for (i = 0; i < vertCnt; i++)
		{
			vectorMatrixMultEx(tempA, vertex[i], matrixA);
			result[i][0] = tempA[0] / tempA[3];
			result[i][1] = tempA[1] / tempA[3];
			result[i][2] = tempA[2] / tempA[3];
		}
		matrixFree(matrixA);
		delete []tempA;
	}
	else
		for (i = 0; i < vertCnt; i++)
			vectorMatrixMult(result[i], vertex[i], mTrans);
}