#ifndef H_MESH
#define H_MESH

#include "misc.h"

class mesh : public object
{
public:
	/* data */
	float **mVertex;
	face *mFace;

	/* misc */
	long mVertCount;
	long mFaceCount;
	long mBase;
	bool mVisible;

	mesh(long, long);
	~mesh();
	void setAxis(float *);
	void centerAxis();
	float **applyTrans();
	void buildTrans();
};

#endif
