#ifndef H_VECTOR
#define H_VECTOR

#include <assert.h> // assert
#include <vector> // std::vector
#include <algorithm> // std::min_element
#include <numeric> // std::accumulate
#include "Tensor.h"
#include "Util.h" // TBinOp

//=============================================================================
// DEFAULT TYPES MACRO

#define RAND_VECTOR3D Vector<>(rnd(), rnd(), rnd())

//=============================================================================
// LOGIC FUNCTOR

template<class T> class TPower : public TBinOp<T, T>
	{public: T operator()(T a, T b) const {return (T) pow(a, b);}};
template<class T> class TMin : public TBinOp<T, T>
	{public: T operator()(T a, T b) const {return min(a, b);}};
template<class T> class TMax : public TBinOp<T, T>
	{public: T operator()(T a, T b) const {return max(a, b);}};
template<class T> class TFabs : public TUnaryOp<T, T>
	{public: T operator()(T x) const {return (T) fabs(x);}};
template<class T> class TRnd : public TUnaryOp<T, T>
	{public: T operator()(T x) const {return (x) * rnd();}};

//=============================================================================
// CLASS DEF

template<class T = double>
class Vector : public Tensor<T>
{
public:
	Vector();
	~Vector();
	//=========================================================
	// constructor
	Vector(T x, T y, T z);
	Vector(T x, T y);
	Vector(T x);
	Vector(const Tensor<T> &m);
	Vector(int size);
	Vector(int size, T s);
	Vector(int size, T *v);
	//=========================================================
	// size
	Vector<T> &resize(int size);
	//=========================================================
	// array
	void toArray(T *v) const;
	Vector<T> &fromArray(T *v);
	//=========================================================
	// assign
	T &operator[](int idx);
	const T &operator[](int idx) const;
	Vector<T> &operator=(const Tensor<T> &m);
	Vector<T> &operator=(T s);
	//=========================================================
	// operator overload (transitive)
	using Tensor<T>::operator+;
	using Tensor<T>::operator-;
	using Tensor<T>::operator*;
	using Tensor<T>::operator/;
	using Tensor<T>::operator&;
	Vector<T> operator^(const Vector<T> &v) const;
	//=========================================================
	// operator overload (reflexive)
	using Tensor<T>::operator+=;
	using Tensor<T>::operator-=;
	using Tensor<T>::operator*=;
	using Tensor<T>::operator/=;
	using Tensor<T>::operator&=;
	Vector<T> &operator^=(const Vector<T> &v);
	//=========================================================
	// operator overload (misc)
	using Tensor<T>::operator-;
	using Tensor<T>::operator~;
	using Tensor<T>::operator==;
	using Tensor<T>::operator!=;
	T operator|(const Vector<T> &v) const;
	//=========================================================
	// distance
	T distV(const Vector<T> &v) const;
	T dist(const Vector<T> &v) const;
	T angleV(const Vector<T> &v) const;
	T angle(const Vector<T> &v) const;
	//=========================================================
	// ray ops
	Vector<T> project(const Vector<T> &v) const;
	Vector<T> ortho(const Vector<T> &v) const;
	Vector<T> reflect(const Vector<T> &v) const;
	Vector<T> mirror(const Vector<T> &v) const;
	//=========================================================
	// logic
	Vector<T> vec_interp(const Vector<T> &v, T s) const;
	Vector<T> vec_min(const Vector<T> &v) const;
	Vector<T> vec_max(const Vector<T> &v) const;
	bool vec_inRange(T lo, T hi) const;
	Vector<T> vec_limit(T lo, T hi) const;
	Vector<T> vec_abs() const;
	Vector<T> vec_rnd() const;
	//=========================================================
	// stats
	T pMin() const;
	T pMax() const;
	T sum() const;
	T mean() const;
	T var() const;
	T stdDev() const;
	//=========================================================
};

template<class T> Vector<T>::Vector() : Tensor<T>(1, 3) {}
template<class T> Vector<T>::~Vector() {}

//=============================================================================
// CONSTRUCTOR

