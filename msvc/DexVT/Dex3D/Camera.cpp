#include "Camera.h"

Camera::Camera()
{
	//=====================================
	mNear = 1;
	mFar = BIG_NUMBER;
	mTanHalf = 1;
	//=====================================
	this->resize(1, 1);
	this->set(1, 1000, toRad(90));
}

Camera::~Camera()
{
}

//=============================================================================

void Camera::resize(float width, float height)
{
	mWidth = width;
	mHeight = height;
	mAspect = width / height;
	this->buildProj();
}

void Camera::set(float pNear, float pFar, float fov)
{
	mNear = pNear;
	mFar = pFar;
	mTanHalf = tan(fov * 0.5f);
	this->buildProj();
	//=========================================================
	mFrustObj[0] = Vector(-1, 0, mTanHalf).normal(); // left
	mFrustObj[1] = Vector(1, 0, mTanHalf).normal(); // right
	mFrustObj[2] = Vector(0, -1, mTanHalf).normal(); // top
	mFrustObj[3] = Vector(0, 1, mTanHalf).normal(); // bottom
	//=========================================================
}

//=============================================================================

void Camera::setTarget(Vector &v)
{
	this->pointAt(mTarget = v);
	this->buildProj();
}

void Camera::setSource(Vector &v)
{
	mOrigin = v;
	this->setTarget(mTarget);
}

void Camera::orbit(Vector &origin, float radius, float lngAngle, float latAngle)
{
	mOrigin = origin + Vector().fromAngle(Vector(0, latAngle, lngAngle)) * -radius;
	this->setTarget(origin);
}

//=============================================================================

bool Camera::clipRect(Vector &v)
{
	return !inRange(v.x, 0, mWidth) || !inRange(v.y, 0, mHeight);
}

bool Camera::clipRect(Face &face, Vector *v)
{
	return
		!inRange(v[face.a].z, 0, 1) ||
		!inRange(v[face.b].z, 0, 1) ||
		!inRange(v[face.c].z, 0, 1) ||
		this->clipRect(v[face.a]) ||
		this->clipRect(v[face.b]) ||
		this->clipRect(v[face.c]);
}

bool Camera::clipFrust(Vector &v)
{
	return
		sgn(mFrustWrl[0].rayCompare(v, mAbsOrigin)) < 0 ||
		sgn(mFrustWrl[1].rayCompare(v, mAbsOrigin)) < 0 ||
		sgn(mFrustWrl[2].rayCompare(v, mAbsOrigin)) < 0 ||
		sgn(mFrustWrl[3].rayCompare(v, mAbsOrigin)) < 0 ||
		!inRange(
			this->query(TRANS::ABS_DIR_FWD).rayCompare(v, mAbsOrigin),
			mNear, mFar
			);
}

//=============================================================================

float Camera::shade(Vector &p)
{
	return 1 - limit((mAbsOrigin.dist(p) - mNear) / (mFar - mNear), 0, 1);
}

//=============================================================================

void Camera::buildTrans()
{
	Object::buildTrans();
	this->applyTrans(mFrustWrl, mFrustObj, 4);
	for (int i = 0; i < 4; i++)
		mFrustWrl[i] -= mAbsOrigin;
}

void Camera::buildProj()
{
	mProj =
		!this->mTrans *
		PerspectTrans(mWidth, mHeight, mAspect, mNear, mFar, mTanHalf);
}

void Camera::applyProj(Vector *r, Vector *v, int n)
{
	for (int i = 0; i < n; i++)
	{
		float t[4];
		v[i].multEx(t, mProj);
		r[i] = Vector(t) / t[3];
	}
}

Matrix Camera::getPerspectView()
{
	return !ComboTrans(mAbsOrigin, mAngle, Vector(-1, 1, -1));
}

//=============================================================================

void Camera::apply(float *trans, DEXGL_VIEW funcView)
{
	funcView(trans, mNear, mFar, mTanHalf);
}