#ifndef H_TRANSFORM
#define H_TRANSFORM

#include "Tensor.h"
#include "Vector.h"

//=============================================================================
// SMART ENUM

namespace AXIS {enum AXIS {X, Y, Z};};
namespace PIVOT {enum PIVOT {ROLL, PITCH, YAW};};

//=============================================================================
// CONSTRUCTOR

template<class T = double>
class ScaleTrans : public Tensor<T>
{
public:
	ScaleTrans(const Vector<T> &v)
	{
		mData[0][0] = v[AXIS::X];
		mData[1][1] = v[AXIS::Y];
		mData[2][2] = v[AXIS::Z];
		mData[3][3] = 1;
	}
};
template<class T = double>
class TranslateTrans : public Tensor<T>
{
public:
	TranslateTrans(const Vector<T> &v)
	{
		Tensor<T>::operator=(IDENT_MATRIX);
		mData[3][0] = v[AXIS::X];
		mData[3][1] = v[AXIS::Y];
		mData[3][2] = v[AXIS::Z];
	}
};
// NOTE: rotates clockwise looking at origin against each axis
template<class T = double>
class RotateTrans : public Tensor<T>
{
public:
	RotateTrans(AXIS::AXIS axis, T angle)
	{
		T pSin = (T) sin(angle);
		T pCos = (T) cos(angle);
		switch (axis)
		{
			case AXIS::X:
				mData[0][0] = 1;
				mData[1][1] = pCos;  mData[1][2] = pSin;
				mData[2][1] = -pSin; mData[2][2] = pCos;
				break;
			case AXIS::Y:
				mData[0][0] = pCos; mData[0][2] = -pSin;
				mData[1][1] = 1;
				mData[2][0] = pSin; mData[2][2] = pCos;
				break;
			case AXIS::Z:
				mData[0][0] = pCos;  mData[0][1] = pSin;
				mData[1][0] = -pSin; mData[1][1] = pCos;
				mData[2][2] = 1;
		}
		mData[3][3] = 1;
	}
	RotateTrans(const Vector<T> &v)
	{
		*this = RotateTrans<T>(AXIS::Z, v[PIVOT::ROLL]);
		*this *= RotateTrans<T>(AXIS::X, v[PIVOT::PITCH]);
		*this *= RotateTrans<T>(AXIS::Y, v[PIVOT::YAW]);
	}
};
template<class T = double>
class ComboTrans : public Tensor<T>
{
	ComboTrans(
		const Vector<T> &origin, const Vector<T> &angle, const Vector<T> &scale
		)
	{
		*this = ScaleTrans<T>(scale);
		*this *= RotateTrans<T>(angle);
		*this *= TranslateTrans<T>(origin);
	}
};

//=============================================================================
// ANGLE MACRO

template<class T>
Vector<T> _toVec(const Vector<T> &v)
{
	return FWD_VECTOR3D *
		RotateTrans<T>(AXIS::X, v[PIVOT::PITCH]) *
		RotateTrans<T>(AXIS::Y, v[PIVOT::YAW]);
}
template<class T>
Vector<T> _toAng(const Vector<T> &v)
{
	Vector<T> tmp(v[AXIS::X], 0, v[AXIS::Z]);
	Vector<T> r(0, tmp.angle(v), tmp.angle(FWD_VECTOR3D));
	if (
		fabs(v[AXIS::X]) < EPSILON && fabs(v[AXIS::Z]) < EPSILON
		) // degenerate case
	{
		r[PIVOT::PITCH] = sgn(v[AXIS::Y]) * toRad(90); // up: +dir
		r[PIVOT::YAW] = 0; // undefined
		return r;
	}
	if (v[AXIS::X] > 0) r[PIVOT::YAW] *= -1; // left: -dir
	if (v[AXIS::Y] < 0) r[PIVOT::PITCH] *= -1; // down: -dir
	return r;
}

//=============================================================================
// BASIS

