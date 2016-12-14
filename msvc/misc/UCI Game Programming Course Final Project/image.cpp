#include "image.h"

image::image()
{
	/* data */
	mTexID[0] = -1;
	mTexID[1] = -1;

	/* attributes */
	mWidth = 0;
	mHeight = 0;
	mX = 0;
	mY = 0;
	mScaleX = 1;
	mScaleY = 1;
	mDepth = 0;
	mVisible = true;
}

image::~image()
{
	/* data */
	if (mTexID[0] != -1)
		glDeleteTextures(1, &(mTexID[0]));
	if (mTexID[1] != -1)
		glDeleteTextures(1, &(mTexID[1]));
}

void image::setParams(long *data, long width, long height, long *mask)
{
	long i;
	BYTE *pixels;

	image::~image();
	mWidth = width;
	mHeight = height;
	for (i = 0; i < ((mask == NULL) ? 1 : 2); i++)
	{
		glGenTextures(1, &(mTexID[i]));
		glBindTexture(GL_TEXTURE_2D, mTexID[i]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
		pixels = (BYTE *) ((i == 0) ? data : mask);
		gluBuild2DMipmaps(
			GL_TEXTURE_2D, 4,
			width, height,
			GL_RGBA, GL_UNSIGNED_BYTE, pixels
		);
	}
}

void image::move(long x, long y, float scaleX, float scaleY, float depth)
{
	mX = x;
	mY = y;
	mScaleX = scaleX;
	mScaleY = scaleY;
	mDepth = -depth;
}