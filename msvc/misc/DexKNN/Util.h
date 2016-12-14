#ifndef H_UTIL
#define H_UTIL

#include <functional> // std::binary_function
#include <stdlib.h> // rand()
#include <math.h> // fabs()
#include <vector> // std::vector
#include <stack> // std::stack
#include <queue> // std::queue

#define BIG_NUMBER 65535
#define EPSILON 0.0001f
#define PI 3.1415926535897932f

// functor
template<class T1, class T2> class TBinOp :
	public std::binary_function<T1, T1, T2>
	{public: virtual T2 operator()(T1 a, T1 b) const = 0;};
template<class T1, class T2> class TUnaryOp :
	public std::unary_function<T1, T2>
	{public: virtual T2 operator()(T1 x) const = 0;};
template<class T> class TCompare : public TBinOp<T, bool>
	{public: using TBinOp<T, bool>::operator();};

// useful misc
namespace std
{
	struct kill
	{
		template <class T>
		void operator()(T* p)
			{delete p;}
	};
	template <class T>
	void iota(T first, T last, int base)
	{
		int cnt = base;
		for (T p = first; p != last; p++)
			*p = cnt++;
	}
	template <class T>
	std::vector<T> gen_permute(int size)
	{
		std::vector<T> perm(size);
		std::iota(perm.begin(), perm.end(), 0);
		std::random_shuffle(perm.begin(), perm.end());
		return perm;
	}
}

// recursive logic
template<class T> int fact(T n)
	{return (n <= 1) ? 1 : fact(n - 1) * n;}

// logic
#ifndef min
	#define min(a, b) (((a) < (b)) ? (a) : (b))
#endif
#ifndef max
	#define max(a, b) (((a) > (b)) ? (a) : (b))
#endif
#define sgn(x) (!(x) ? 0 : (((x) > 0) ? 1 : -1))
#define safeDiv(a, b, c) ((b > EPSILON) ? (a) / (b) : (c))
#define inv(a) (safeDiv(1, a, BIG_NUMBER))

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
#define toAng(dx, dy) \
	(!(dx) ? \
		(((dy) > 0) ? PI * 0.5 : -PI * 0.5) : \
		(((dx) > 0) ? \
			atan((dy) / (dx)) : \
			atan((dy) / (dx)) + PI \
		) \
	)

// binary
#define getBit(x, i) ((x >> i) & 0x1)

// color
#define rgb(r, g, b) \
	((((long) (b)) << 16) | (((long) (g)) << 8) | ((long) (r)))
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
namespace std
{
	template<class T>
	T rndG(int rndCnt)
	{
		T sum = 0;
		for (int i = 0; i < rndCnt; i++)
			sum += rnd();
		return sum / rndCnt;
	}
	template<class T>
	T rndG2(int rndCnt, T lo, T hi)
		{return map_linear(rndG(rndCnt), 0, 1, lo, hi);}
}

// popping
namespace std
{
	template<class T>
	T pop(std::vector<T> &pList)
	{
		T tmp = pList.back();
		pList.pop_back();
		return tmp;
	}
	template<class T>
	T pop(std::stack<T> &pStack)
	{
		T tmp = pStack.top();
		pStack.pop();
		return tmp;
	}
	template<class T>
	T pop(std::queue<T> &pQueue)
	{
		T tmp = pQueue.front();
		pQueue.pop();
		return tmp;
	}
}

// flushing
namespace std
{
	template<class T>
	void flush(std::vector<T> &pList)
	{
		while (!pList.empty())
			pList.pop_back();
	}
	template<class T>
	void flush(std::stack<T> &pStack)
	{
		while (!pStack.empty())
			pStack.pop();
	}
	template<class T>
	void flush(std::queue<T> &pQueue)
	{
		while (!pQueue.empty())
			pQueue.pop();
	}
}

#endif