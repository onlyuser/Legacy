#ifndef H_MESH
#define H_MESH

#include <math.h> // pow()
#include "IMesh.h"
#include "PhysObj.h"
#include "ISortable.h"
#include "Vector.h"
#include "Face.h"
#include "Camera.h"
#include "HullPrim.h"
#include "Color.h"
#include "Texture.h"
#include "Font.h"
#include "TDexGL.h" // DEXGL_TRI
#include "TDex3D.h" // TRANS::TRANS
#include "Util.h" // min(), max()
#include "Collection.h"

namespace GROUP
{
	enum GROUP
	{
		SORT,
		SOLID,
		WIRE,
		SPRITE_SPHERE,
		SPRITE_CYLNDR,
		BLEND,
		ORTHO
	};
};

class Mesh : public IMesh, public PhysObj, public ISortable
{
private:
	Vector *mVertexObj, *mVertexWrl, *mVertexCam, *mVertexMap;
	Collection<Face *> mFaceList;
	Vector mBoxObj[8], mBoxWrl[8];

	//=============================================================================
	void buildTrans();
	void updateClient(Camera &camera);
	//=============================================================================
public:
	long mColor;
	Texture *mTexture;
	Font *mFont;
	float mAlpha;
	GROUP::GROUP mGroup;
	std::string mText;
	bool mNoClip;
	HullPrim *mHull;
	bool mCollide;

	Mesh();
	~Mesh();
	//=============================================================================
	void resize(int vertCnt, int faceCnt);
	void copy(IMesh *mesh);
	//=============================================================================
	Vector *getVertices();
	//=============================================================================
	void setVertex(int index, float x, float y, float z);
	void setFace(int index, int a, int b, int c);
	void setAnchor(int index, float x, float y);
	//=============================================================================
	void setAxis(Vector &v);
	void alignAxis(DIR::DIR dir);
	void invert();
	void imprint();
	void normalize();
	void spherize(float radius);
	//=============================================================================
	Vector collide(Mesh *mesh, Vector &normal);
	//=============================================================================
	float sectRay(Vector &p1, Vector &p2);
	int pick(Camera &camera, float x, float y);
	//=============================================================================
	void paint(Camera &camera, DEXGL_TRI funcTri);
	//=============================================================================
	void lock(DEXGL_LISTGEN funcListGen);
	void unlock(DEXGL_LISTKILL funcListKill);
	//=============================================================================
	void apply(float *trans, DEXGL_BRUSH funcBrush, DEXGL_TEXBIND funcTexBind, DEXGL_MODEL funcModel, DEXGL_FONTPRINT funcFontPrint);
	//=============================================================================
};

#endif