template<class T>
void _killVecList(std::vector<Vector<T> *> &vecList)
{
	for (int i = 0; i < vecList.size(); i++)
		delete vecList[i];
	vecList.clear();
}
// NOTE: basis is orthonormal
template<class T>
std::vector<Vector<T> *> _genDefBasis(int dimCnt)
{
	std::vector<Vector<T> *> r;
	for (int i = 0; i < dimCnt; i++) // for every dimension
	{
		r.push_back(new Vector<T>(dimCnt)); // add new axis
		(*r[i])[i] = 1; // make each axis linearly independent
	}
	return r;
}
// NOTE: basis is orthonormal
// NOTE #2: equivalent to "Gram-Schmidt Orthonormalization"
template<class T>
std::vector<Vector<T> *> _genDirBasis(int dimCnt, const Vector<T> &dir)
{
	assert(dir.mod() > EPSILON);
	std::vector<Vector<T> *> r;
	r.push_back(new Vector<T>(dir.norm())); // add first axis
	for (int i = 1; i < dimCnt; i++) // for remaining dimensions
	{
		Vector<T> rand;
		//=========================================================
		// generate random axis with new information
		bool repeat;
		do
		{
			repeat = false;
			rand = Vector<T>(dimCnt).random().norm(); // generate random vector
			for (int j = 0; j < r.size(); j++) // for every axis found
				if (fabs(rand | *r[j]) > 1 - EPSILON) // check if redundant
					repeat = true;
		} while (repeat);
		//=========================================================
		for (int k = 0; k < r.size(); k++) // for every axis found
			rand -= rand.project(*r[k]); // strip projected components
		r.push_back(new Vector<T>(rand.norm())); // add leftover as new axis
	}
	return r;
}
template<class T>
Vector<T> _changeBasis(
	const Vector<T> &v,
	const Vector<T> &origin1, const std::vector<Vector<T> *> &basis1,
	const Vector<T> &origin2, const std::vector<Vector<T> *> &basis2
	)
{
	Vector<T> r(origin2);
	Vector<T> v2(v - origin1);
	for (int i = 0; i < r.size(); i++)
	{
		/*
		r += *basis2[i] * (v2.project(*basis1[i]).mod() / basis1[i]->mod() *
			sgn(v2 | *basis1[i]));
		*/
		T tmp = *basis1[i] | v2;
		T tmp2 = basis1[i]->mod();
		T tmp3 = tmp2 * tmp2 * tmp2;
		r += *basis2[i] * ((*basis1[i] * (tmp / tmp3)).mod() * sgn(tmp));
	}
	return r;
}

//=============================================================================
// RAY-PLANE

// basic
template<class T>
T _rayCompare(
	const Vector<T> &ray_n, const Vector<T> &p1, const Vector<T> &p2
	)
	{return (p1 | ray_n) - (p2 | ray_n);}
template<class T>
bool _rayInRange(
	const Vector<T> &ray_n, const Vector<T> &p1, const Vector<T> &p2,
	const Vector<T> &p
	)
{
	return sgn(_rayCompare<T>(ray_n, p, p1)) ==
		sgn(_rayCompare<T>(ray_n, p2, p));
}

// point metrics
template<class T>
T _rayPointDist(
	const Vector<T> &ray_n, const Vector<T> &ray_p, const Vector<T> &p
	)
	{return Vector<T>(p - ray_p).ortho(ray_n).mod();}
template<class T>
T _planePointDist(
	const Vector<T> &plane_n, const Vector<T> &plane_p, const Vector<T> &p
	)
	{return Vector<T>(p - plane_p).project(plane_n).mod();}
template<class T>
Vector<T> _rayPointNearest(
	const Vector<T> &ray_n, const Vector<T> &ray_p, const Vector<T> &p
	)
	{return ray_p + Vector<T>(p - ray_p).project(ray_n);}
template<class T>
Vector<T> _planePointNearest(
	const Vector<T> &plane_n, const Vector<T> &plane_p, const Vector<T> &p
	)
	{return plane_p + Vector<T>(p - plane_p).ortho(plane_n);}

// advanced
template<class T>
T _rayDist3D(
	const Vector<T> &ray1_n, const Vector<T> &ray1_p,
	const Vector<T> &ray2_n, const Vector<T> &ray2_p
	)
	{return _planePointDist<T>((ray1_n ^ ray2_n).normal(), ray1_p, ray2_p);}
