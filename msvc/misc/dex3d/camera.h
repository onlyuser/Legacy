#ifndef H_CAMERA
#define H_CAMERA

#include "misc.h"

class camera : public object
{
private:
	/* data */
	float **mView;

public:
	/* attributes */
	float mFov;
	float mNear;
	float mFar;
	bool mPerspect;
	float mZoom;
	bool mReflect;
	bool mFog;

	/* misc */
	long mWidth;
	long mHeight;

	camera();
	~camera();
	void setSize(long, long);
	void orbit(float *, float, float, float);
	float **project(float **, long);
	float **applyTrans(float **, long);
	void buildTrans();
};

#endif
