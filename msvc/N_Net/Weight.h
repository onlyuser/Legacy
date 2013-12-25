#ifndef H_WEIGHT
#define H_WEIGHT

#include <stdlib.h> // rand(), RAND_MAX
#include <stdio.h> // sprintf()

class Weight
{
public:
	int mIndex;

	float mValue;
	float mDelta;

	Weight();
	~Weight();
	void reset();
	void randomize();
	void print(char *, int &);
};

#endif
