#ifndef H_DEXWNDPROC
#define H_DEXWNDPROC

#include <windows.h>
#include "TDexWndProc.h"

#define TIMER_INT 1

#define GET_X_LPARAM(lp) ((int) (short) LOWORD(lp))
#define GET_Y_LPARAM(lp) ((int) (short) HIWORD(lp))

class DexWndProc
{
private:
	int mPrevKey;
	HINSTANCE mInstLib;
	FUNC_LOAD mFuncLoad; FUNC_UNLOAD mFuncUnload;
	FUNC_RESIZE mFuncResize; FUNC_PAINT mFuncPaint;
	FUNC_KEY mFuncKeyDown; FUNC_KEY mFuncKeyUp;
	FUNC_MOUSE mFuncMouseDown; FUNC_MOUSE mFuncMouseMove; FUNC_MOUSE mFuncMouseUp;
	FUNC_MOUSE2 mFuncMouseDblClick;
	FUNC_TIMER mFuncTimer; FUNC_USER mFuncUser;
public:
	DexWndProc();
	~DexWndProc();
	void regEvents(
		char *library,
		char *entryLoad, char *entryUnload,
		char *entryResize, char *entryPaint,
		char *entryKeyDown, char *entryKeyUp,
		char *entryMouseDown, char *entryMouseMove, char *entryMouseUp,
		char *entryMouseDblClick,
		char *entryTimer, char *entryUser
		);
	void regEvents(
		FUNC_LOAD funcLoad, FUNC_UNLOAD funcUnload,
		FUNC_RESIZE funcResize, FUNC_PAINT funcPaint,
		FUNC_KEY funcKeyDown, FUNC_KEY funcKeyUp,
		FUNC_MOUSE funcMouseDown, FUNC_MOUSE funcMouseMove, FUNC_MOUSE funcMouseUp,
		FUNC_MOUSE2 funcMouseDblClick,
		FUNC_TIMER funcTimer, FUNC_USER funcUser
		);
	LRESULT WndProc(HWND hWnd, INT iMsg, WPARAM wParam, LPARAM lParam);
};

#endif