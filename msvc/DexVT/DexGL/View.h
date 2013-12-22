#ifndef H_VIEW
#define H_VIEW

#include "Vector.h"

class View
{
protected:
	float mWidth;
	float mHeight;
	float mAspect;
public:
	View(float width, float height);
	~View();
	virtual void resize(float width, float height);
	virtual bool clip(Vector &v);
};

#endif