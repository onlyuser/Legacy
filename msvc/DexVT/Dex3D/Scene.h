#ifndef H_SCENE
#define H_SCENE

#include "Vector.h"
#include "Mesh.h"
#include "Camera.h"
#include "Light.h"
#include "Texture.h"
#include "Font.h"
#include "Collection.h"
#include "GroupMgr.h"
#include "ISortable.h"

#define OGL_CVA

class SAPEdge : public ISortable
{
public:
	float *mPos;
	int mOwner;

	SAPEdge(float *pos, int owner);
	~SAPEdge();
	void refresh();
};

class Scene
{
private:
	Collection<SAPEdge *> mEdgeList[3];
	Collection<SAPEdge *, float> mPruneList[3];
	Collection<long, float> mPairTable[3];

	//=============================================================================
	void sortObjects();
	//=============================================================================
	void runSAP(AXIS::AXIS axis, bool init);
	//=============================================================================
public:
	GroupMgr mGroupMgr;
	Collection<Texture *> mTexList;
	Collection<Font *> mFontList;
	Camera *mCamera;
	Light *mLight;

	Scene();
	~Scene();
	//=============================================================================
	Mesh *sectPoly(Vector &p1, Vector &p2, float &s);
	Mesh *pick(float x, float y);
	//=============================================================================
	void lockSAP();
	void unlockSAP();
	void runSAP();
	//=============================================================================
	void update();
	void paint(
		DEXGL_TRI funcTri,
		DEXGL_TEXBIND funcTexBind, DEXGL_FONTPRINT funcFontPrint,
		DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
		DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
		DEXGL_MODE funcMode
		);
	//=============================================================================
};

#endif