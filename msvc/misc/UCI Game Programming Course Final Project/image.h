#ifndef H_IMAGE
#define H_IMAGE

#include "GL/glut.h"
#include "misc.h"

class image
{
public:
	/* data */
	unsigned int mTexID[2];

	/* attributes */
	long mWidth;
	long mHeight;
	long mX;
	long mY;
	float mScaleX;
	float mScaleY;
	float mDepth;
	bool mVisible;

	image();
	~image();
	void setParams(long *data, long width, long height, long *mask);
	void move(long x, long y, float scaleX, float scaleY, float depth);
};

#endif