template<class T>
Vector<T>::Vector(T x, T y, T z) : Tensor<T>(1, 3)
{
	mData[0][0] = x;
	mData[0][1] = y;
	mData[0][2] = z;
}
template<class T>
Vector<T>::Vector(T x, T y) : Tensor<T>(1, 2)
{
	mData[0][0] = x;
	mData[0][1] = y;
}
template<class T> Vector<T>::Vector(T x) : Tensor<T>(1, 1)
	{mData[0][0] = x;}
template<class T> Vector<T>::Vector(const Tensor<T> &m) : Tensor<T>(m)          {}
template<class T> Vector<T>::Vector(int size)           : Tensor<T>(1, size)    {}
template<class T> Vector<T>::Vector(int size, T s)      : Tensor<T>(1, size, s) {}
template<class T> Vector<T>::Vector(int size, T *v)     : Tensor<T>(1, size, v) {}

//=============================================================================
// SIZE

template<class T>
Vector<T> &Vector<T>::resize(int size)
{
	if (mColCnt >= mRowCnt)
		Tensor<T>::resize(1, size);
	else
		Tensor<T>::resize(size, 1);
	return *this;
}

//=============================================================================
// ARRAY

template<class T>
void Vector<T>::toArray(T *v) const
{
	if (mColCnt >= mRowCnt)
		for (int i = 0; i < mColCnt; i++)
			v[i] = mData[0][i];
	else
		for (int i = 0; i < mRowCnt; i++)
			v[i] = mData[i][0];
}
template<class T>
Vector<T> &Vector<T>::fromArray(T *v)
{
	if (mColCnt >= mRowCnt)
		for (int i = 0; i < mColCnt; i++)
			mData[0][i] = v[i];
	else
		for (int i = 0; i < mRowCnt; i++)
			mData[i][0] = v[i];
	return *this;
}

//=============================================================================
// ASSIGN

template<class T>
T &Vector<T>::operator[](int idx)
{
	assert(inRange(idx, 0, mSize));
	return (mColCnt >= mRowCnt) ? mData[0][idx] : mData[idx][0];
}
template<class T>
const T &Vector<T>::operator[](int idx) const
{
	assert(inRange(idx, 0, mSize));
	return (mColCnt >= mRowCnt) ? mData[0][idx] : mData[idx][0];
}
template<class T> Vector<T> &Vector<T>::operator=(const Tensor<T> &m)
	{return (Vector<T> &) Tensor<T>::operator=(m);}
template<class T> Vector<T> &Vector<T>::operator=(T s)
	{return (Vector<T> &) Tensor<T>::operator=(s);}

//=============================================================================
// OPERATOR OVERLOAD

// transitive
template<class T>
Vector<T> Vector<T>::operator^(const Vector<T> &v) const
{
	assert(mColCnt == 3 && v.colCnt() == 3);
	Tensor<T> tmp(3);
	tmp.setRow(1, *this);
	tmp.setRow(2, v);
	tmp[0][0] = tmp.cofactor(0, 0);
	tmp[0][1] = tmp.cofactor(0, 1);
	tmp[0][2] = tmp.cofactor(0, 2);
	return tmp.getRow(0);
}

// reflexive
template<class T> Vector<T> &Vector<T>::operator^=(const Vector<T> &v)
	{return *this = *this ^ v;}

// misc
template<class T>
T Vector<T>::operator|(const Vector<T> &v) const
{
	assert(mSize == v.size());
	Vector<T> a = *this;
	Vector<T> b = v;
	if (a.rowCnt() > a.colCnt()) a = ~a;
	if (b.rowCnt() < b.colCnt()) b = ~b;
	return (a * b)[0][0];
}

//=============================================================================
// DISTANCE

template<class T> T Vector<T>::distV(const Vector<T> &v) const
	{return (*this - v).modV();}
template<class T> T Vector<T>::dist(const Vector<T> &v) const
	{return (*this - v).mod();}
template<class T> T Vector<T>::angleV(const Vector<T> &v) const
	{return Vector<T>(this->norm()) | Vector<T>(v.norm());}
template<class T> T Vector<T>::angle(const Vector<T> &v) const
	{return acosEx(this->angleV(v));}

//=============================================================================
// RAY OPS

