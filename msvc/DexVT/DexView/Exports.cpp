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

void WINAPI DexView_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI DexView_sum(int a, int b)
{
	return a + b;
}

char *WINAPI DexView_echo(char *text)
{
	return text;
}

void WINAPI DexView_launchEx(
	char *library,
	char *entryWndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	)
{
	mDexView.launch(
		library,
		entryWndProc, text, width, height,
		threadCnt, threadProc, threadInt, useMutex
		);
}

void WINAPI DexView_launch(
	WNDPROC wndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	)
{
	mDexView.launch(
		wndProc, text, width, height,
		threadCnt, threadProc, threadInt, useMutex
		);
}