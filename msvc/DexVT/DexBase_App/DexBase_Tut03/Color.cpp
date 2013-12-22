#include "Color.h"

Vector Color::toVector(long c)
{
	return Vector(
		(float) getR(c),
		(float) getG(c),
		(float) getB(c)
		);
}

long Color::fromVector(Vector &v)
{
	return rgb((int) v.x, (int) v.y, (int) v.z);
}

long Color::rgb_interp(long c1, long c2, float a)
{
	return fromVector(toVector(c1).vec_interp(toVector(c2), a));
}