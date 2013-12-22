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

void WINAPI DexWndProc_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI DexWndProc_sum(int a, int b)
{
	return a + b;
}

char *WINAPI DexWndProc_echo(char *text)
{
	return text;
}

void WINAPI DexWndProc_regEventsEx(
	char *library,
	char *entryLoad, char *entryUnload,
	char *entryResize, char *entryPaint,
	char *entryKeyDown, char *entryKeyUp,
	char *entryMouseDown, char *entryMouseMove, char *entryMouseUp,
	char *entryMouseDblClick,
	char *entryTimer, char *entryUser
	)
{
	mDexWndProc.regEvents(
		library,
		entryLoad, entryUnload,
		entryResize, entryPaint,
		entryKeyDown, entryKeyUp,
		entryMouseDown, entryMouseMove, entryMouseUp,
		entryMouseDblClick,
		entryTimer, entryUser
		);
}

void WINAPI DexWndProc_regEvents(
	FUNC_LOAD funcLoad, FUNC_UNLOAD funcUnload,
	FUNC_RESIZE funcResize, FUNC_PAINT funcPaint,
	FUNC_KEY funcKeyDown, FUNC_KEY funcKeyUp,
	FUNC_MOUSE funcMouseDown, FUNC_MOUSE funcMouseMove, FUNC_MOUSE funcMouseUp,
	FUNC_MOUSE2 funcMouseDblClick,
	FUNC_TIMER funcTimer, FUNC_USER funcUser
	)
{
	mDexWndProc.regEvents(
		funcLoad, funcUnload,
		funcResize, funcPaint,
		funcKeyDown, funcKeyUp,
		funcMouseDown, funcMouseMove, funcMouseUp,
		funcMouseDblClick,
		funcTimer, funcUser
		);
}

LRESULT WINAPI DexWndProc_wndProc(HWND hWnd, INT iMsg, WPARAM wParam, LPARAM lParam)
{
	return mDexWndProc.WndProc(hWnd, iMsg, wParam, lParam);
}