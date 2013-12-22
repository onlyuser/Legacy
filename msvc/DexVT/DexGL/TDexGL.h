#ifndef H_TDEXGL
#define H_TDEXGL

#include <windows.h>

namespace BLEND_OP
{
	enum BLEND_OP
	{
		NONE,
		ALPHA_TEX_MASK,
		ALPHA_TEX_GLOW,
		ALPHA_SET
	};
};

namespace DRAW_MODE
{
	enum DRAW_MODE
	{
		WIRE,
		SOLID,
		TEXTURED
	};
};

//=============================================================================
typedef VOID (WINAPI *DEXGL_LOAD)(HWND);
typedef VOID (WINAPI *DEXGL_UNLOAD)();
//=============================================================================
typedef VOID (WINAPI *DEXGL_RESIZE)(INT, INT);
typedef VOID (WINAPI *DEXGL_CLEAR)();
typedef VOID (WINAPI *DEXGL_PAINT)();
typedef VOID (WINAPI *DEXGL_SAVEIMAGE)(PVOID, BOOL, FLOAT, FLOAT);
//=============================================================================
typedef LONG (WINAPI *DEXGL_LISTGEN)(
	LONG, LONG, PLONG,
	PFLOAT, PFLOAT, PFLOAT, PFLOAT
	);
typedef VOID (WINAPI *DEXGL_LISTKILL)(LONG);
typedef LONG (WINAPI *DEXGL_TEXGEN)(PLONG, INT, INT, BOOL);
typedef VOID (WINAPI *DEXGL_TEXKILL)(LONG);
typedef VOID (WINAPI *DEXGL_TEXBIND)(LONG);
typedef LONG (WINAPI *DEXGL_FONTGEN)(LPSTR, INT, BOOL, BOOL, BOOL, BOOL);
typedef VOID (WINAPI *DEXGL_FONTKILL)(LONG);
typedef VOID (WINAPI *DEXGL_FONTPRINT)(LONG, LPSTR, FLOAT, FLOAT, FLOAT, LONG);
typedef VOID (WINAPI *DEXGL_VIEW)(PFLOAT, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEXGL_MODEL)(PFLOAT, LONG);
typedef VOID (WINAPI *DEXGL_LIGHT)(LONG, LONG);
typedef VOID (WINAPI *DEXGL_LIGHTPOS)(LONG, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEXGL_BRUSH)(LONG, FLOAT);
typedef VOID (WINAPI *DEXGL_BLEND)(LONG, FLOAT);
typedef VOID (WINAPI *DEXGL_MODE)(LONG);
typedef VOID (WINAPI *DEXGL_FOG)(LONG, FLOAT, FLOAT, FLOAT);
typedef VOID (WINAPI *DEXGL_TRI)(
	LONG, LONG, LONG,
	FLOAT, FLOAT,
	FLOAT, FLOAT,
	FLOAT, FLOAT
	);
//=============================================================================

#endif