#include "HullPrim.h"

HullPrim::HullPrim()  {}
HullPrim::~HullPrim() {}

void HullPrim::update(Vector &origin, Matrix &trans, Vector &dim, Vector *boxWrl)
{
	Vector normal;
	switch (mHullType)
	{
		case HULL::PLANE:
		case HULL::CAPSULE:
			normal = UP_VECTOR * trans - origin;
	}
	float radius;
	float height;
	switch (mHullType)
	{
		case HULL::PLANE:
			((HullPlane *) this)->mP1 = origin;
			((HullPlane *) this)->mNormal = normal;
			break;
		case HULL::SPHERE:
			((HullSphere *) this)->mP1 = origin;
			((HullSphere *) this)->mRadius = dim.vec_maxDim() * 0.5f;
			break;
		case HULL::CAPSULE:
			radius = max(dim.x, dim.z) * 0.5f;
			height = dim.y - 2 * radius;
			((HullCapsule *) this)->mP1 = origin;
			((HullCapsule *) this)->mP2 = origin + normal * height;
			((HullCapsule *) this)->mRadius = radius;
			break;
		case HULL::BOX:
			for (int i = 0; i < 8; i++)
				((HullBox *) this)->mP[i] = boxWrl[i];
	}
}

Vector HullPrim::collide(HullPrim *other, Vector &normal)
{
	switch (other->mHullType)
	{
		case HULL::PLANE: return this->collidePlane((HullPlane *) other, normal);
		case HULL::SPHERE: return this->collideSphere((HullSphere *) other, normal);
		case HULL::CAPSULE: return this->collideCapsule((HullCapsule *) other, normal);
		case HULL::BOX: return this->collideBox((HullBox *) other, normal);
	}
}

//=============================================================================

HullPrim *HullFactory::build(HULL::HULL hullType)
{
	switch (hullType)
	{
		case HULL::PLANE: return new HullPlane();
		case HULL::SPHERE: return new HullSphere();
		case HULL::CAPSULE: return new HullCapsule();
		case HULL::BOX: return new HullBox();
	}
}

//=============================================================================

HullPlane::HullPlane()
{
	mHullType = HULL::PLANE;
	mP1 = NULL_VECTOR;
	mNormal = UP_VECTOR;
}

HullPlane::~HullPlane()
{
}

Vector HullPlane::collidePlane(HullPlane *other, Vector &normal)
{
	// always collide, do not handle
	return NULL_VECTOR;
}

Vector HullPlane::collideSphere(HullSphere *other, Vector &normal)
{
	if (mNormal.rayCompare(other->mP1, mP1) <= other->mRadius)
	{
		normal = mNormal;
		return mNormal.planePointNearest(mP1, other->mP1);
	}
	return NULL_VECTOR;
}

Vector HullPlane::collideCapsule(HullCapsule *other, Vector &normal)
{
	float dist1 = mNormal.rayCompare(other->mP1, mP1);
	float dist2 = mNormal.rayCompare(other->mP2, mP1);
	float minDist2 = min(dist1, dist2);
	if (minDist2 <= other->mRadius)
	{
		normal = mNormal;
		if (dist1 == minDist2)
			return mNormal.planePointNearest(mP1, other->mP1);
		if (dist2 == minDist2)
			return mNormal.planePointNearest(mP1, other->mP2);
	}
	return NULL_VECTOR;
}

Vector HullPlane::collideBox(HullBox *other, Vector &normal)
{
	float bestDist = BIG_NUMBER;
	Vector bestCorner;
	for (int i = 0; i < 8; i++)
	{
		float curDist = mNormal.rayCompare(other->mP[i], mP1);
		if (curDist < bestDist)
		{
			bestDist = curDist;
			bestCorner = mNormal.planePointNearest(mP1, other->mP[i]);
		}
	}
	if (bestDist <= 0)
	{
		normal = mNormal;
		return bestCorner;
	}
	return NULL_VECTOR;
}

//=============================================================================

HullSphere::HullSphere()
{
	mHullType = HULL::SPHERE;
	mP1 = NULL_VECTOR;
	mRadius = 0;
}

HullSphere::~HullSphere()
{
}

