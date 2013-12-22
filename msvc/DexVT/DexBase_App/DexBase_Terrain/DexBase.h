#ifndef H_DEXBASE
#define H_DEXBASE

#include <windows.h>
#include "String.h"
#include "TDexGL.h"
#include "TDex3D.h"
#include "TDexSocket.h"
#include "TDexCalc.h"
#include "TDexView.h"
#include "TDexWndProc.h"
#include "FileBmp.h"

class DexBase
{
protected:
	//=============================================================================
	DEXGL_LOAD      mDexGL_load;
	DEXGL_UNLOAD    mDexGL_unload;
	//=============================================================================
	DEXGL_RESIZE    mDexGL_resize;
	DEXGL_CLEAR     mDexGL_clear;
	DEXGL_PAINT     mDexGL_paint;
	DEXGL_SAVEIMAGE mDexGL_saveImage;
	//=============================================================================
	DEXGL_LISTGEN   mDexGL_listGen;
	DEXGL_LISTKILL  mDexGL_listKill;
	DEXGL_TEXGEN    mDexGL_texGen;
	DEXGL_TEXKILL   mDexGL_texKill;
	DEXGL_TEXBIND   mDexGL_texBind;
	DEXGL_FONTGEN   mDexGL_fontGen;
	DEXGL_FONTKILL  mDexGL_fontKill;
	DEXGL_FONTPRINT mDexGL_fontPrint;
	DEXGL_VIEW      mDexGL_view;
	DEXGL_MODEL     mDexGL_model;
	DEXGL_LIGHT     mDexGL_light;
	DEXGL_BRUSH     mDexGL_brush;
	DEXGL_BLEND     mDexGL_blend;
	DEXGL_MODE      mDexGL_mode;
	DEXGL_FOG       mDexGL_fog;
	DEXGL_TRI       mDexGL_tri;
	//=============================================================================
	DEX3D_LOAD      mDex3D_load;
	DEX3D_UNLOAD    mDex3D_unload;
	//=============================================================================
	DEX3D_REGDRWFNCEX mDex3D_regDrwFncEx;
	DEX3D_REGDRWFNC   mDex3D_regDrwFnc;
	//=============================================================================
	DEX3D_SETCAMERA mDex3D_setCamera;
	DEX3D_SETLIGHT  mDex3D_setLight;
	DEX3D_RESIZE    mDex3D_resize;
	//=============================================================================
	DEX3D_MOVETO    mDex3D_moveTo;
	DEX3D_LOOKAT    mDex3D_lookAt;
	DEX3D_LOOKFROM  mDex3D_lookFrom;
	DEX3D_ORBIT     mDex3D_orbit;
	//=============================================================================
	DEX3D_REMMESH   mDex3D_remMesh;
	DEX3D_CLEAR     mDex3D_clear;
	DEX3D_RELOCK    mDex3D_relock;
	//=============================================================================
	DEX3D_COPYMESH  mDex3D_copyMesh;
	DEX3D_LOAD3DS   mDex3D_load3ds;
	DEX3D_ADDBOX    mDex3D_addBox;
	DEX3D_ADDGRID   mDex3D_addGrid;
	DEX3D_ADDSPRITE mDex3D_addSprite;
	DEX3D_ADDHUD    mDex3D_addHud;
	DEX3D_ADDCYLNDR mDex3D_addCylndr;
	DEX3D_ADDCONE   mDex3D_addCone;
	DEX3D_ADDSPHERE mDex3D_addSphere;
	DEX3D_ADDHEMIS  mDex3D_addHemis;
	DEX3D_ADDCAPSUL mDex3D_addCapsul;
	DEX3D_ADDTORUS  mDex3D_addTorus;
	DEX3D_ADDOCTA   mDex3D_addOcta;
	DEX3D_ADDTETRA  mDex3D_addTetra;
	//=============================================================================
	DEX3D_MODIFY    mDex3D_modify;
	DEX3D_QUERY     mDex3D_query;
	DEX3D_POINTAT   mDex3D_pointAt;
	DEX3D_ROTARB    mDex3D_rotArb;
	DEX3D_APPLYIMP  mDex3D_applyImp;
	DEX3D_LINK      mDex3D_link;
	//=============================================================================
	DEX3D_SECTPOLY  mDex3D_sectPoly;
	DEX3D_PICK      mDex3D_pick;
	//=============================================================================
	DEX3D_SETVERTEX mDex3D_setVertex;
	DEX3D_RELOCKMSH mDex3D_relockMsh;
	DEX3D_SETAXIS   mDex3D_setAxis;
	DEX3D_ALIGNAXIS mDex3D_alignAxis;
	DEX3D_INVERT    mDex3D_invert;
	DEX3D_IMPRINT   mDex3D_imprint;
	DEX3D_NORMALIZE mDex3D_normalize;
	DEX3D_SETHGTMAP mDex3D_setHgtMap;
	DEX3D_SETCOLOR  mDex3D_setColor;
	//=============================================================================
	DEX3D_SETTEXMAP mDex3D_setTexMap;
	DEX3D_SETFONT   mDex3D_setFont;
	//=============================================================================
	DEX3D_SETSOLID  mDex3D_setSolid;
	DEX3D_SETWIRE   mDex3D_setWire;
	DEX3D_SETALPHA  mDex3D_setAlpha;
	//=============================================================================
	DEX3D_SETATTRIB mDex3D_setAttrib;
	DEX3D_SETTEXT   mDex3D_setText;
	DEX3D_SETVIS    mDex3D_setVis;
	DEX3D_SETNOCLIP mDex3D_setNoClip;
	DEX3D_SETPHYS   mDex3D_setPhys;
	//=============================================================================
	DEX3D_UPDATE    mDex3D_update;
	DEX3D_PAINT     mDex3D_paint;
	//=============================================================================
	DEXSOCKET_OPEN  mDexSocket_open;
	DEXSOCKET_CLOSE mDexSocket_close;
	DEXSOCKET_SEND  mDexSocket_send;
	DEXSOCKET_RECV  mDexSocket_recv;
	//=============================================================================
	DEXCALC_SETMODEVB mDexCalc_setModeVB;
	DEXCALC_CHANGEBSE mDexCalc_changeBse;
	DEXCALC_ENTERSCPE mDexCalc_enterScpe;
	DEXCALC_EXITSCOPE mDexCalc_exitScope;
	DEXCALC_RESET     mDexCalc_reset;
	DEXCALC_SETTURBO  mDexCalc_setTurbo;
	DEXCALC_COMPILE   mDexCalc_compile;
	DEXCALC_EVAL      mDexCalc_eval;
	DEXCALC_DEFVAR    mDexCalc_defVar;
	DEXCALC_UNDEFVAR  mDexCalc_undefVar;
	//=============================================================================

	HWND hWnd;
	int mWidth;
	int mHeight;

	std::string getPath();
	void msgBox(std::string text);
	void setText(std::string text);
	void setSize(int width, int height);
	void quit();
public:
	DexBase(
		HINSTANCE libDexGL,
		HINSTANCE libDex3D,
		HINSTANCE libDexSocket,
		HINSTANCE libDexCalc
		);
	~DexBase();
	void saveImage(std::string filename);
	void saveDepthMap(std::string filename, float power, float scale, float bias);
	virtual void load(HWND hWnd);
	virtual void unload(int &cancel);
	virtual void resize(int width, int height);
	virtual void paint(HDC hDC);
	virtual void timer();
};

#endif