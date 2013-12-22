#include "View.h"

View::View(float width, float height)
{
	this->resize(width, height);
}

View::~View()
{
}

void View::resize(float width, float height)
{
	mWidth = width;
	mHeight = height;
	mAspect = width / height;
}

bool View::clip(Vector &v)
{
	return v.x < 0 || v.x >= mWidth || v.y < 0 || v.y >= mHeight;
}