#include "Vector.h"

Vector::Vector()  {}
Vector::~Vector() {}

//=============================================================================
// CONSTRUCTOR

Vector::Vector(float x, float y, float z) {this->x = x; this->y = y; this->z = z;}
Vector::Vector(Vector &v)                 {*this = v;}
Vector::Vector(float s)                   {x = s; y = s; z = s;}
Vector::Vector(float *v)                  {memcpy(this->v, v, sizeof(float) * 3);}

//=============================================================================
// EXPORT

void Vector::toArray(float *v)            {memcpy(v, this->v, sizeof(float) * 3);}

//=============================================================================
// OPERATOR OVERLOAD

// assign
Vector &Vector::operator=(Vector &v)  {x  = v.x; y  = v.y; z  = v.z; return *this;}

// reflexive
Vector &Vector::operator+=(Vector &v) {x += v.x; y += v.y; z += v.z; return *this;}
Vector &Vector::operator-=(Vector &v) {x -= v.x; y -= v.y; z -= v.z; return *this;}
Vector &Vector::operator&=(Vector &v) {x *= v.x; y *= v.y; z *= v.z; return *this;}
Vector &Vector::operator*=(float s)   {x *=   s; y *=   s; z *=   s; return *this;}
Vector &Vector::operator/=(float s)
{
	float r = 1 / s;
	x *= r; y *= r; z *= r;
	return *this;
}
Vector &Vector::operator*=(Vector &v)
{
	return *this = Vector(
		y * v.z - z * v.y,
		z * v.x - x * v.z,
		x * v.y - y * v.x
		);
}
Vector &Vector::operator*=(Matrix &m)
{
	return *this = Vector(
		x * m[0][0] + y * m[1][0] + z * m[2][0] + m[3][0],
		x * m[0][1] + y * m[1][1] + z * m[2][1] + m[3][1],
		x * m[0][2] + y * m[1][2] + z * m[2][2] + m[3][2]
		);
}

// transitive
Vector Vector::operator+(Vector &v) {return Vector(*this) += v;}
Vector Vector::operator-(Vector &v) {return Vector(*this) -= v;}
Vector Vector::operator&(Vector &v) {return Vector(*this) &= v;}
Vector Vector::operator*(float s)   {return Vector(*this) *= s;}
Vector Vector::operator/(float s)   {return Vector(*this) /= s;}
Vector Vector::operator*(Vector &v) {return Vector(*this) *= v;}
Vector Vector::operator*(Matrix &m) {return Vector(*this) *= m;}

// logic
float  &Vector::operator[](AXIS::AXIS axis) {return v[axis];}
float  Vector::operator|(Vector &v)         {return x * v.x + y * v.y + z * v.z;}
bool   Vector::operator==(Vector &v)        {return x == v.x && y == v.y && z == v.z;}
bool   Vector::operator!=(Vector &v)        {return x != v.x || y != v.y || z != v.z;}
bool   Vector::operator<=(Vector &v)        {return x <= v.x && y <= v.y && z <= v.z;}
bool   Vector::operator>=(Vector &v)        {return x >= v.x && y >= v.y && z >= v.z;}
bool   Vector::operator<(Vector &v)         {return x < v.x && y < v.y && z < v.z;}
bool   Vector::operator>(Vector &v)         {return x > v.x && y > v.y && z > v.z;}
Vector Vector::operator-()                  {return *this * -1;};

//=============================================================================
// BASIC

float Vector::mod()
{
	return (float) pow(*this | *this, 0.5f);
}

float Vector::dist(Vector &v)
{
	return (*this - v).mod();
}

Vector &Vector::normalize()
{
	float t = this->mod();
	return *this = safeDiv(*this, t, NULL_VECTOR);
}

Vector Vector::normal()
{
	return Vector(*this).normalize();
}

Vector Vector::normTri(Vector &v1, Vector &v2)
{
	return ((v1 - *this) * (v2 - *this)).normalize();
}

float Vector::angle(Vector &v)
{
	return this->normal() | v.normal();
}

//=============================================================================
// PROJECT

Vector Vector::project(Vector &v)
{
	Vector t = v.normal();
	return t * (t | *this);
}

Vector Vector::ortho(Vector &v)
{
	return *this - this->project(v);
}

Vector Vector::reflect(Vector &n)
{
	if (*this == NULL_VECTOR)
		return *this = n;
	else
		if (this->angle(n) < 0)
			return *this + this->project(n) * -2;
	return *this;
}

//=============================================================================
// RAY-PLANE

float Vector::rayCompare(Vector &v1, Vector &v2)
{
	return (*this | v1) - (*this | v2);
}

