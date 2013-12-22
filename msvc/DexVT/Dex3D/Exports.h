#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h> // WINAPI
#include "Dex3D.h"
#include "Vector.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static Dex3D *mDex3D;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI Dex3D_regUsrFnc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI Dex3D_sum(int a, int b);
char *WINAPI Dex3D_echo(char *text);

//=============================================================================
void WINAPI Dex3D_load(float width, float height);
void WINAPI Dex3D_unload();
//=============================================================================
void WINAPI Dex3D_regDrwFnc(
	char *library,
	char *entryTri,
	char *entryListGen, char *entryListKill,
	char *entryTexGen, char *entryTexKill, char *entryTexBind,
	char *entryView, char *entryModel,
	char *entryLight, char *entryBrush, char *entryBlend,
	char *entryWire
	);
void WINAPI Dex3D_regDrwFnc(
	DEXGL_TRI funcTri,
	DEXGL_LISTGEN funcListGen, DEXGL_LISTKILL funcListKill,
	DEXGL_TEXGEN funcTexGen, DEXGL_TEXKILL funcTexKill, DEXGL_TEXBIND funcTexBind,
	DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
	DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
	DEXGL_MODE funcMode
	);
//=============================================================================
void WINAPI Dex3D_setCamera(float pNear, float pFar, float fov);
void WINAPI Dex3D_setLight(long ambient, long diffuse, long specular);
void WINAPI Dex3D_resize(float width, float height);
//=============================================================================
void WINAPI Dex3D_moveTo(float x, float y, float z);
void WINAPI Dex3D_lookAt(float x, float y, float z);
void WINAPI Dex3D_lookFrom(float x, float y, float z);
void WINAPI Dex3D_orbit(float x, float y, float z, float radius, float lngAngle, float latAngle);
//=============================================================================
void WINAPI Dex3D_remMesh(char *id);
void WINAPI Dex3D_clear();
void WINAPI Dex3D_relock();
//=============================================================================
void WINAPI Dex3D_copyMesh(char *id, char *id2);
void WINAPI Dex3D_load3ds(char *id, char *filename, int index);
void WINAPI Dex3D_addBox(char *id, float width, float height, float length);
void WINAPI Dex3D_addGrid(char *id, float width, float length, int gridX, int gridZ);
void WINAPI Dex3D_addHud(char *id, float width, float height);
void WINAPI Dex3D_addSprite(char *id, float width, float height, bool treeStyle);
void WINAPI Dex3D_addCylndr(char *id, float radius, float height, int step);
void WINAPI Dex3D_addCone(char *id, float radius, float height, int step);
void WINAPI Dex3D_addSphere(char *id, float radius, int stepLng, int stepLat);
void WINAPI Dex3D_addHemis(char *id, float radius, int stepLng, int stepLat);
void WINAPI Dex3D_addCapsul(char *id, float radius, float height, int stepLng, int stepLat);
void WINAPI Dex3D_addTorus(char *id, float radMajor, float radMinor, int stepMajor, int stepMinor);
void WINAPI Dex3D_addOcta(char *id, float radius);
void WINAPI Dex3D_addTetra(char *id, float radius);
//=============================================================================
void WINAPI Dex3D_modify(char *id, int trans, float x, float y, float z);
void WINAPI Dex3D_query(char *id, int trans, float &x, float &y, float &z);
void WINAPI Dex3D_pointAt(char *id, float x, float y, float z);
void WINAPI Dex3D_rotArb(
	char *id,
	float posX, float posY, float posZ,
	float dirX, float dirY, float dirZ,
	float angle
	);
void WINAPI Dex3D_applyImp(char *id, float mass, float inertia, float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3);
void WINAPI Dex3D_link(char *id, char *id2);
//=============================================================================
char *WINAPI Dex3D_sectPoly(float x1, float y1, float z1, float x2, float y2, float z2, float &s);
char *WINAPI Dex3D_pick(float x, float y);
//=============================================================================
void WINAPI Dex3D_setVertex(char *id, int index, float x, float y, float z);
void WINAPI Dex3D_relockMsh(char *id);
void WINAPI Dex3D_setAxis(char *id, float x, float y, float z);
void WINAPI Dex3D_alignAxis(char *id, int dir);
void WINAPI Dex3D_invert(char *id);
void WINAPI Dex3D_imprint(char *id);
void WINAPI Dex3D_normalize(char *id);
void WINAPI Dex3D_setHgtMap(char *id, char *filename, float height);
void WINAPI Dex3D_setColor(char *id, long color);
//=============================================================================
void WINAPI Dex3D_setTexMap(char *id, char *filename, char *maskFile, long maskColor, int dir);
void WINAPI Dex3D_setFont(char *id, char *name, int size, bool bold, bool italic, bool underline, bool strikeOut);
//=============================================================================
void WINAPI Dex3D_setSolid(char *id);
void WINAPI Dex3D_setWire(char *id);
void WINAPI Dex3D_setAlpha(char *id, float alpha);
//=============================================================================
void WINAPI Dex3D_setAttrib(char *id, long ambient, long diffuse, long specular, long emission, float shininess);
void WINAPI Dex3D_setText(char *id, char *text);
void WINAPI Dex3D_setVis(char *id, bool value);
void WINAPI Dex3D_setNoClip(char *id, bool value);
void WINAPI Dex3D_setPhys(char *id, float mass, float inertia, float bounce, float friction);
//=============================================================================
void WINAPI Dex3D_update();
void WINAPI Dex3D_paint();
//=============================================================================

#endif