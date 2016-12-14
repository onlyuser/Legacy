#include "light.h"

light::light()
{
	/* attributes */
	mColor = colorNull();
	mNear = 1;
	mFar = 600;
	mHotspot = toRadian(15);
	mFalloff = toRadian(60);

	/* misc */
	mEnabled = true;
}

light::~light()
{
}
