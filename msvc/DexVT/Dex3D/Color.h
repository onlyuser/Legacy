#ifndef H_COLOR
#define H_COLOR

#include "Vector.h"

#define RAND_COLOR Color::fromVector(RAND_VECTOR * 255)

class Color
{
public:
	static Vector toVector(long c);
	static long fromVector(Vector &v);
	static long rgb_interp(long c1, long c2, float a);
};

#endif