bool Vector::rayInRange(Vector &v, Vector &v1, Vector &v2)
{
	Vector t = this->normal();
	return sgn(t.rayCompare(v, v1)) == sgn(t.rayCompare(v2, v));
}

float Vector::raySectPlane(Vector &p, Vector &v, Vector &n)
{
	float t = n | *this;
	return safeDiv(n | (v - p), t, BIG_NUMBER);
}

float Vector::rayDist(Vector &p, Vector &v, Vector &n)
{
	return (*this * n).normal().planePointDist(p, v);
}

Vector Vector::rayNearest(Vector &p, Vector &v, Vector &n)
{
	return this->raySectPlane(p, v, *this * n * n);
}

float Vector::rayPointDist(Vector &p, Vector &v)
{
	return (v - p).ortho(*this).mod();
}

Vector Vector::rayPointNearest(Vector &p, Vector &v)
{
	return p + (v - p).project(*this);
}

float Vector::planePointDist(Vector &p, Vector &v)
{
	return (float) fabs(this->rayCompare(p, v));
}

Vector Vector::planePointNearest(Vector &p, Vector &v)
{
	return p + (v - p).ortho(*this);
}

//=============================================================================
// ANGLE

Vector &Vector::fromAngle(Vector &v)
{
	return *this =
		FWD_VECTOR * RotateTrans(AXIS::X, v.pitch) * RotateTrans(AXIS::Y, v.yaw);
}

Vector Vector::toAngle()
{
	Vector t(x, 0, z);
	Vector r(
		0,
		acosEx(t.angle(*this)),
		acosEx(t.angle(FWD_VECTOR))
		);
	if (!x && !z)
	{
		r.yaw = 0; /* undefined */
		return r;
	}
	if (x < 0) r.yaw *= -1;
	if (y > 0) r.pitch *= -1;
	return r;
}

//=============================================================================
// BEZIER

Vector &Vector::bez_interp(Vector c1, Vector c2, Vector c3, float alpha)
{
	Vector c[3] = {c1, c2, c3};
	return *this = bez_interp(c, 3, alpha);
}

Vector &Vector::bez_interp(Vector c1, Vector c2, Vector c3, Vector c4, float alpha)
{
	Vector c[4] = {c1, c2, c3, c4};
	return *this = bez_interp(c, 4, alpha);
}

Vector &Vector::bez_interp(Vector *c, int count, float alpha)
{
	Vector result = NULL_VECTOR;
	if (count >= 3)
	{
		int n = count - 1;
		for (int i = 0; i < count; i++)
			result += c[i] * choose(n, i) *
				(float) pow(1 - alpha, n - i) * (float) pow(alpha, i);
	}
	return *this = result;
}

//=============================================================================
// LOGIC

Vector Vector::vec_min(Vector &v)
{
	return Vector(min(x, v.x), min(y, v.y), min(z, v.z));
}

Vector Vector::vec_max(Vector &v)
{
	return Vector(max(x, v.x), max(y, v.y), max(z, v.z));
}

float Vector::vec_max()
{
	return max((float) fabs(x), max((float) fabs(y), (float) fabs(z)));
}

Vector Vector::vec_abs()
{
	return Vector((float) fabs(x), (float) fabs(y), (float) fabs(z));
}

Vector Vector::vec_interp(Vector &v, float s)
{
	return interp(*this, v, s);
}

bool Vector::vec_inRange(Vector &pMin, Vector &pMax)
{
	return
		inRange(x, pMin.x, pMax.x) &&
		inRange(y, pMin.y, pMax.y) &&
		inRange(z, pMin.z, pMax.z);
}

Vector &Vector::vec_wrap(Vector &pMin, Vector &pMax)
{
	x = wrap(x, pMin.x, pMax.x);
	y = wrap(y, pMin.y, pMax.y);
	z = wrap(z, pMin.z, pMax.z);
	return *this;
}

Vector &Vector::vec_limit(Vector &pMin, Vector &pMax)
{
	x = limit(x, pMin.x, pMax.x);
	y = limit(y, pMin.y, pMax.y);
	z = limit(z, pMin.z, pMax.z);
	return *this;
}

//=============================================================================
// MISC

void Vector::multEx(float *r, Matrix &m)
{
	r[0] = x * m[0][0] + y * m[1][0] + z * m[2][0] + m[3][0];
	r[1] = x * m[0][1] + y * m[1][1] + z * m[2][1] + m[3][1];
	r[2] = x * m[0][2] + y * m[1][2] + z * m[2][2] + m[3][2];
	r[3] = x * m[0][3] + y * m[1][3] + z * m[2][3] + m[3][3];
}

Vector &Vector::mask(Vector &m, Vector &v)
{
	if (m.x) x = v.x;
	if (m.y) y = v.y;
	if (m.z) z = v.z;
	return *this;
}