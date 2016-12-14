#ifndef H_MESH
#define H_MESH

#include "misc.h"

class mesh : public object
{
protected:
	void calcNormal();
	void calcBox();
	void calcAnchor();
	void calcRadial();

public:
	/* data */
	float **mVertex;
	float **mNormal;
	float **mAnchor;
	float **mColor;
	float **mBuffer;
	float **mShine;
	face *mFace;
	float **mBox;
	float **mBoxEx;
	float **mAttrib;
	image mTexture;
	image mSprite;
	partSys mPartSys;
	treeNode *mTreeNode;
	char *mName;
	char *mTag;
	float *mBulkVertex;
	float *mBulkNormal;
	float *mBulkAnchor;
	long *mBulkFace;

	/* attributes */
	long mVertCnt;
	long mFaceCnt;
	float mRadius;
	long mAmbient;
	long mDiffuse;
	long mSpecular;
	long mEmission;
	float mShininess;
	long mMapDir;
	bool mSkyBox;
	bool mVisible;
	bool mInFrust;
	mesh *mNext;

	mesh(long vertCnt, long faceCnt);
	~mesh();
	void update(float **pVertex, face *pFace, long pVertCnt, long pFaceCnt, bool first, bool final);
	void setParams(long ambient, long diffuse, long specular, long emission, float shininess);
	void refresh();
	void setName(char *name, char *tag);
	void setVertex(long index, float x, float y, float z);
	void setFace(long index, long a, long b, long c);
	void setColor(long color);
	void populate();
	void lock();
	void partition(long minThresh);
	void setTexture(long *texture, long width, long height, long mapDir, bool skybox);
	void setSprite(long *sprite, long width, long height, long *mask, float scale);
	void setAxis(float *axis);
	void centAxis();
	void imprint();
	void setSpan(float *vector);
	void setBox(float *vector);
	void align(float pos, long opCode);
	void flipFaces();
	void normalize(float radius);
	void merge(mesh *pMesh);
	void tessByFace(long iters);
	void tessByEdge(long iters);
	void tessByColor(float maxRatio);
	void applyTrans();
};

#endif