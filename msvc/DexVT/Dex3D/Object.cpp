#include "Object.h"

Object::Object()
{
	//=====================================
	mParent = NULL;
	//=====================================
	mMinCapAngle = UNIT_VECTOR * -BIG_NUMBER;
	mMaxCapAngle = UNIT_VECTOR * BIG_NUMBER;
	mMaskOrigin = UNIT_VECTOR;
	mMaskAngle = UNIT_VECTOR;
	mMaskScale = UNIT_VECTOR;
	//=====================================
	this->reset();
}

Object::~Object()
{
	this->unlink();
	this->link(NULL);
}

//=============================================================================

void Object::reset()
{
	mOrigin = NULL_VECTOR;
	mAngle = NULL_VECTOR;
	mScale = UNIT_VECTOR;
	this->buildTrans();
}

void Object::modify(TRANS::TRANS trans, Vector &v)
{
	switch (trans)
	{
		//=========================================================
		case TRANS::ORIGIN: mOrigin.mask(mMaskOrigin, v); break;
		case TRANS::ANGLE:
			mAngle.mask(mMaskAngle, v)
				.vec_limit(mMinCapAngle, mMaxCapAngle)
				.vec_wrap(MIN_WRAPANGLE, MAX_WRAPANGLE);
			break;
		case TRANS::SCALE: mScale.mask(mMaskScale, v); break;
		case TRANS::LOCK_ORIGIN: mMaskOrigin = UNIT_VECTOR - v; break;
		case TRANS::LOCK_ANGLE: mMaskAngle = UNIT_VECTOR - v; break;
		case TRANS::LOCK_SCALE: mMaskScale = UNIT_VECTOR - v; break;
		case TRANS::MIN_ANGLE: mMinCapAngle = v; break;
		case TRANS::MAX_ANGLE: mMaxCapAngle = v; break;
		//=========================================================
		case TRANS::LOCAL_ORIGIN:
			this->transArb(TranslateTrans(v), true);
			break;
		case TRANS::LOCAL_ANGLE:
			this->transArb(RotateTrans(v), true);
		//=========================================================
	}
	switch (trans)
	{
		//=========================================================
		case TRANS::ORIGIN:
		case TRANS::ANGLE:
		case TRANS::SCALE:
			this->buildTrans();
			return;
		case TRANS::LOCK_ORIGIN: this->modify(TRANS::ORIGIN, mOrigin); return;
		case TRANS::LOCK_ANGLE: this->modify(TRANS::ANGLE, mAngle); return;
		case TRANS::LOCK_SCALE: this->modify(TRANS::SCALE, mScale); return;
		case TRANS::MIN_ANGLE:
		case TRANS::MAX_ANGLE:
			this->modify(TRANS::ANGLE, mAngle);
			return;
		//=========================================================
		case TRANS::LOCAL_ORIGIN:
		case TRANS::LOCAL_ANGLE:
			return;
		//=========================================================
	}
	throw Exception("bad vector");
}

Vector &Object::query(TRANS::TRANS trans)
{
	switch (trans)
	{
		//=========================================================
		case TRANS::ORIGIN: return mOrigin;
		case TRANS::ANGLE: return mAngle;
		case TRANS::SCALE: return mScale;
		case TRANS::LOCK_ORIGIN: return mMaskOrigin;
		case TRANS::LOCK_ANGLE: return mMaskAngle;
		case TRANS::LOCK_SCALE: return mMaskScale;
		case TRANS::MIN_ANGLE: return mMinCapAngle;
		case TRANS::MAX_ANGLE: return mMaxCapAngle;
		//=========================================================
		case TRANS::ABS_ORIGIN: return mAbsOrigin;
		case TRANS::ABS_FRONT: return mAbsFront;
		case TRANS::ABS_LEFT: return mAbsLeft;
		case TRANS::ABS_TOP: return mAbsTop;
		case TRANS::ABS_DIR_FWD: return mTemp = mAbsFront - mAbsOrigin;
		case TRANS::ABS_DIR_LEFT: return mTemp = mAbsLeft - mAbsOrigin;
		case TRANS::ABS_DIR_UP: return mTemp = mAbsTop - mAbsOrigin;
		//=========================================================
	}
	throw Exception("bad vector");
}

//=============================================================================

void Object::pointAt(Vector &v)
{
	this->buildTrans();
	Vector diff = v - mAbsOrigin;
	Vector angle = diff.toAngle();
	if ((float) fabs(diff.x) < EPSILON && (float) fabs(diff.z) < EPSILON)
		angle.yaw = mAngle.yaw; // undefined case, use previous yaw
	this->modify(TRANS::ANGLE, angle);
}

void Object::transArb(Matrix &trans, bool local)
{
	this->buildTrans();
	Matrix newTrans = local ? trans * mTrans : mTrans * trans;
	Vector absOrigin = NULL_VECTOR * newTrans;
	Vector absFront = FWD_VECTOR * newTrans;
	Vector absLeft = LEFT_VECTOR * newTrans;
	Vector absDirLeft = absLeft - absOrigin;
	//=========================================================
	Vector prevDirUp = this->query(TRANS::ABS_DIR_UP);
	//=========================================================
	this->modify(TRANS::ORIGIN, absOrigin);
	this->pointAt(absFront);
	Vector flatDirLeft = this->query(TRANS::ABS_DIR_LEFT);
	this->modify(
		TRANS::ANGLE,
		Vector(
			acosEx(flatDirLeft.angle(absDirLeft)) * sgn(absDirLeft.y),
			mAngle.pitch,
			mAngle.yaw
			)
		);
	//=========================================================
	Vector dirUp = this->query(TRANS::ABS_DIR_UP);
	//=========================================================
	if (dirUp.angle(prevDirUp) < 0)
		this->modify(
			TRANS::ANGLE,
			Vector(
				mAngle.roll + toRad(180),
				mAngle.pitch,
				mAngle.yaw
				)
			);
}

void Object::rotArb(Vector &pos, Vector &dir, float angle)
{
	this->buildTrans();
	Matrix transPivTrans = TranslateTrans(dir.rayPointNearest(pos, mAbsOrigin));
	Matrix transPivRot = RotateTrans(dir.toAngle());
	Matrix trans =
		!transPivTrans * !transPivRot * RotateTrans(AXIS::Z, angle) *
		transPivRot * transPivTrans;
	this->transArb(trans, false);
}

//=============================================================================

void Object::link(Object *parent)
{
	if (mParent)
		mParent->mChildList.remove(this);
	if (parent)
		listAdd(parent->mChildList, this);
	mParent = parent;
	this->buildTrans();
}

void Object::unlink()
{
	for (int i = 0; i < mChildList.size(); i++)
		mChildList[i]->link(NULL);
}

//=============================================================================

void Object::buildTrans()
{
	mTrans = ComboTrans(mOrigin, mAngle, mScale);
	if (mParent)
		mTrans *= mParent->mTrans;
	//=====================================
	mAbsOrigin = NULL_VECTOR * mTrans;
	mAbsFront = FWD_VECTOR * mTrans;
	mAbsLeft = LEFT_VECTOR * mTrans;
	mAbsTop = UP_VECTOR * mTrans;
	//=====================================
	for (int i = 0; i < mChildList.size(); i++)
		mChildList[i]->buildTrans();
}

void Object::applyTrans(Vector *r, Vector *v, int n)
{
	for (int i = 0; i < n; i++)
		r[i] = v[i] * mTrans;
}