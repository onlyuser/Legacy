#ifndef H_TDEX3D
#define H_TDEX3D

#include <windows.h> // WINAPI
#include "TDexGL.h" // DEXGL_TRI

namespace TRANS
{
	enum TRANS
	{
		ORIGIN,
		ANGLE,
		SCALE,
		LOCK_ORIGIN,
		LOCK_ANGLE,
		LOCK_SCALE,
		MIN_ANGLE,
		MAX_ANGLE,
		ABS_ORIGIN,
		ABS_FRONT,
		ABS_LEFT,
		ABS_TOP,
		ABS_DIR_FWD,
		ABS_DIR_LEFT,
		ABS_DIR_UP,
		LOCAL_ORIGIN,
		LOCAL_ANGLE,
		VEL_ORIGIN,
		VEL_ANGLE,
		ACC_ORIGIN,
		ACC_ANGLE,
		MAX_SPD_ORIGIN,
		MAX_SPD_ANGLE,
		LOC_VEL_ORIGIN,
		ARB_PIVOT_DIR,
		ARB_VEL_ANGLE
	};
};

namespace DIR
{
	enum DIR
	{
		CENTER,
		LEFT,
		RIGHT,
		TOP,
		BOTTOM,
		FRONT,
		BACK,
		WRAP_SPHERE,
		WRAP_CYLNDR,
		RADIAL_SPHERE,
		RADIAL_CYLNDR
	};
};

//=============================================================================
typedef VOID (WINAPI *DEX3D_LOAD)();
typedef VOID (WINAPI *DEX3D_UNLOAD)();
//=============================================================================
typedef VOID (WINAPI *DEX3D_REGDRWFNCEX)(
	LPSTR,
	LPSTR,
	LPSTR, LPSTR,
	LPSTR, LPSTR, LPSTR,
	LPSTR, LPSTR,
	LPSTR, LPSTR, LPSTR,
	LPSTR
	);
typedef VOID (WINAPI *DEX3D_REGDRWFNC)(
	DEXGL_TRI,
	DEXGL_LISTGEN, DEXGL_LISTKILL,
	DEXGL_TEXGEN, DEXGL_TEXKILL, DEXGL_TEXBIND,
	DEXGL_FONTGEN, DEXGL_FONTKILL, DEXGL_FONTPRINT,
	DEXGL_VIEW, DEXGL_MODEL,
	DEXGL_LIGHT, DEXGL_BRUSH, DEXGL_BLEND,
	DEXGL_MODE
	);
//=============================================================================
typedef VOID (WINAPI *DEX3D_SETCAMERA)(FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_SETLIGHT)(LONG, LONG, LONG);
typedef VOID (WINAPI *DEX3D_RESIZE)(FLOAT, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_MOVETO)(FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_LOOKAT)(FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_LOOKFROM)(FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_ORBIT)(FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_REMMESH)(LPSTR);
typedef VOID (WINAPI *DEX3D_CLEAR)();
typedef VOID (WINAPI *DEX3D_RELOCK)();
//=============================================================================
typedef VOID (WINAPI *DEX3D_COPYMESH)(LPSTR, LPSTR);
typedef VOID (WINAPI *DEX3D_LOAD3DS)(LPSTR, LPSTR, INT);
typedef VOID (WINAPI *DEX3D_ADDBOX)(LPSTR, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_ADDGRID)(LPSTR, FLOAT, FLOAT, INT, INT);
typedef VOID (WINAPI *DEX3D_ADDSPRITE)(LPSTR, FLOAT, FLOAT, BOOL);
typedef VOID (WINAPI *DEX3D_ADDHUD)(LPSTR, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_ADDCYLNDR)(LPSTR, FLOAT, FLOAT, INT);
typedef VOID (WINAPI *DEX3D_ADDCONE)(LPSTR, FLOAT, FLOAT, INT);
typedef VOID (WINAPI *DEX3D_ADDSPHERE)(LPSTR, FLOAT, INT, INT);
typedef VOID (WINAPI *DEX3D_ADDHEMIS)(LPSTR, FLOAT, INT, INT);
typedef VOID (WINAPI *DEX3D_ADDCAPSUL)(LPSTR, FLOAT, FLOAT, INT, INT);
typedef VOID (WINAPI *DEX3D_ADDTORUS)(LPSTR, FLOAT, FLOAT, INT, INT);
typedef VOID (WINAPI *DEX3D_ADDOCTA)(LPSTR, FLOAT);
typedef VOID (WINAPI *DEX3D_ADDTETRA)(LPSTR, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_MODIFY)(LPSTR, INT, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_QUERY)(LPSTR, INT, PFLOAT, PFLOAT, PFLOAT);
typedef VOID (WINAPI *DEX3D_POINTAT)(LPSTR, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_ROTARB)(
	LPSTR,
	FLOAT, FLOAT, FLOAT,
	FLOAT, FLOAT, FLOAT,
	FLOAT
	);
typedef VOID (WINAPI *DEX3D_LOCKAXIS)(LPSTR, INT, BOOL, BOOL, BOOL);
typedef VOID (WINAPI *DEX3D_APPLYIMP)(LPSTR, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_LINK)(LPSTR, LPSTR);
//=============================================================================
typedef LPSTR (WINAPI *DEX3D_SECTPOLY)(FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, FLOAT, PFLOAT);
typedef LPSTR (WINAPI *DEX3D_PICK)(FLOAT, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_SETVERTEX)(LPSTR, INT, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_RELOCKMSH)(LPSTR);
typedef VOID (WINAPI *DEX3D_SETAXIS)(LPSTR, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEX3D_ALIGNAXIS)(LPSTR, INT);
typedef VOID (WINAPI *DEX3D_INVERT)(LPSTR);
typedef VOID (WINAPI *DEX3D_IMPRINT)(LPSTR);
typedef VOID (WINAPI *DEX3D_NORMALIZE)(LPSTR);
typedef VOID (WINAPI *DEX3D_SETHGTMAP)(LPSTR, LPSTR, FLOAT);
typedef VOID (WINAPI *DEX3D_SETCOLOR)(LPSTR, LONG);
//=============================================================================
typedef VOID (WINAPI *DEX3D_SETTEXMAP)(LPSTR, LPSTR, LPSTR, LONG, INT);
typedef VOID (WINAPI *DEX3D_SETFONT)(LPSTR, LPSTR, INT, BOOL, BOOL, BOOL, BOOL);
//=============================================================================
typedef VOID (WINAPI *DEX3D_SETSOLID)(LPSTR);
typedef VOID (WINAPI *DEX3D_SETWIRE)(LPSTR);
typedef VOID (WINAPI *DEX3D_SETALPHA)(LPSTR, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_SETATTRIB)(LPSTR, LONG, LONG, LONG, LONG, FLOAT);
typedef VOID (WINAPI *DEX3D_SETTEXT)(LPSTR, LPSTR);
typedef VOID (WINAPI *DEX3D_SETVIS)(LPSTR, BOOL);
typedef VOID (WINAPI *DEX3D_SETNOCLIP)(LPSTR, BOOL);
typedef VOID (WINAPI *DEX3D_SETPHYS)(LPSTR, FLOAT, FLOAT, FLOAT, FLOAT);
//=============================================================================
typedef VOID (WINAPI *DEX3D_UPDATE)();
typedef VOID (WINAPI *DEX3D_PAINT)();
//=============================================================================

#endif