template<class T>
Vector<T> _rayNearest3D(
	const Vector<T> &ray1_n, const Vector<T> &ray1_p,
	const Vector<T> &ray2_n, const Vector<T> &ray2_p
	)
{
	return _raySectPlane<T>(
		ray1_n, ray1_p, (ray1_n ^ ray2_n) ^ ray2_n, ray2_p
		);
}
// PROOF:
// POINT p ON PLANE = {plane_n, plane_p}:
//     1) (p | plane_n) - (0 | plane_n) = dist
//     2) (p | plane_n) = dist
// POINT p ON RAY = {ray_n, ray_p}:
//     3) p = ray_p + alpha * ray_n
//        sub 3) into 2)
//     4) (ray_p + alpha * ray_n) | plane_n = dist
//     5) (ray_p | plane_n) + alpha * (ray_n | plane_n) = dist
//     6) alpha = (dist - (ray_p | plane_n)) / (ray_n | plane_n)
//        sub 2) into 6)
//     7) alpha = ((p | plane_n) - (ray_p | plane_n)) / (ray_n | plane_n)
//     8) alpha = ((p - ray_p) | plane_n) / (ray_n | plane_n)
// LET POINT p = plane_p, SINCE p = ray_p YIELDS TRIVIAL SOLUTION: alpha = 0
template<class T>
T _raySectPlane(
	const Vector<T> &ray_n, const Vector<T> &ray_p,
	const Vector<T> &plane_n, const Vector<T> &plane_p
	)
{
	T tmp = ray_n | plane_n;
	return safeDiv((plane_p - ray_p) | plane_n, tmp, BIG_NUMBER);
}

// 2d planar
template<class T>
bool _isEdgeSect2D(
	const Vector<T> &ray1_p1, const Vector<T> &ray1_p2,
	const Vector<T> &ray2_p1, const Vector<T> &ray2_p2
	)
{
	Vector<T> ray1_dir = ray1_p2 - ray1_p1;
	Vector<T> ray2_dir = ray2_p2 - ray2_p1;
	if (!ray1_dir.mod() || !ray2_dir.mod())
		return false;
	return
		_rayInRange<T>(ray2_dir.ortho(ray1_dir), ray2_p1, ray2_p2, ray1_p1) &&
		_rayInRange<T>(ray1_dir.ortho(ray2_dir), ray1_p1, ray1_p2, ray2_p1);
}
template<class T>
Vector<T> _edgeSect2D(
	const Vector<T> &ray1_p1, const Vector<T> &ray1_p2,
	const Vector<T> &ray2_p1, const Vector<T> &ray2_p2
	)
{
	T a = ray2_p2[0] - ray2_p1[0];
	T b = ray2_p2[1] - ray2_p1[1];
	T c = ray1_p2[0] - ray1_p1[0];
	T d = ray1_p2[1] - ray1_p1[1];
	T denom = b * c - a * d;
	assert(denom);
	T e = ray1_p1[1] - ray2_p1[1];
	T f = ray1_p1[0] - ray2_p1[0];
	T s1 = (a * e - b * f) / denom;
	T s2 = (c * e - d * f) / denom;
	assert(inRange(s1, 0, 1) && inRange(s2, 0, 1));
	return ray1_p1.vec_interp(ray1_p2, s1);
}
template<class T>
void _clip2D(
	Vector<T> &ray_p1, Vector<T> &ray_p2,
	const Vector<T> pMin, const Vector<T> pMax
	)
{
	Vector<T> v[4];
	for (int i = 0; i < 4; i++)
		v[i] = Vector<T>(2);
	v[0][0] = pMin[0]; v[0][1] = pMin[1];
	v[1][0] = pMax[0]; v[1][1] = pMin[1];
	v[2][0] = pMax[0]; v[2][1] = pMax[1];
	v[3][0] = pMin[0]; v[3][1] = pMax[1];
	if (_isEdgeSect2D(ray_p1, ray_p2, v[0], v[1]))
	{
		*((ray_p1[1] < pMin[1]) ? &ray_p1 : &ray_p2) =
			_edgeSect2D(ray_p1, ray_p2, v[0], v[1]);
	}
	if (_isEdgeSect2D(ray_p1, ray_p2, v[1], v[2]))
	{
		*((ray_p1[0] > pMax[0]) ? &ray_p1 : &ray_p2) =
			_edgeSect2D(ray_p1, ray_p2, v[1], v[2]);
	}
	if (_isEdgeSect2D(ray_p1, ray_p2, v[2], v[3]))
	{
		*((ray_p1[1] > pMax[1]) ? &ray_p1 : &ray_p2) =
			_edgeSect2D(ray_p1, ray_p2, v[2], v[3]);
	}
	if (_isEdgeSect2D(ray_p1, ray_p2, v[3], v[0]))
	{
		*((ray_p1[0] < pMin[0]) ? &ray_p1 : &ray_p2) =
			_edgeSect2D(ray_p1, ray_p2, v[3], v[0]);
	}
}
template<class T>
bool _isInTri2D(
	const Vector<T> &v,
	const Vector<T> &v1, const Vector<T> &v2, const Vector<T> &v3
	)
{
	Vector<T> v1_2 = Vector<T>(v1 - v).resize(3);
	Vector<T> v2_2 = Vector<T>(v2 - v).resize(3);
	Vector<T> v3_2 = Vector<T>(v3 - v).resize(3);
	Vector<T> n = Vector<T>(v2 - v1).resize(3) ^ Vector<T>(v3 - v1).resize(3);
	bool s1 = (n | Vector<T>(v1_2) ^ Vector<T>(v2_2)) > 0;
	bool s2 = (n | Vector<T>(v2_2) ^ Vector<T>(v3_2)) > 0;
	bool s3 = (n | Vector<T>(v3_2) ^ Vector<T>(v1_2)) > 0;
	return s1 && s2 && s3 || !s1 && !s2 && !s3;
}

