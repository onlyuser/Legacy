#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h>
#include "DexView.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static DexView mDexView;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI DexView_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI DexView_sum(int a, int b);
char *WINAPI DexView_echo(char *text);

void WINAPI DexView_launchEx(
	char *library,
	char *entryWndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	);
void WINAPI DexView_launch(
	WNDPROC wndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	);

#endif