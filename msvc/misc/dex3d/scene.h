#ifndef H_SCENE
#define H_SCENE

#include "misc.h"
#include "surface.h"
#include "mesh.h"
#include "camera.h"
#include "light.h"
#include "triangle.h"

class scene
{
private:
	/* data */
	float **mVertex;
	float **cVertex;
	float **sVertex;
	long *mVertColor;
	face **mFacePtr;
	float *mFaceDepth;

	/* misc */
	long mVertCount;
	long mFaceCount;
	long mVisFaceCount;

	void refresh();
	float **applyTrans();
	void forceHierarchy();
	void cullFaces(long);
	long shadeFace(float *, float *, float *, long, float, long);
	void calcGradients(long);
	void drawFaces(surface *, long);

	void fixMesh(long);
	void fixVertices(long);
	void fixFaces(long);

	void readVertList(FILE *, long);
	void readFaceList(FILE *, long);
	short readShort(FILE *);
	long readLong(FILE *);
	char *readString(FILE *);
	long enterChunk(FILE *, long, long);

public:
	/* data */
	sList<mesh *> mMeshList;
	sList<camera *> mCameraList;
	sList<light *> mLightList;
	long mDrawMode;
	bool mDblSided;

	scene();
	~scene();
	long render(long, surface *);
	void reset();

	long addMesh(long, long);
	long addCamera();
	long addLight();

	void remMesh(long);
	void remCamera(long);
	void remLight(long);

	void setMesh(long, bool);
	void setCamera(long, float, float, float, bool, float, bool, bool);
	void setLight(long, long, float, float);

	void moveMesh(long, long, float, float, float);
	void moveCamera(long, long, float, float, float);
	void moveLight(long, float, float, float);

	void setVertex(long, long, float, float, float);
	void setFace(long, long, long, long, long);
	void setColor(long, long, long, float);
	void setAxis(long, float, float, float);

	void linkMesh(long, long);
	void centerAxis(long);
	void flipFaces(long);
	void orbitCamera(long, float, float, float, float, float, float);

	long addPoly(float, long, long);
	long load(char *, long);
	void save(char *, long);
	long load3ds(char *, long);
};

#endif
