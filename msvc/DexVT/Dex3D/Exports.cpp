#include "Exports.h"

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason)
	{
		case DLL_PROCESS_ATTACH:
			dll_init();
			break;
		case DLL_PROCESS_DETACH:
			dll_destroy();
	}
	return true;
}

void dll_init()
{
}

void dll_destroy()
{
}

void WINAPI Dex3D_regUsrFnc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI Dex3D_sum(int a, int b)
{
	return a + b;
}

char *WINAPI Dex3D_echo(char *text)
{
	return text;
}

//=============================================================================

void WINAPI Dex3D_load()
{
	mDex3D = new Dex3D();
}

void WINAPI Dex3D_unload()
{
	delete mDex3D;
}

//=============================================================================

void WINAPI Dex3D_regDrwFncEx(
	char *library,
	char *entryTri,
	char *entryListGen, char *entryListKill,
	char *entryTexGen, char *entryTexKill, char *entryTexBind,
	char *entryFontGen, char *entryFontKill, char *entryPrint,
	char *entryView, char *entryModel,
	char *entryLight, char *entryBrush, char *entryBlend,
	char *entryWire
	)
{
	mDex3D->regDrwFnc(
		library,
		entryTri,
		entryListGen, entryListKill,
		entryTexGen, entryTexKill, entryTexBind,
		entryFontGen, entryFontKill, entryPrint,
		entryView, entryModel,
		entryLight, entryBrush, entryBlend,
		entryWire
		);
}

void WINAPI Dex3D_regDrwFnc(
	DEXGL_TRI funcTri,
	DEXGL_LISTGEN funcListGen, DEXGL_LISTKILL funcListKill,
	DEXGL_TEXGEN funcTexGen, DEXGL_TEXKILL funcTexKill, DEXGL_TEXBIND funcTexBind,
	DEXGL_FONTGEN funcFontGen, DEXGL_FONTKILL funcFontKill, DEXGL_FONTPRINT funcFontPrint,
	DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
	DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
	DEXGL_MODE funcMode
	)
{
	mDex3D->regDrwFnc(
		funcTri,
		funcListGen, funcListKill,
		funcTexGen, funcTexKill, funcTexBind,
		funcFontGen, funcFontKill, funcFontPrint,
		funcView, funcModel,
		funcLight, funcBrush, funcBlend,
		funcMode
		);
}

//=============================================================================

void WINAPI Dex3D_setCamera(float pNear, float pFar, float fov)
{
	mDex3D->setCamera(pNear, pFar, fov);
}

void WINAPI Dex3D_setLight(long ambient, long diffuse, long specular)
{
	mDex3D->setLight(ambient, diffuse, specular);
}

void WINAPI Dex3D_resize(float width, float height)
{
	mDex3D->resize(width, height);
}

//=============================================================================

void WINAPI Dex3D_moveTo(float x, float y, float z)
{
	mDex3D->moveTo(Vector(x, y, z));
}

void WINAPI Dex3D_lookAt(float x, float y, float z)
{
	mDex3D->lookAt(Vector(x, y, z));
}

void WINAPI Dex3D_lookFrom(float x, float y, float z)
{
	mDex3D->lookFrom(Vector(x, y, z));
}

void WINAPI Dex3D_orbit(float x, float y, float z, float radius, float lngAngle, float latAngle)
{
	mDex3D->orbit(Vector(x, y, z), radius, lngAngle, latAngle);
}

//=============================================================================

void WINAPI Dex3D_remMesh(char *id)
{
	mDex3D->remMesh(id);
}

void WINAPI Dex3D_clear()
{
	mDex3D->clear();
}

void WINAPI Dex3D_relock()
{
	mDex3D->relock();
}

//=============================================================================

void WINAPI Dex3D_copyMesh(char *id, char *id2)
{
	mDex3D->copyMesh(id, id2);
}

void WINAPI Dex3D_load3ds(char *id, char *filename, int index)
{
	mDex3D->load3ds(id, filename, index);
}

void WINAPI Dex3D_addBox(char *id, float width, float height, float length)
{
	mDex3D->addBox(id, width, height, length);
}

void WINAPI Dex3D_addGrid(char *id, float width, float length, int gridX, int gridZ)
{
	mDex3D->addGrid(id, width, length, gridX, gridZ);
}

void WINAPI Dex3D_addSprite(char *id, float width, float height, bool treeStyle)
{
	mDex3D->addSprite(id, width, height, treeStyle);
}

void WINAPI Dex3D_addHud(char *id, float width, float height)
{
	mDex3D->addHud(id, width, height);
}

void WINAPI Dex3D_addCylndr(char *id, float radius, float height, int step)
{
	mDex3D->addCylndr(id, radius, height, step);
}

void WINAPI Dex3D_addCone(char *id, float radius, float height, int step)
{
	mDex3D->addCone(id, radius, height, step);
}

void WINAPI Dex3D_addSphere(char *id, float radius, int stepLng, int stepLat)
{
	mDex3D->addSphere(id, radius, stepLng, stepLat);
}

void WINAPI Dex3D_addHemis(char *id, float radius, int stepLng, int stepLat)
{
	mDex3D->addHemis(id, radius, stepLng, stepLat);
}

