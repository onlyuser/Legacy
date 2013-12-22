#include "PhysObj.h"

PhysObj::PhysObj()
{
	//=====================================
	mMaxSpdOrigin = UNIT_VECTOR * BIG_NUMBER;
	mMaxSpdAngle = UNIT_VECTOR * toRad(180);
	mLocVelOrigin = NULL_VECTOR;
	mArbPivotDir = UP_VECTOR;
	mArbVelAngle = 0;
	//=====================================
	this->reset();
}

PhysObj::~PhysObj()
{
}

//=============================================================================

void PhysObj::reset()
{
	mVelOrigin = NULL_VECTOR;
	mVelAngle = NULL_VECTOR;
	mAccOrigin = NULL_VECTOR;
	mAccAngle = NULL_VECTOR;
	//=====================================
	mMass = 0;
	mInertia = 0;
	mBounce = 1;
	mFriction = 0;
	//=====================================
	Object::reset();
}

void PhysObj::modify(TRANS::TRANS trans, Vector &v)
{
	switch (trans)
	{
		//=========================================================
		case TRANS::VEL_ORIGIN:
			(mVelOrigin = v).vec_limit(-mMaxSpdOrigin, mMaxSpdOrigin);
			break;
		case TRANS::VEL_ANGLE:
			(mVelAngle = v).vec_limit(-mMaxSpdAngle, mMaxSpdAngle);
			break;
		case TRANS::ACC_ORIGIN: mAccOrigin = v; break;
		case TRANS::ACC_ANGLE: mAccAngle = v; break;
		//=========================================================
		case TRANS::MAX_SPD_ORIGIN: mMaxSpdOrigin = v; break;
		case TRANS::MAX_SPD_ANGLE: mMaxSpdAngle = v; break;
		//=========================================================
		case TRANS::LOC_VEL_ORIGIN: mLocVelOrigin = v; break;
		//=========================================================
		case TRANS::ARB_PIVOT_DIR: mArbPivotDir = v; break;
		case TRANS::ARB_VEL_ANGLE: mArbVelAngle = v.roll; break;
		//=========================================================
		default:
			Object::modify(trans, v);
	}
}

Vector &PhysObj::query(TRANS::TRANS trans)
{
	switch (trans)
	{
		//=========================================================
		case TRANS::VEL_ORIGIN: return mVelOrigin;
		case TRANS::VEL_ANGLE: return mVelAngle;
		case TRANS::ACC_ORIGIN: return mAccOrigin;
		case TRANS::ACC_ANGLE: return mAccAngle;
		//=========================================================
		case TRANS::MAX_SPD_ORIGIN: return mMaxSpdOrigin;
		case TRANS::MAX_SPD_ANGLE: return mMaxSpdAngle;
		//=========================================================
		case TRANS::LOC_VEL_ORIGIN: return mLocVelOrigin;
		//=========================================================
		case TRANS::ARB_PIVOT_DIR: return mArbPivotDir;
		case TRANS::ARB_VEL_ANGLE: return mTemp = Vector(mArbVelAngle, 0, 0);
		//=========================================================
		default:
			return Object::query(trans);
	}
}

//=============================================================================

Vector PhysObj::calcVelTangent(Vector &contact)
{
	//=========================================================
	Vector origin = mOrigin;
	Vector angle = mAngle;
	this->rotArb(mAbsOrigin, mArbPivotDir, mArbVelAngle);
	Matrix prevTrans = mTrans;
	this->modify(TRANS::ORIGIN, origin);
	this->modify(TRANS::ANGLE, angle);
	Matrix trans = !prevTrans * mTrans;
	//=========================================================
	return mVelOrigin + contact * trans - contact;
}

void PhysObj::applyImpulse(float mass, float inertia, Vector &velocity, Vector &contact, Vector &normal)
{
	Vector radius = contact - mAbsOrigin;
	this->applyImpulse(
		mass, inertia, 1, 0,
		mVelOrigin, velocity,
		mVelOrigin.ortho(radius), velocity.ortho(radius),
		1, 1,
		contact, normal
		);
}

void PhysObj::applyImpulse(float mass, float inertia, float bounce, float friction, Vector &v1, Vector &v2, Vector &t1, Vector &t2, float r1, float r2, Vector &contact, Vector &normal)
{
	if ((v2 - v1).angle(normal) > 0)
		return;
	//=========================================================
	float m1 = mMass;
	float m2 = mass;
	Vector normV1 = v1.project(normal);
	Vector normV2 = v2.project(normal);
	Vector slideV1 = v1 - normV1;
	float sumMass = m1 + m2;
	Vector normV3 = normV1 * (m1 - m2) / sumMass + normV2 * (2 * m2) / sumMass;
	//=========================================================
	float i1 = mInertia;
	float i2 = inertia;
	Vector projFrict = t1.normal() + t2.normal(); // this ain't right..
	Vector normFrict = projFrict * normal;
	Vector normT1 = t1.project(normFrict);
	Vector normT2 = t2.project(normFrict);
	Vector slideT1 = t1.project(projFrict);
	float sumInert = i1 + i2;
	Vector normT3 =
		(
			(normT1 / r1) * (i1 - i2) / sumInert +
			(normT2 / r2) * (2 * i2) / sumInert
		) * r1;
	//=========================================================
	Vector v3 = normV3 * mBounce * bounce + slideV1 * (1 - mFriction * friction);
	Vector t3 = normT3 * mBounce * bounce + slideT1 * (1 - mFriction * friction);
	//=========================================================
	Vector radius = contact - mAbsOrigin;
	Vector tangent = t3.ortho(radius);
	Vector surplus = t3 - tangent;
	Vector pivotDir = -(tangent.normal() * radius.normal()).normal();
	float newRotSpd = (float) atan(tangent.mod() / radius.mod());
	//=========================================================
	this->modify(TRANS::VEL_ORIGIN, v3 + surplus);
	this->modify(TRANS::ARB_PIVOT_DIR, pivotDir);
	if (pivotDir != NULL_VECTOR)
		this->modify(TRANS::ARB_VEL_ANGLE, Vector(newRotSpd, 0, 0));
	else
		this->modify(TRANS::ARB_VEL_ANGLE, NULL_VECTOR);
	//=========================================================
}

//=============================================================================

void PhysObj::update(float rate)
{
	if (rate > 0)
	{
		if (mArbVelAngle)
			this->rotArb(mAbsOrigin, mArbPivotDir, mArbVelAngle);
		if (mLocVelOrigin != NULL_VECTOR)
			this->modify(TRANS::LOCAL_ORIGIN, mLocVelOrigin);
	}
	this->modify(TRANS::VEL_ORIGIN, mVelOrigin + mAccOrigin * rate);
	this->modify(TRANS::VEL_ANGLE, mVelAngle + mAccAngle * rate);
	mOrigin += mVelOrigin * rate;
	this->modify(TRANS::ANGLE, mAngle + mVelAngle * rate);
}