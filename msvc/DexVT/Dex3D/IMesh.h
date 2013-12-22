#ifndef H_IMESH
#define H_IMESH

#include "Vector.h"

class IMesh
{
public:
	int mVertCnt;
	int mFaceCnt;
	Vector mAbsMin, mAbsMax, mAbsMid, mMin, mMax, mDim;
	float mRadius;

	IMesh();
	~IMesh();
	virtual void resize(int vertCnt, int faceCnt) = 0;
	virtual Vector *getVertices() = 0;
	virtual void setVertex(int index, float x, float y, float z) = 0;
	virtual void setFace(int index, int a, int b, int c) = 0;
	virtual void setAnchor(int index, float x, float y) = 0;
};

#endif