#ifndef H_SCENE
#define H_SCENE

#include "GL/glut.h" /* glBegin() :: various */
#include "misc.h"
#include "mesh.h"
#include "camera.h"
#include "light.h"
#include "CUI/collide.h"
#include "CUI/rayTriSect.h"

class scene
{
protected:
	void readVertList(FILE *stream, long data);
	void readFaceList(FILE *stream, long data);
	short readShort(FILE *stream);
	long readLong(FILE *stream);
	char *readString(FILE *stream);
	long enterChunk(FILE *stream, long chunkID, long chunkEnd);
	void traceHier(mesh *pMesh);
	void drawSprites(float *vector, float fov);
	void drawHud();
	void drawImage(image *pImage);
	void resetBrush();
	void begin2d();
	void end2d();

public:
	/* data */
	float *mNullVect;
	float *mFogVect;
	List<mesh *> mMeshList;
	List<camera *> mCameraList;
	List<light *> mLightList;
	List<image *> mHudList;
	List<material *> mMatList;
	float *mDepthKey;
	mesh **mDepthPtr;
	long *mPixel;
	bool *mLightArray;

	/* attributes */
	long mSprCnt;
	long mWidth;
	long mHeight;
	bool mWireframe;
	bool mDblSided;
	bool mShaded;
	bool mSmoothed;
	bool mTexMapped;
	bool mFogged;
	float mFogRatio;
	long mTally;
	bool GL_EXT_CVA;

	scene(long width, long height, long maxSprCnt);
	~scene();

	long getNextLight();
	void setDrawMode(long mode);
	void setFilter(long opCode);
	void setFog(long color, float ratio);

	void addParticles(float *origin, float *angle, long cnt, long color, float size, float speed, float spread, long ticks);
	long addGeo(float radius, long iters);
	long addOcta(float radius);
	long addTetra(float radius);
	long addRamp(float width, float height, float length);
	long addBox(float width, float height, float length);
	long load3ds(char *filename, long index);
	long *loadBmp(char *filename, long &width, long &height);
	void loadMatLib(char *filename);
	long loadPak(char *filename, char *path);

	void lockScene();
	void getAvgColor(float *result);
	void renderRad(long data);
	void shadeMesh(mesh *pMesh, light *pLight);
	long renderEx(long data);
	long render(long data, bool firstz, bool final);
	void drawTree(camera *pCamera, mesh *pMesh, treeNode *pTreeNode);
	inline void drawFace(mesh *pMesh, face *pFace);
	inline void drawBillboard();
	void update();
	void reset();

	long addMesh(long vertCnt, long faceCnt);
	long addCamera();
	long addLight();
	long addHud();

	void remMesh(long data);
	void remCamera(long data);
	void remLight(long data);
	void remHud(long data);

	void enableMesh(long data, bool value);
	void enableLight(long data, bool value);
	void enableHud(long data, bool value);

	void setMesh(long data, long ambient, long diffuse, long specular, long emission, float shininess);
	void setCamera(long data, float fov, float aspect, float pNear, float pFar, float range);
	void setLight(long data, long ambient, long diffuse, long specular);
	void setTexture(long data, char *filename, long mapDir, bool skybox);
	void setSprite(long data, char *filename, char *pMask, float scale);
	void setHud(long data, char *filename, char *pMask);

	void moveMesh(long data, long opCode, float a, float b, float c);
	void moveCamera(long data, long opCode, float a, float b, float c);
	void moveLight(long data, float x, float y, float z);
	void moveHud(long data, long x, long y, float scaleX, float scaleY);

	void getVector(long data, long opCode, float &a, float &b, float &c);

	void runNPC(float movSpd, float rotSpd);
	long findWaypoint(long data);
	long collideMesh(long data);
	float beam(float *origin, float *dir, float dist);
	bool occluded(float *vectA, float *vectB);
	void setPartSrc(long data, float freq, long color, float size, float speed, float spread, long ticks);
	void setMaterial(long data, char *name);
	void setMotion(long data, long style, bool collide);
	void setMaxSpeed(long data, float movSpd, float rotSpd);
	void setMeshName(long data, char *name, char *tag);
	long findMesh(char *name);
	void setVertex(long data, long index, float x, float y, float z);
	void setFace(long data, long index, long a, long b, long c);
	void setAxis(long data, float x, float y, float z);
	void centAxis(long data);
	void imprintMesh(long data);
	void setSpan(long data, float x, float y, float z);
	void setBox(long data, float x, float y, float z);
	void alignMesh(long data, float pos, long opCode);
	void flipFaces(long data);
	void normalize(long data, float radius);
	void mergeMesh(long data, long other);
	void tessByFace(long data, long iters);
	void tessByEdge(long data, long iters);
	void tessByColor(long data, float maxRatio);
	void lockMesh(long data);
	void partMesh(long data, long minThresh);
	void setLife(long data, long ticks);
	void linkMesh(long child, long parent);
	void unlinkMesh(long data);

	void orbitCamera(long data, float x, float y, float z, float radius, float lngAngle, float latAngle);
	void lookAt(long data, float x, float y, float z);
	void setBank(long data, float offset);
};

#endif