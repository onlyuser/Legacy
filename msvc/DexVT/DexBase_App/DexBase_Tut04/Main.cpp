#include "DexUser.h"

static DexUser *mDexUser;
static HINSTANCE mLibDexGL;
static HINSTANCE mLibDex3D;
static HINSTANCE mLibDexSocket;
static HINSTANCE mLibDexTS;

void WINAPI load(HWND hWnd)
{
	//=============================================================================
	mLibDexGL = LoadLibrary("DexGL");
	mLibDex3D = LoadLibrary("Dex3D");
	mLibDexSocket = LoadLibrary("DexSocket");
	mLibDexTS = LoadLibrary("DexTS");
	//=============================================================================
	mDexUser = new DexUser(mLibDexGL, mLibDex3D, mLibDexSocket, mLibDexTS);
	mDexUser->load(hWnd);
}

void WINAPI unload(int &cancel)
{
	mDexUser->unload(cancel);
	delete mDexUser;
	//=============================================================================
	FreeLibrary(mLibDexGL);
	FreeLibrary(mLibDex3D);
	FreeLibrary(mLibDexSocket);
	FreeLibrary(mLibDexTS);
	//=============================================================================
}

void WINAPI resize(int width, int height)
{
	mDexUser->resize(width, height);
}

void WINAPI paint(HDC hDC)
{
	mDexUser->paint(hDC);
}

void WINAPI keyDown(int key)
{
	mDexUser->keyDown(key);
}

void WINAPI keyUp(int key)
{
	mDexUser->keyUp(key);
}

void WINAPI mouseDown(int button, int x, int y)
{
	mDexUser->mouseDown(button, x, y);
}

void WINAPI mouseMove(int button, int x, int y)
{
	mDexUser->mouseMove(button, x, y);
}

void WINAPI mouseUp(int button, int x, int y)
{
	mDexUser->mouseUp(button, x, y);
}

void WINAPI mouseDblClick()
{
	mDexUser->mouseDblClick();
}

void WINAPI timer()
{
	mDexUser->timer();
}

void WINAPI timerEx(void *param)
{
	mDexUser->timerEx((long) param);
}

void WINAPI user(long wParam, long lParam)
{
	mDexUser->user(wParam, lParam);
}

void main()
{
	HINSTANCE instLib = LoadLibrary("DexWndProc");
	HINSTANCE instLib2 = LoadLibrary("DexView");

	DEXWNDPROC_REGEVENTS dexWndProc_regEvents =
		(DEXWNDPROC_REGEVENTS) GetProcAddress(instLib, "DexWndProc_regEvents");
	DEXVIEW_LAUNCHEX dexView_launchEx =
		(DEXVIEW_LAUNCHEX) GetProcAddress(instLib2, "DexView_launchEx");

	dexWndProc_regEvents(
		(FUNC_LOAD) load, (FUNC_UNLOAD) unload,
		(FUNC_RESIZE) resize, (FUNC_PAINT) paint,
		(FUNC_KEY) keyDown, (FUNC_KEY) keyUp,
		(FUNC_MOUSE) mouseDown, (FUNC_MOUSE) mouseMove, (FUNC_MOUSE) mouseUp,
		(FUNC_MOUSE2) mouseDblClick,
		(FUNC_TIMER) timer, (FUNC_USER) user
		);

	THREAD_PROC threadProc[THREAD_NUM];
	int threadInt[THREAD_NUM];
	for (int i = 0; i < THREAD_NUM; i++)
	{
		threadProc[i] = (THREAD_PROC) timerEx;
		threadInt[i] = -1;
	}

	dexView_launchEx(
		"DexWndProc",
		"DexWndProc_wndProc", "DexBase", 480, 320,
		THREAD_NUM, threadProc, threadInt, true
		);

	FreeLibrary(instLib);
	FreeLibrary(instLib2);
}