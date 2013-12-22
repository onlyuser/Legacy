#ifndef H_HULLPRIM
#define H_HULLPRIM

#include "Vector.h"

namespace HULL
{
	enum HULL
	{
		PLANE,
		SPHERE,
		CAPSULE,
		BOX
	};
};

class HullPlane;
class HullSphere;
class HullCapsule;
class HullBox;

class HullPrim
{
protected:
	HULL::HULL mHullType;

	virtual Vector collidePlane(HullPlane *other, Vector &normal) = 0;
	virtual Vector collideSphere(HullSphere *other, Vector &normal) = 0;
	virtual Vector collideCapsule(HullCapsule *other, Vector &normal) = 0;
	virtual Vector collideBox(HullBox *other, Vector &normal) = 0;
public:
	HullPrim();
	~HullPrim();
	void update(Vector &origin, Matrix &trans, Vector &dim, Vector *boxWrl);
	Vector collide(HullPrim *other, Vector &normal);
};

class HullFactory
{
public:
	static HullPrim *build(HULL::HULL hullType);
};

class HullPlane : public HullPrim
{
private:
	Vector collidePlane(HullPlane *other, Vector &normal);
	Vector collideSphere(HullSphere *other, Vector &normal);
	Vector collideCapsule(HullCapsule *other, Vector &normal);
	Vector collideBox(HullBox *other, Vector &normal);
public:
	Vector mP1, mNormal;

	HullPlane();
	~HullPlane();
};

class HullSphere : public HullPrim
{
private:
	Vector collidePlane(HullPlane *other, Vector &normal);
	Vector collideSphere(HullSphere *other, Vector &normal);
	Vector collideCapsule(HullCapsule *other, Vector &normal);
	Vector collideBox(HullBox *other, Vector &normal);
public:
	Vector mP1;
	float mRadius;

	HullSphere();
	~HullSphere();
};

class HullCapsule : public HullPrim
{
private:
	Vector collidePlane(HullPlane *other, Vector &normal);
	Vector collideSphere(HullSphere *other, Vector &normal);
	Vector collideCapsule(HullCapsule *other, Vector &normal);
	Vector collideBox(HullBox *other, Vector &normal);
public:
	Vector mP1, mP2;
	float mRadius;

	HullCapsule();
	~HullCapsule();
};

class HullBox : public HullPrim
{
private:
	Vector collidePlane(HullPlane *other, Vector &normal);
	Vector collideSphere(HullSphere *other, Vector &normal);
	Vector collideCapsule(HullCapsule *other, Vector &normal);
	Vector collideBox(HullBox *other, Vector &normal);
public:
	Vector mP[8];
	Vector mFront, mLeft, mTop;

	HullBox();
	~HullBox();
};

#endif