void WINAPI Dex3D_addCapsul(char *id, float radius, float height, int stepLng, int stepLat)
{
	mDex3D->addCapsul(id, radius, height, stepLng, stepLat);
}

void WINAPI Dex3D_addTorus(char *id, float radMajor, float radMinor, int stepMajor, int stepMinor)
{
	mDex3D->addTorus(id, radMajor, radMinor, stepMajor, stepMinor);
}

void WINAPI Dex3D_addOcta(char *id, float radius)
{
	mDex3D->addOcta(id, radius);
}

void WINAPI Dex3D_addTetra(char *id, float radius)
{
	mDex3D->addTetra(id, radius);
}

//=============================================================================

void WINAPI Dex3D_modify(char *id, int trans, float x, float y, float z)
{
	mDex3D->modify(id, (TRANS::TRANS) trans, Vector(x, y, z));
}

void WINAPI Dex3D_query(char *id, int trans, float &x, float &y, float &z)
{
	mDex3D->query(id, (TRANS::TRANS) trans, x, y, z);
}

void WINAPI Dex3D_pointAt(char *id, float x, float y, float z)
{
	mDex3D->pointAt(id, Vector(x, y, z));
}

void WINAPI Dex3D_rotArb(
	char *id,
	float posX, float posY, float posZ,
	float dirX, float dirY, float dirZ,
	float angle
	)
{
	mDex3D->rotArb(id, Vector(posX, posY, posZ), Vector(dirX, dirY, dirZ), angle);
}

void WINAPI Dex3D_applyImp(char *id, float mass, float inertia, float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3)
{
	mDex3D->applyImp(id, mass, inertia, Vector(x1, y1, z1), Vector(x2, y2, z2), Vector(x3, y3, z3));
}

void WINAPI Dex3D_link(char *id, char *id2)
{
	mDex3D->link(id, id2);
}

//=============================================================================

char *WINAPI Dex3D_sectPoly(float x1, float y1, float z1, float x2, float y2, float z2, float &s)
{
	return (char *) mDex3D->sectPoly(Vector(x1, y1, z1), Vector(x2, y2, z2), s).c_str();
}

char *WINAPI Dex3D_pick(float x, float y)
{
	return (char *) mDex3D->pick(x, y).c_str();
}

//=============================================================================

void WINAPI Dex3D_setVertex(char *id, int index, float x, float y, float z)
{
	mDex3D->setVertex(id, index, x, y, z);
}

void WINAPI Dex3D_relockMsh(char *id)
{
	mDex3D->relockMsh(id);
}

void WINAPI Dex3D_setAxis(char *id, float x, float y, float z)
{
	mDex3D->setAxis(id, Vector(x, y, z));
}

void WINAPI Dex3D_alignAxis(char *id, int dir)
{
	mDex3D->alignAxis(id, (DIR::DIR) dir);
}

void WINAPI Dex3D_invert(char *id)
{
	mDex3D->invert(id);
}

void WINAPI Dex3D_imprint(char *id)
{
	mDex3D->imprint(id);
}

void WINAPI Dex3D_normalize(char *id)
{
	mDex3D->normalize(id);
}

void WINAPI Dex3D_setHgtMap(char *id, char *filename, float height)
{
	mDex3D->setHgtMap(id, filename, height);
}

void WINAPI Dex3D_setColor(char *id, long color)
{
	mDex3D->setColor(id, color);
}

//=============================================================================

void WINAPI Dex3D_setTexMap(char *id, char *filename, char *maskFile, long maskColor, int dir)
{
	mDex3D->setTex(id, filename, maskFile, maskColor, true);
	mDex3D->setMap(id, (DIR::DIR) dir);
}

void WINAPI Dex3D_setFont(char *id, char *name, int size, bool bold, bool italic, bool underline, bool strikeOut)
{
	mDex3D->setFont(id, name, size, bold, italic, underline, strikeOut);
}

//=============================================================================

void WINAPI Dex3D_setSolid(char *id)
{
	mDex3D->setSolid(id);
}

void WINAPI Dex3D_setWire(char *id)
{
	mDex3D->setWire(id);
}

void WINAPI Dex3D_setAlpha(char *id, float alpha)
{
	mDex3D->setAlpha(id, alpha);
}

//=============================================================================

void WINAPI Dex3D_setAttrib(char *id, long ambient, long diffuse, long specular, long emission, float shininess)
{
	mDex3D->setAttrib(id, ambient, diffuse, specular, emission, shininess);
}

void WINAPI Dex3D_setText(char *id, char *text)
{
	mDex3D->setText(id, text);
}

void WINAPI Dex3D_setVis(char *id, bool value)
{
	mDex3D->setVis(id, value);
}

void WINAPI Dex3D_setNoClip(char *id, bool value)
{
	mDex3D->setNoClip(id, value);
}

void WINAPI Dex3D_setPhys(char *id, float mass, float inertia, float bounce, float friction)
{
	mDex3D->setPhys(id, mass, inertia, bounce, friction);
}

//=============================================================================

void WINAPI Dex3D_update()
{
	mDex3D->update();
}

void WINAPI Dex3D_paint()
{
	mDex3D->paint();
}