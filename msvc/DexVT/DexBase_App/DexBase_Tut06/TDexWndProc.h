#ifndef H_TDEXWNDPROC
#define H_TDEXWNDPROC

#include <windows.h>

namespace MOUSE
{
	enum MOUSE {NONE, LEFT, RIGHT};
};

//=============================================================================
typedef VOID (WINAPI *FUNC_LOAD)(HWND);
typedef VOID (WINAPI *FUNC_UNLOAD)(PINT);
typedef VOID (WINAPI *FUNC_RESIZE)(INT, INT);
typedef VOID (WINAPI *FUNC_PAINT)(HDC);
typedef VOID (WINAPI *FUNC_KEY)(INT);
typedef VOID (WINAPI *FUNC_MOUSE)(INT, INT, INT);
typedef VOID (WINAPI *FUNC_MOUSE2)();
typedef VOID (WINAPI *FUNC_TIMER)();
typedef VOID (WINAPI *FUNC_USER)(INT, INT);
//=============================================================================
typedef VOID (WINAPI *DEXWNDPROC_REGEVENTSEX)(
	LPSTR,
	LPSTR, LPSTR,
	LPSTR, LPSTR,
	LPSTR, LPSTR,
	LPSTR, LPSTR, LPSTR,
	LPSTR,
	LPSTR, LPSTR
	);
typedef VOID (WINAPI *DEXWNDPROC_REGEVENTS)(
	FUNC_LOAD, FUNC_UNLOAD,
	FUNC_RESIZE, FUNC_PAINT,
	FUNC_KEY, FUNC_KEY,
	FUNC_MOUSE, FUNC_MOUSE, FUNC_MOUSE,
	FUNC_MOUSE2,
	FUNC_TIMER, FUNC_USER
	);
//=============================================================================

#endif