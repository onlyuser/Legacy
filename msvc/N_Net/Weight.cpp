#include "Weight.h"

Weight::Weight()
{
}

Weight::~Weight()
{
}

void Weight::reset()
{
	mDelta = 0;
}

void Weight::randomize()
{
	mValue = -1 + 2 * ((float) rand() / RAND_MAX);
}

void Weight::print(char *string, int &byte)
{
	byte += sprintf(&string[byte], "w%d", mIndex);
	byte += sprintf(&string[byte], "[%.2f]", mValue);
}