Vector HullSphere::collidePlane(HullPlane *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullSphere::collideSphere(HullSphere *other, Vector &normal)
{
	float minDist = mRadius + other->mRadius;
	float alpha_self = mRadius / minDist;
	//=========================================================
	Vector diff = other->mP1 - mP1;
	if (diff.mod() <= minDist)
	{
		normal = diff.normal();
		return mP1.vec_interp(other->mP1, alpha_self);
	}
	//=========================================================
	return NULL_VECTOR;
}

Vector HullSphere::collideCapsule(HullCapsule *other, Vector &normal)
{
	float minDist = mRadius + other->mRadius;
	float alpha_self = mRadius / minDist;
	Vector ray_other = other->mP2 - other->mP1;
	Vector p3_other = ray_other.rayPointNearest(other->mP1, mP1);
	//=========================================================
	Vector diff = p3_other - mP1;
	if (ray_other.rayInRange(p3_other, other->mP1, other->mP2))
		if (diff.mod() <= minDist)
		{
			normal = diff.normal();
			return mP1.vec_interp(p3_other, alpha_self);
		}
	//=========================================================
	Vector diff1 = other->mP1 - mP1;
	Vector diff2 = other->mP2 - mP1;
	float dist1 = diff1.mod();
	float dist2 = diff2.mod();
	float minDist2 = min(dist1, dist2);
	if (minDist2 <= minDist)
	{
		if (dist1 == minDist2)
		{
			normal = diff1.normal();
			return mP1.vec_interp(other->mP1, alpha_self);
		}
		if (dist2 == minDist2)
		{
			normal = diff2.normal();
			return mP1.vec_interp(other->mP2, alpha_self);
		}
	}
	//=========================================================
	return NULL_VECTOR;
}

Vector HullSphere::collideBox(HullBox *other, Vector &normal)
{
	// FIX ME!
	return NULL_VECTOR;
}

//=============================================================================

HullCapsule::HullCapsule()
{
	mHullType = HULL::CAPSULE;
	mP1 = NULL_VECTOR;
	mP2 = NULL_VECTOR;
	mRadius = 0;
}

HullCapsule::~HullCapsule()
{
}

Vector HullCapsule::collidePlane(HullPlane *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullCapsule::collideSphere(HullSphere *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullCapsule::collideCapsule(HullCapsule *other, Vector &normal)
{
	float minDist = mRadius + other->mRadius;
	float alpha_self = mRadius / minDist;
	Vector ray_other = other->mP2 - other->mP1;
	Vector ray_self = mP2 - mP1;
	Vector p3_other = ray_other.rayNearest(other->mP1, mP1, ray_self);
	Vector p3_self = ray_self.rayNearest(mP1, other->mP1, ray_other);
	//=========================================================
	Vector diff = p3_other - p3_self;
	if (
		ray_other.rayInRange(p3_other, other->mP1, other->mP2) &&
		ray_self.rayInRange(p3_self, mP1, mP2)
		)
		if (diff.mod() <= minDist)
		{
			normal = diff.normal();
			return p3_self.vec_interp(p3_other, alpha_self);
		}
	//=========================================================
	Vector diff1 = p3_other - mP1;
	Vector diff2 = p3_other - mP2;
	Vector diff3 = other->mP1 - p3_self;
	Vector diff4 = other->mP2 - p3_self;
	float dist1 = diff1.mod();
	float dist2 = diff2.mod();
	float dist3 = diff3.mod();
	float dist4 = diff4.mod();
	float minDist2 = min(dist1, min(dist2, min(dist3, dist4)));
	if (minDist2 < minDist)
	{
		if (dist1 == minDist2)
		{
			normal = diff1.normal();
			return mP1.vec_interp(p3_other, alpha_self);
		}
		if (dist2 == minDist2)
		{
			normal = diff2.normal();
			return mP2.vec_interp(p3_other, alpha_self);
		}
		if (dist3 == minDist2)
		{
			normal = diff3.normal();
			return p3_self.vec_interp(other->mP1, alpha_self);
		}
		if (dist4 == minDist2)
		{
			normal = diff4.normal();
			return p3_self.vec_interp(other->mP2, alpha_self);
		}
	}
	//=========================================================
	diff1 = other->mP1 - mP1;
	diff2 = other->mP2 - mP1;
	diff3 = other->mP1 - mP2;
	diff4 = other->mP2 - mP2;
	dist1 = diff1.mod();
	dist2 = diff2.mod();
	dist3 = diff3.mod();
	dist4 = diff4.mod();
	minDist2 = min(dist1, min(dist2, min(dist3, dist4)));
	if (minDist2 <= minDist)
	{
		if (dist1 == minDist2)
		{
			normal = diff1.normal();
			return mP1.vec_interp(other->mP1, alpha_self);
		}
		if (dist2 == minDist2)
		{
			normal = diff2.normal();
			return mP1.vec_interp(other->mP2, alpha_self);
		}
		if (dist3 == minDist2)
		{
			normal = diff3.normal();
			return mP2.vec_interp(other->mP1, alpha_self);
		}
		if (dist4 == minDist2)
		{
			normal = diff4.normal();
			return mP2.vec_interp(other->mP2, alpha_self);
		}
	}
	//=========================================================
	return NULL_VECTOR;
}

Vector HullCapsule::collideBox(HullBox *other, Vector &normal)
{
	// FIX ME!
	return NULL_VECTOR;
}

//=============================================================================

HullBox::HullBox()
{
	mHullType = HULL::BOX;
	for (int i = 0; i < 8; i++)
		mP[i] = NULL_VECTOR;
}

HullBox::~HullBox()
{
}

Vector HullBox::collidePlane(HullPlane *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullBox::collideSphere(HullSphere *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullBox::collideCapsule(HullCapsule *other, Vector &normal)
{
	Vector &contact = other->collide(this, normal);
	normal = -normal;
	return contact;
}

Vector HullBox::collideBox(HullBox *other, Vector &normal)
{
	// FIX ME!
	return NULL_VECTOR;
}