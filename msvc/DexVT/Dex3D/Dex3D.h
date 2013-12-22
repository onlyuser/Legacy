#ifndef H_DEX3D
#define H_DEX3D

#include <windows.h> // LoadLibrary, FreeLibrary
#include "Scene.h"
#include "Polygon.h"
#include "File3ds.h"
#include "TDexGL.h" // DEXGL_TRI
#include "TDex3D.h" // TRANS::TRANS
#include "CritSection.h"
#include "String.h"

class Dex3D
{
private:
	HINSTANCE mInstLib;
	DEXGL_TRI mFuncTri;
	DEXGL_LISTGEN mFuncListGen;
	DEXGL_LISTKILL mFuncListKill;
	DEXGL_TEXGEN mFuncTexGen;
	DEXGL_TEXKILL mFuncTexKill;
	DEXGL_TEXBIND mFuncTexBind;
	DEXGL_FONTGEN mFuncFontGen;
	DEXGL_FONTKILL mFuncFontKill;
	DEXGL_FONTPRINT mFuncFontPrint;
	DEXGL_VIEW mFuncView;
	DEXGL_MODEL mFuncModel;
	DEXGL_LIGHT mFuncLight;
	DEXGL_BRUSH mFuncBrush;
	DEXGL_BLEND mFuncBlend;
	DEXGL_MODE mFuncMode;
	Scene *mScene;
	CritSection mCritSection;

	//=============================================================================
	// mesh management
	void addMesh(std::string id, Mesh *mesh);
	void remMesh(Mesh *mesh);
	Mesh *getMesh(std::string id);
	//=============================================================================
	// mesh build
	void addPanel(std::string id, float width, float height);
	//=============================================================================
	// object modify
	PhysObj *getObject(std::string id);
	//=============================================================================
	// mesh attribute
	void setSprite(std::string id, bool treeStyle);
	void setOrtho(std::string id);
	//=============================================================================
public:
	//=============================================================================
	Dex3D();
	~Dex3D();
	//=============================================================================
	// external api
	void regDrwFnc(
		char *library,
		char *entryTri,
		char *entryListGen, char *entryListKill,
		char *entryTexGen, char *entryTexKill, char *entryTexBind,
		char *entryFontGen, char *entryFontKill, char *entryPrint,
		char *entryView, char *entryModel,
		char *entryLight, char *entryBrush, char *entryBlend,
		char *entryMode
		);
	void regDrwFnc(
		DEXGL_TRI funcTri,
		DEXGL_LISTGEN funcListGen, DEXGL_LISTKILL funcListKill,
		DEXGL_TEXGEN funcTexGen, DEXGL_TEXKILL funcTexKill, DEXGL_TEXBIND funcTexBind,
		DEXGL_FONTGEN funcFontGen, DEXGL_FONTKILL funcFontKill, DEXGL_FONTPRINT funcFontPrint,
		DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
		DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
		DEXGL_MODE funcMode
		);
	//=============================================================================
	// scene config
	void setCamera(float pNear, float pFar, float fov);
	void setLight(long ambient, long diffuse, long specular);
	void resize(float width, float height);
	//=============================================================================
	// camera modify
	void moveTo(Vector &v);
	void lookAt(Vector &v);
	void lookFrom(Vector &v);
	void orbit(Vector &v, float radius, float lngAngle, float latAngle);
	//=============================================================================
	// mesh management
	void remMesh(std::string id);
	void clear();
	void relock();
	//=============================================================================
	// mesh build
	void copyMesh(std::string id, std::string id2);
	void load3ds(std::string id, std::string filename, int index);
	void addBox(std::string id, float width, float height, float length);
	void addGrid(std::string id, float width, float length, int gridX, int gridZ);
	void addSprite(std::string id, float width, float length, bool treeStyle);
	void addHud(std::string id, float width, float length);
	void addCylndr(std::string id, float radius, float height, int step);
	void addCone(std::string id, float radius, float height, int step);
	void addSphere(std::string id, float radius, int stepLng, int stepLat);
	void addHemis(std::string id, float radius, int stepLng, int stepLat);
	void addCapsul(std::string id, float radius, float height, int stepLng, int stepLat);
	void addTorus(std::string id, float radMajor, float radMinor, int stepMajor, int stepMinor);
	void addOcta(std::string id, float radius);
	void addTetra(std::string id, float radius);
	//=============================================================================
	// object modify
	void modify(std::string id, TRANS::TRANS trans, Vector &v);
	void query(std::string id, TRANS::TRANS trans, float &x, float &y, float &z);
	void pointAt(std::string id, Vector &v);
	void rotArb(std::string id, Vector &pos, Vector &dir, float angle);
	void applyImp(std::string id, float mass, float inertia, Vector &velocity, Vector &contact, Vector &normal);
	void link(std::string id, std::string id2);
	//=============================================================================
	// mesh pick
	std::string sectPoly(Vector &v1, Vector &v2, float &s);
	std::string pick(float x, float y);
	//=============================================================================
	// mesh vertex modify
	void setVertex(std::string id, int index, float x, float y, float z);
	void relockMsh(std::string id);
	void setAxis(std::string id, Vector &v);
	void alignAxis(std::string id, DIR::DIR dir);
	void invert(std::string id);
	void imprint(std::string id);
	void normalize(std::string id);
	void setHgtMap(std::string id, std::string filename, float height);
	void setColor(std::string id, long color);
	void setMap(std::string id, DIR::DIR dir);
	//=============================================================================
	// mesh resource
	void setTex(std::string id, std::string filename, std::string maskFile, long maskColor, bool mipmap);
	void setFont(std::string id, std::string name, int size, bool bold, bool italic, bool underline, bool strikeOut);
	//=============================================================================
	// mesh shading group
	void setSolid(std::string id);
	void setWire(std::string id);
	void setAlpha(std::string id, float alpha);
	//=============================================================================
	// mesh attribute
	void setAttrib(std::string id, long ambient, long diffuse, long specular, long emission, float shininess);
	void setText(std::string id, std::string text);
	void setVis(std::string id, bool value);
	void setNoClip(std::string id, bool value);
	void setPhys(std::string id, float mass, float inertia, float bounce, float friction);
	//=============================================================================
	// scene refresh
	void update();
	void paint();
	//=============================================================================
};

#endif