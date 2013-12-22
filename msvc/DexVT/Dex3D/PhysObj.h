#ifndef H_PHYSOBJ
#define H_PHYSOBJ

#include "Object.h"

class PhysObj : public Object
{
private:
	Vector mVelOrigin, mVelAngle, mAccOrigin, mAccAngle;
	Vector mMaxSpdOrigin, mMaxSpdAngle;
	Vector mLocVelOrigin;
	Vector mArbPivotDir;
	float mArbVelAngle;
public:
	float mMass;
	float mInertia;
	float mBounce;
	float mFriction;

	//=============================================================================
	PhysObj();
	~PhysObj();
	//=============================================================================
	void reset();
	void modify(TRANS::TRANS trans, Vector &v);
	Vector &query(TRANS::TRANS trans);
	//=============================================================================
	Vector calcVelTangent(Vector &v);
	void applyImpulse(float mass, float inertia, Vector &velocity, Vector &contact, Vector &normal);
	void applyImpulse(float mass, float inertia, float bounce, float friction, Vector &v1, Vector &v2, Vector &t1, Vector &t2, float r1, float r2, Vector &contact, Vector &normal);
	//=============================================================================
	void update(float rate);
	//=============================================================================
};

#endif