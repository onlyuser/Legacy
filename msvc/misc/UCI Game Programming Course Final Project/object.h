#ifndef H_OBJECT
#define H_OBJECT

#include "misc.h"

class object
{
public:
	/* data */
	List<object *> mChildList;
	float **mTrans;
	float *mOrigin;
	float *mOriginEx;
	float *mAngle;
	float *mScale;

	/* physics */
	float *mPosVel;
	float *mAngVel;
	float *mPosAcc;
	float *mAngAcc;
	float mMovSpdMax;
	float mRotSpdMax;
	long mStyle;
	bool mCollide;
	long mTicks;
	float *mTarget;

	/* attributes */
	object *mParent;
	bool mChanged;

	object();
	~object();
	void move(long opCode, float *vector);
	void getVector(long opCode, float *vector);
	void setMotion(long style, bool collide);
	void goFwd(float dist);
	void setMaxSpeed(float movSpd, float rotSpd);
	void setLife(long ticks);
	void update();
	void applyHier();
	void link(object *pObj);
	void unlink();
	void unlinkAll();
	void pointAt(float *vector);
	void buildTrans();
	void applyTrans(float **result, float **vertex, long vertCnt, bool doProj, float **proj);
};

#endif