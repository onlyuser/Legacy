#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h>
#include "DexWndProc.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static DexWndProc mDexWndProc;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI DexWndProc_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI DexWndProc_sum(int a, int b);
char *WINAPI DexWndProc_echo(char *text);

void WINAPI DexWndProc_regEventsEx(
	char *library,
	char *entryLoad, char *entryUnload,
	char *entryResize, char *entryPaint,
	char *entryKeyDown, char *entryKeyUp,
	char *entryMouseDown, char *entryMouseMove, char *entryMouseUp,
	char *entryMouseDblClick,
	char *entryTimer, char *entryUser
	);

void WINAPI DexWndProc_regEvents(
	FUNC_LOAD funcLoad, FUNC_UNLOAD funcUnload,
	FUNC_RESIZE funcResize, FUNC_PAINT funcPaint,
	FUNC_KEY funcKeyDown, FUNC_KEY funcKeyUp,
	FUNC_MOUSE funcMouseDown, FUNC_MOUSE funcMouseMove, FUNC_MOUSE funcMouseUp,
	FUNC_MOUSE2 funcMouseDblClick,
	FUNC_TIMER funcTimer, FUNC_USER funcUser
	);

LRESULT WINAPI DexWndProc_wndProc(HWND hWnd, INT iMsg, WPARAM wParam, LPARAM lParam);

#endif