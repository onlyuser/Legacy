#ifndef H_CAMERA
#define H_CAMERA

#include "misc.h"

class camera : public object
{
public:
	/* data */
	float **mTransEx;
	float **mProj;
	float *mTarget;
	float **mFrust;
	float **mFrustEx;
	float **mNorm;
	float **mNormEx;

	/* attributes */
	long mWidth;
	long mHeight;
	float mFov;
	float mAspect;
	float mNear;
	float mFar;
	float mRange;

	camera(long width, long height);
	~camera();
	void setParams(float fov, float aspect, float pNear, float pFar, float range);
	void calcFrust();
	bool canSee(float **box);
	void orbit(float *origin, float radius, float lngAngle, float latAngle);
	void lookAt(float *vector);
	void setVector(float *origin, float *vector);
	void setBank(float offset);
	void buildTrans();
	void applyTrans();
};

#endif