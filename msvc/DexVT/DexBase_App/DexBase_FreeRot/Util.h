#ifndef H_UTIL
#define H_UTIL

#include <stdlib.h> // rand()
#include <math.h> // fabs()

#define BIG_NUMBER 65535
#define EPSILON 0.0001f
#define PI 3.1415926535897932f

template<class T>
int fact(T n)
{
	return (n <= 1) ? 1 : fact(n - 1) * n;
}

// logic
#ifndef max
	#define max(a, b) (((a) > (b)) ? (a) : (b))
#endif
#ifndef min
	#define min(a, b) (((a) < (b)) ? (a) : (b))
#endif
#define sgn(x) (!(x) ? 0 : (((x) > 0) ? 1 : -1))
#define safeDiv(a, b, c) ((b) ? (a) / (b) : (c))

// interpolation
#define interp(a, b, s) ((a) + ((b) - (a)) * (s))
#define map_linear(x, a, b, a2, b2) \
	interp(a2, b2, (float) fabs((x) - (a)) / (float) fabs((b) - (a)))

// range
#define inRange(x, lo, hi) ((x) >= (lo) && (x) <= (hi))
#define limit(x, lo, hi) (min(max(x, lo), hi))
#define wrap(x, lo, hi) \
	( \
		((x) < (lo)) ? \
		(x) + ((hi) - (lo)) : \
		(((x) > (hi)) ? (x) - ((hi) - (lo)) : (x)) \
	)
#define int_wrap(x, lo, hi) \
	( \
		((x) < (lo)) ? \
		(x) + ((hi) - (lo) + 1) : \
		(((x) > (hi)) ? (x) - ((hi) - (lo) + 1) : (x)) \
	)
#define incre(x, n) (x = int_wrap((x) + 1, 0, (n) - 1))
#define wrap_dist(a, b, lo, hi) \
	( \
		((float) fabs((a) - (b)) < ((hi) - (lo)) * 0.5f) ? \
		(float) fabs((a) - (b)) : ((hi) - (lo)) - (float) fabs((a) - (b)) \
	)
#define wrap_sgn(a, b, lo, hi) \
	( \
		( \
			((float) fabs((a) - (b)) < ((hi) - (lo)) * 0.5f) ? \
			(a) <= (b) : (a) > (b) \
		) * 2 - 1 \
	)

// trigonometry
#define toRad(x) ((x) * PI / 180)
#define toDeg(x) ((x) * 180 / PI)
#define acosEx(x) \
	( \
		((float) fabs(x) > 1 - EPSILON) ? \
		(((x) > 0) ? 0 : toRad(180)) : (float) acos(x) \
	)

// color
#define rgb(r, g, b) ((((long) (b)) << 16) | (((long) (g)) << 8) | ((long) (r)))
#define rgba(r, g, b, a) (((long) (a)) | (((long) rgb(r, g, b)) << 8))
#define getR(c) ((c) & 0xFF)
#define getG(c) (((c) >> 8) & 0xFF)
#define getB(c) (((c) >> 16) & 0xFF)
#define getA(c) (((c) >> 24) & 0xFF)

// probability
#define rnd() ((float) rand() / RAND_MAX)
#define rndEx(lo, hi) (rnd() * ((hi) - (lo)) + (lo))
#define permute(n, k) (fact(n) / fact((n) - (k)))
#define choose(n, k) (permute(n, k) / fact(k))

#endif