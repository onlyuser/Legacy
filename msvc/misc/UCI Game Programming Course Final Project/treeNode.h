#ifndef H_TREENODE
#define H_TREENODE

#include "misc.h"

class treeNode
{
public:
	float **mBox;
	treeNode **mChild;
	face **mFace;
	long mFaceCnt;
	bool mLeaf;
	bool mInFrust;

	treeNode(face *pFace, bool *dirty, long faceCnt, float **vertex, float *min, float *max, long minThresh);
	~treeNode();
};

#endif