template<class T> Vector<T> Vector<T>::project(const Vector<T> &v) const
	{Vector<T> tmp = v.norm(); return tmp * (tmp | *this);}
template<class T> Vector<T> Vector<T>::ortho(const Vector<T> &v) const
	{return *this - this->project(v);}
template<class T> Vector<T> Vector<T>::reflect(const Vector<T> &v) const
	{return (this->angleV(v) < 0) ? *this + this->project(v) * -2 : *this;}
template<class T> Vector<T> Vector<T>::mirror(const Vector<T> &v) const
	{return *this - (v - *this);}

//=============================================================================
// LOGIC

template<class T>
Vector<T> Vector<T>::vec_interp(const Vector<T> &v, T s) const
	{return interp(*this, v, s);}
template<class T>
Vector<T> Vector<T>::vec_min(const Vector<T> &v) const
{
	T *arr_v = new T[mSize * 2];
	this->toArray(arr_v);
	v.toArray(arr_v + mSize);
	std::transform(arr_v, arr_v + mSize, arr_v + mSize, arr_v, TMin<T>());
	Vector<T> r(mSize, arr_v);
	delete []arr_v;
	return r;
}
template<class T>
Vector<T> Vector<T>::vec_max(const Vector<T> &v) const
{
	T *arr_v = new T[mSize * 2];
	this->toArray(arr_v);
	v.toArray(arr_v + mSize);
	std::transform(arr_v, arr_v + mSize, arr_v + mSize, arr_v, TMax<T>());
	Vector<T> r(mSize, arr_v);
	delete []arr_v;
	return r;
}
template<class T>
bool Vector<T>::vec_inRange(T lo, T hi) const
{
	for (int i = 0; i < mSize; i++)
		if (!inRange((*this)[i], lo, hi))
			break;
	return i == mSize;
}
template<class T>
Vector<T> Vector<T>::vec_limit(T lo, T hi) const
{
	Vector<T> r(mSize);
	for (int i = 0; i < mSize; i++)
		r[i] = limit((*this)[i], lo, hi);
	return r;
}
template<class T>
Vector<T> Vector<T>::vec_abs() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	std::transform(arr_v, arr_v + mSize, arr_v, TFabs<T>());
	Vector<T> r(mSize, arr_v);
	delete []arr_v;
	return r;
}
template<class T>
Vector<T> Vector<T>::vec_rnd() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	std::transform(arr_v, arr_v + mSize, arr_v, TRnd<T>());
	Vector<T> r(mSize, arr_v);
	delete []arr_v;
	return r;
}

//=============================================================================
// STATS

template<class T>
T Vector<T>::pMin() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	T r = *std::min_element(arr_v, arr_v + mSize);
	delete []arr_v;
	return r;
}
template<class T>
T Vector<T>::pMax() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	T r = *std::max_element(arr_v, arr_v + mSize);
	delete []arr_v;
	return r;
}
template<class T>
T Vector<T>::sum() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	T r = std::accumulate(arr_v, arr_v + mSize, 0.0f);
	delete []arr_v;
	return r;
}
template<class T> T Vector<T>::mean() const {return this->sum() / mSize;}
template<class T>
T Vector<T>::var() const
{
	T *arr_v = new T[mSize];
	this->toArray(arr_v);
	std::transform(
		arr_v, arr_v + mSize, arr_v, std::bind2nd(std::minus<T>(), this->mean())
		);
	std::transform(arr_v, arr_v + mSize, arr_v, std::bind2nd(TPower<T>(), 2));
	T r = std::accumulate(arr_v, arr_v + mSize, 0.0f) / mSize;
	delete []arr_v;
	return r;
}
template<class T> T Vector<T>::stdDev() const {return sqrt(this->var());}

//=============================================================================
// DEFAULT TYPES

static const Vector<> UNIT_VECTOR3D(3, 1.0f);
static const Vector<> NULL_VECTOR3D(3);
static const Vector<> FWD_VECTOR3D(0, 0, 1);
static const Vector<> LEFT_VECTOR3D(1, 0, 0);
static const Vector<> UP_VECTOR3D(0, 1, 0);

#endif