//=============================================================================
// EDGE-SPHERE

template<class T>
Vector<T> _edgeSectSphere2D(
	const Vector<T> &a, const Vector<T> &b, const Vector<T> &origin
	)
{
	Vector<T> ray = b - a;
	Vector<T> ray_n = ray.norm();
	T s = ((origin | ray_n) - (a | ray_n)) / ray.mod();
	return a.vec_interp(b, limit(s, 0, 1));
}
template<class T>
Vector<T> _edgeSectEllips2D(
	const Vector<T> &a, const Vector<T> &b,
	const Vector<T> &f1, const Vector<T> &f2
	)
{
	Vector<T> ray = b - a;
	Vector<T> ray_n = ray.norm();
	T r1 = _rayPointDist(ray_n, a, f1);
	T r2 = _rayPointDist(ray_n, a, f2);
	T s1 = f1 | ray_n;
	T s2 = f2 | ray_n;
	T s = (interp(s1, s2, r1 / (r1 + r2)) - (a | ray_n)) / ray.mod();
	return a.vec_interp(b, limit(s, 0, 1));
}

//=============================================================================
// ARC-CIRCLE

template<class T>
Vector<T> _calcArcCent(
	const Vector<T> &v1, const Vector<T> &v2, const Vector<T> &v3
	)
{
	assert(fabs(v2[0] - v1[0]) > EPSILON || fabs(v3[0] - v2[0]) > EPSILON);
	if (fabs(v2[0] - v1[0]) < EPSILON)
		return _calcArcCent(v1, v3, v2);
	if (fabs(v3[0] - v2[0]) < EPSILON)
		return _calcArcCent(v2, v1, v3);
	T ma = (v2[1] - v1[1]) / (v2[0] - v1[0]);
	T mb = (v3[1] - v2[1]) / (v3[0] - v2[0]);
	T x = (
		ma * mb * (v1[1] - v3[1]) + mb * (v1[0] + v2[0]) - ma * (v2[0] + v3[0])
		) / (2 * (mb - ma));
	T y;
	if (fabs(ma) > fabs(mb))
		y = -1 / ma * (x - (v1[0] + v2[0]) * 0.5) + (v1[1] + v2[1]) * 0.5;
	else
		y = -1 / mb * (x - (v2[0] + v3[0]) * 0.5) + (v2[1] + v3[1]) * 0.5;
	return Vector<T>(x, y);
}
template<class T>
bool _isInArc2D(
	const Vector<T> &v,
	const Vector<T> &v1, const Vector<T> &v2, const Vector<T> &v3
	)
{
	Vector<T> tmp = _calcArcCent(v1, v2, v3);
	return v.dist(tmp) < v1.dist(tmp);
}

//=============================================================================
// SAMPLING

template<class T>
std::vector<Vector<T> *> _sampLine(
	const Vector<T> &v1, const Vector<T> &v2, int sampCnt, int rndCnt
	)
{
	std::vector<Vector<T> *> r;
	for (int i = 0; i < sampCnt; i++)
		r.push_back(new Vector<T>(v1.vec_interp(v2, std::rndG<T>(rndCnt))));
	return r;
}

#endif