#ifndef H_UTIL
#define H_UTIL

#include <stdlib.h>
#include <math.h>

#define NULL 0
#define BIG_NUMBER 65536
#define SMALL_NUMBER 0.000001f
#define HI_THRESH 1000
#define MID_THRESH 50
#define LO_THRESH 20
#define rand() ((float) rand() / RAND_MAX)
#define randEx(lower, upper) (rand() * (upper - lower) + lower)

template<class T>
inline void swap(T &a, T &b)
{
	T c;

	c = a;
	a = b;
	b = c;
}

template<class T>
inline T max2(T a, T b)
{
	return (a > b) ? a : b;
}

template<class T>
inline int sgn(T x)
{
	return (x == 0) ? 0 : ((x > 0) ? 1 : -1);
}

template<class T1, class T2>
inline float avg(T1 *array, T2 length)
{
	T2 i;
	T1 result;

	result = 0;
	for (i = 0; i < length; i++)
		result += array[i];
	result /= length;
	return result;
}

template<class T1, class T2>
inline T1 dist(T1 *vectA, T1 *vectB, T2 dimCnt)
{
	T2 i;
	T1 result;

	result = 0;
	for (i = 0; i < dimCnt; i++)
		result += (T1) pow(vectB[i] - vectA[i], 2);
	return result;
}

template<class T1, class T2>
inline void norm(T1 *array, T2 length)
{
	T2 i;
	T1 max;
	T1 min;
	T1 diff;

	max = -BIG_NUMBER;
	min = BIG_NUMBER;
	for (i = 0; i < length; i++)
	{
		if (array[i] > max)
			max = array[i];
		if (array[i] < min)
			min = array[i];
	}
	diff = max - min;
	if (diff != 0)
		for (i = 0; i < length; i++)
			array[i] = (array[i] - min) / diff;
	else
		for (i = 0; i < length; i++)
			array[i] = 0;
}

template<class T1, class T2>
inline void normEx(T1 *array, T2 rowSize, T2 colSize, T2 mode)
{
	T2 i;
	T2 j;
	T2 length;
	T1 *buffer;

	switch (mode)
	{
	case 0:
		length = rowSize * colSize;
		for (i = 0; i < length; i += rowSize)
			norm(&array[i], rowSize);
		break;
	case 1:
		buffer = new T1[colSize];
		for (i = 0; i < rowSize; i++)
		{
			for (j = 0; j < colSize; j++)
				buffer[j] = array[j * rowSize + i];
			norm(buffer, colSize);
			for (j = 0; j < colSize; j++)
				array[j * rowSize + i] = buffer[j];
		}
		delete []buffer;
	}
}

template<class T1, class T2>
inline void derive(T1 *array, T2 length)
{
	T2 i;

	for (i = length - 1; i >= 1; i--)
		array[i] -= array[i - 1];
	array[0] = 0;
}

#endif