#ifndef H_OBJECT
#define H_OBJECT

#include "ITagged.h"
#include "Vector.h"
#include "Matrix.h"
#include "Transform.h"
#include "TDex3D.h" // TRANS::TRANS
#include "Collection.h"
#include "Exception.h"

#define MAX_WRAPANGLE mMaxWrapAngle
#define MIN_WRAPANGLE mMinWrapAngle

static Vector mMaxWrapAngle = UNIT_VECTOR * toRad(180);
static Vector mMinWrapAngle = UNIT_VECTOR * toRad(-180);

class Object : public ITagged
{
private:
	Vector mScale;
	Vector mMaskOrigin, mMaskAngle, mMaskScale;
	Vector mMinCapAngle, mMaxCapAngle;
	Vector mAbsFront, mAbsLeft, mAbsTop;
	Collection<Object *> mChildList;
	Object *mParent;

	//=============================================================================
	void transArb(Matrix &trans, bool local);
	//=============================================================================
protected:
	Vector mOrigin, mAngle;
	Vector mAbsOrigin, mTemp;

	//=============================================================================
	virtual void buildTrans();
	//=============================================================================
	void applyTrans(Vector *r, Vector *v, int n);
	//=============================================================================
public:
	Matrix mTrans;

	Object();
	~Object();
	//=============================================================================
	virtual void reset();
	virtual void modify(TRANS::TRANS trans, Vector &v);
	virtual Vector &query(TRANS::TRANS trans);
	//=============================================================================
	virtual void pointAt(Vector &v);
	void rotArb(Vector &pos, Vector &dir, float angle);
	//=============================================================================
	void link(Object *parent);
	void unlink();
	//=============================================================================
};

#endif