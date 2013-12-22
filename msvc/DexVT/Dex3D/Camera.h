#ifndef H_CAMERA
#define H_CAMERA

#include "PhysObj.h"
#include "Vector.h"
#include "Matrix.h"
#include "Transform.h"
#include "Face.h"
#include "TDexGL.h" // DEXGL_VIEW

class Camera : public PhysObj
{
private:
	Vector mTarget;
	float mWidth, mHeight, mAspect, mNear, mFar, mTanHalf;
	Vector mFrustObj[4], mFrustWrl[4];

	//=============================================================================
	void buildTrans();
	void buildProj();
	//=============================================================================
public:
	Matrix mProj;
	Vector mFrustum[4];

	Camera();
	~Camera();
	//=============================================================================
	void resize(float width, float height);
	void set(float near, float far, float fov);
	//=============================================================================
	void setTarget(Vector &v);
	void setSource(Vector &v);
	void orbit(Vector &origin, float radius, float lngAngle, float latAngle);
	//=============================================================================
	bool clipRect(Vector &v);
	bool clipRect(Face &face, Vector *v);
	bool clipFrust(Vector &v);
	//=============================================================================
	float shade(Vector &p);
	//=============================================================================
	void applyProj(Vector *r, Vector *v, int n);
	Matrix getPerspectView();
	//=============================================================================
	void apply(float *trans, DEXGL_VIEW funcView);
	//=============================================================================
};

#endif