#ifndef H_LIGHT
#define H_LIGHT

#include "misc.h"

class light : public object
{
public:
	/* attributes */
	long mColor;
	float mNear;
	float mFar;
	float mHotspot;
	float mFalloff;

	/* misc */
	bool mEnabled;

	light();
	~light();
};

#endif
