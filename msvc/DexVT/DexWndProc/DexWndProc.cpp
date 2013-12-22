#include "DexWndProc.h"

DexWndProc::DexWndProc()
{
	mPrevKey = 0;
	mInstLib = NULL;
	this->regEvents(
		NULL, NULL,
		NULL, NULL,
		NULL, NULL,
		NULL, NULL, NULL,
		NULL,
		NULL, NULL
		);
}

DexWndProc::~DexWndProc()
{
	if (mInstLib)
		FreeLibrary(mInstLib);
}

void DexWndProc::regEvents(
	char *library,
	char *entryLoad, char *entryUnload,
	char *entryResize, char *entryPaint,
	char *entryKeyDown, char *entryKeyUp,
	char *entryMouseDown, char *entryMouseMove, char *entryMouseUp,
	char *entryMouseDblClick,
	char *entryTimer, char *entryUser
	)
{
	if (mInstLib = LoadLibrary(library))
		this->regEvents(
			(FUNC_LOAD)   GetProcAddress(mInstLib, entryLoad),
			(FUNC_UNLOAD) GetProcAddress(mInstLib, entryUnload),
			(FUNC_RESIZE) GetProcAddress(mInstLib, entryResize),
			(FUNC_PAINT)  GetProcAddress(mInstLib, entryPaint),
			(FUNC_KEY)    GetProcAddress(mInstLib, entryKeyDown),
			(FUNC_KEY)    GetProcAddress(mInstLib, entryKeyUp),
			(FUNC_MOUSE)  GetProcAddress(mInstLib, entryMouseDown),
			(FUNC_MOUSE)  GetProcAddress(mInstLib, entryMouseMove),
			(FUNC_MOUSE)  GetProcAddress(mInstLib, entryMouseUp),
			(FUNC_MOUSE2) GetProcAddress(mInstLib, entryMouseDblClick),
			(FUNC_TIMER)  GetProcAddress(mInstLib, entryTimer),
			(FUNC_USER)   GetProcAddress(mInstLib, entryUser)
			);
}

void DexWndProc::regEvents(
	FUNC_LOAD funcLoad, FUNC_UNLOAD funcUnload,
	FUNC_RESIZE funcResize, FUNC_PAINT funcPaint,
	FUNC_KEY funcKeyDown, FUNC_KEY funcKeyUp,
	FUNC_MOUSE funcMouseDown, FUNC_MOUSE funcMouseMove, FUNC_MOUSE funcMouseUp,
	FUNC_MOUSE2 funcMouseDblClick,
	FUNC_TIMER funcTimer, FUNC_USER funcUser
	)
{
	mFuncLoad          = funcLoad;
	mFuncUnload        = funcUnload;
	mFuncResize        = funcResize;
	mFuncPaint         = funcPaint;
	mFuncKeyDown       = funcKeyDown;
	mFuncKeyUp         = funcKeyUp;
	mFuncMouseDown     = funcMouseDown;
	mFuncMouseMove     = funcMouseMove;
	mFuncMouseUp       = funcMouseUp;
	mFuncMouseDblClick = funcMouseDblClick;
	mFuncTimer         = funcTimer;
	mFuncUser          = funcUser;
}

LRESULT DexWndProc::WndProc(HWND hWnd, INT iMsg, WPARAM wParam, LPARAM lParam)
{
	switch (iMsg)
	{
		case WM_CREATE:
			if (mFuncLoad)
				mFuncLoad(hWnd);
			if (TIMER_INT > 0)
				SetTimer(hWnd, 1, TIMER_INT, NULL);
			break;
		case WM_TIMER:
			if (mFuncTimer)
				mFuncTimer();
			break;
		case WM_USER:
			if (mFuncUser)
				mFuncUser(wParam, lParam);
			break;
		case WM_KEYDOWN:
			if ((int) wParam != mPrevKey)
				if (mFuncKeyDown)
					mFuncKeyDown(mPrevKey = wParam);
			break;
		case WM_KEYUP:
			if (mFuncKeyUp)
				mFuncKeyUp(wParam);
			mPrevKey = 0;
			break;
		case WM_LBUTTONDBLCLK:
		case WM_RBUTTONDBLCLK:
			if (mFuncMouseDblClick)
				mFuncMouseDblClick();
			break;
		case WM_MOUSEMOVE:
		case WM_LBUTTONDOWN:
		case WM_RBUTTONDOWN:
		case WM_LBUTTONUP:
		case WM_RBUTTONUP:
		{
			int x = GET_X_LPARAM(lParam);
			int y = GET_Y_LPARAM(lParam);
			if (iMsg == WM_MOUSEMOVE)
			{
				int button = MOUSE::NONE;
				button = (wParam & MK_LBUTTON) ? MOUSE::LEFT : button;
				button = (wParam & MK_RBUTTON) ? MOUSE::RIGHT : button;
				if (mFuncMouseMove)
					mFuncMouseMove(button, x, y);
			}
			else
			{
				int button = MOUSE::RIGHT;
				button = (iMsg == WM_LBUTTONDOWN) ? MOUSE::LEFT : button;
				switch (iMsg)
				{
					case WM_LBUTTONDOWN:
					case WM_RBUTTONDOWN:
						if (mFuncMouseDown)
							mFuncMouseDown(button, x, y);
						break;
					case WM_LBUTTONUP:
					case WM_RBUTTONUP:
						if (mFuncMouseUp)
							mFuncMouseUp(button, x, y);
				}
			}
			break;
		}
		case WM_SIZE:
			if (mFuncResize)
				mFuncResize(LOWORD(lParam), HIWORD(lParam));
			break;
		case WM_PAINT:
		{
			PAINTSTRUCT ps;
			HDC hDC = BeginPaint(hWnd, &ps);
			if (mFuncPaint)
				mFuncPaint(hDC);
			EndPaint(hWnd, &ps);
			break;
		}
		case WM_CLOSE:
		{
			int cancel = 0;
			if (mFuncUnload)
				mFuncUnload(&cancel);
			if (!cancel)
				PostQuitMessage(0);
			break;
		}
		case WM_DESTROY:
			KillTimer(hWnd, 1);
			break;
		default:
			return DefWindowProc(hWnd, iMsg, wParam, lParam);
	}
	return 0;
}