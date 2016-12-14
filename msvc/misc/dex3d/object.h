#ifndef H_OBJECT
#define H_OBJECT

#include "misc.h"

class object
{
protected:
	float **mTransform;

public:
	float *mOrigin;
	float *mAngle;
	float *mScale;

	object *mParent;
	bool mChanged;

	object();
	~object();
	float **applyTrans(float **, long, bool);
	void buildTransEx(bool);
};

#endif
