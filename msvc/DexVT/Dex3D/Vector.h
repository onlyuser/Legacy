#ifndef H_VECTOR
#define H_VECTOR

#include <windows.h> // memcpy()
#include <math.h> // pow()
#include "Matrix.h"
#include "Util.h" // BIG_NUMBER

#define UNIT_VECTOR mUnitVector
#define NULL_VECTOR mNullVector
#define FWD_VECTOR mFwdVector
#define LEFT_VECTOR mLeftVector
#define UP_VECTOR mUpVector
#define RAND_VECTOR Vector(rnd(), rnd(), rnd())

namespace AXIS
{
	enum AXIS {X, Y, Z, S};
};

class Vector
{
public:
	union
	{
		float v[3];
		struct
		{
			union {float x; float roll;};
			union {float y; float pitch;};
			union {float z; float yaw;};
		};
	};

	Vector();
	~Vector();
	//=============================================================================
	// constructor
	Vector(float x, float y, float z);
	Vector(Vector &v);
	Vector(float s);
	Vector(float *v);
	//=============================================================================
	// export
	void toArray(float *v);
	//=============================================================================
	// operator overload (assign)
	Vector &operator=(Vector &v);
	//=============================================================================
	// operator overload (reflexive)
	Vector &operator+=(Vector &v);
	Vector &operator-=(Vector &v);
	Vector &operator&=(Vector &v);
	Vector &operator*=(float s);
	Vector &operator/=(float s);
	Vector &operator*=(Vector &v);
	Vector &operator*=(Matrix &m);
	//=============================================================================
	// operator overload (transitive)
	Vector operator+(Vector &v);
	Vector operator-(Vector &v);
	Vector operator&(Vector &v);
	Vector operator*(float s);
	Vector operator/(float s);
	Vector operator*(Vector &v);
	Vector operator*(Matrix &m);
	//=============================================================================
	// operator overload (logic)
	float &operator[](AXIS::AXIS axis);
	float operator|(Vector &v);
	bool operator==(Vector &v);
	bool operator!=(Vector &v);
	bool operator<=(Vector &v);
	bool operator>=(Vector &v);
	bool operator<(Vector &v);
	bool operator>(Vector &v);
	Vector operator-();
	//=============================================================================
	// basic
	float mod();
	float dist(Vector &v);
	Vector &normalize();
	Vector normal();
	Vector normTri(Vector &v1, Vector &v2);
	float angle(Vector &v);
	//=============================================================================
	// project
	Vector project(Vector &v);
	Vector ortho(Vector &v);
	Vector reflect(Vector &n);
	//=============================================================================
	// ray-plane
	float rayCompare(Vector &v1, Vector &v2);
	bool rayInRange(Vector &v, Vector &v1, Vector &v2);
	float raySectPlane(Vector &p, Vector &v, Vector &n);
	float rayDist(Vector &p, Vector &v, Vector &n);
	Vector rayNearest(Vector &p, Vector &v, Vector &n);
	float rayPointDist(Vector &p, Vector &v);
	Vector rayPointNearest(Vector &p, Vector &v);
	float planePointDist(Vector &p, Vector &v);
	Vector planePointNearest(Vector &p, Vector &v);
	//=============================================================================
	// angle
	Vector &fromAngle(Vector &v);
	Vector toAngle();
	//=============================================================================
	// bezier
	Vector &bez_interp(Vector c1, Vector c2, Vector c3, float alpha);
	Vector &bez_interp(Vector c1, Vector c2, Vector c3, Vector c4, float alpha);
	Vector &bez_interp(Vector *c, int count, float alpha);
	//=============================================================================
	// logic
	Vector vec_min(Vector &v);
	Vector vec_max(Vector &v);
	float vec_maxDim();
	float vec_minDim();
	Vector vec_abs();
	Vector vec_interp(Vector &v, float s);
	bool vec_inRange(Vector &pMin, Vector &pMax);
	Vector &vec_wrap(Vector &pMin, Vector &pMax);
	Vector &vec_limit(Vector &pMin, Vector &pMax);
	//=============================================================================
	// misc
	void multEx(float *r, Matrix &m);
	Vector &mask(Vector &m, Vector &v);
	//=============================================================================
};

static Vector mUnitVector(1.0f);
static Vector mNullVector(0.0f);
static Vector mFwdVector(0, 0, 1);
static Vector mLeftVector(1, 0, 0);
static Vector mUpVector(0, 1, 0);

#include "Transform.h"

#endif