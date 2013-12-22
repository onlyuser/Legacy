#include "Face.h"

Face::Face(int a, int b, int c)
{
	mDraw = true;
	this->set(a, b, c);
}

Face::~Face()
{
}

//=============================================================================

void Face::set(int a, int b, int c)
{
	this->a = a;
	this->b = b;
	this->c = c;
}

void Face::flip()
{
	std::swap(b, c);
}

//=============================================================================

void Face::toArray(long *v)
{
	memcpy(v, this->v, sizeof(long) * 3);
}

//=============================================================================

Vector Face::center(Vector *v)
{
	return (v[a] + v[b] + v[c]) / 3;
}

float Face::depth(Vector *v)
{
	return v[a].z + v[b].z + v[c].z;
}

Vector Face::normal(Vector *v)
{
	return v[a].normTri(v[b], v[c]);
}

float Face::shade(Vector *v, Vector &p)
{
	return (p - this->center(v)).angle(this->normal(v));
}

//=============================================================================

bool Face::sectPoint(Vector *v, Vector &p)
{
	Vector n = this->normal(v);
	return
		(n * (v[b] - v[a]) | (p - v[a])) > 0 &&
		(n * (v[c] - v[b]) | (p - v[b])) > 0 &&
		(n * (v[a] - v[c]) | (p - v[c])) > 0;
}

float Face::sectRay(Vector *v, Vector &p1, Vector &p2)
{
	Vector ray = p2 - p1;
	Vector n = this->normal(v);
	if (ray.angle(n) < 0)
	{
		float s = ray.raySectPlane(p1, v[a], n);
		Vector p3 = p1.vec_interp(p2, s);
		if (this->sectPoint(v, p3))
			return s;
	}
	return BIG_NUMBER;
}

//=============================================================================

void Face::paint(Vector *v, long color, DEXGL_TRI funcTri)
{
	funcTri(color, color, color, v[a].x, v[a].y, v[b].x, v[b].y, v[c].x, v[c].y);
}