#include "DexView.h"

DexView::DexView()  {}
DexView::~DexView() {}

void DexView::launch(
	char *library,
	char *entryWndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	)
{
	if (library[0] && entryWndProc[0])
	{
		if (HINSTANCE instLib = LoadLibrary(library))
		{
			this->launch(
				(WNDPROC) GetProcAddress(instLib, entryWndProc),
				text, width, height,
				threadCnt, threadProc, threadInt, useMutex
				);
			FreeLibrary(instLib);
		}
	}
	else
		this->launch(
			NULL,
			text, width, height,
			threadCnt, threadProc, threadInt, useMutex
			);
}

void DexView::launch(
	WNDPROC wndProc, char *text, int width, int height,
	int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
	)
{
	//=============================================================================
	static WNDCLASS wndClass =
	{
		CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS,
		wndProc ? wndProc : defWndProc,
		0,
		0,
		NULL,
		LoadIcon(NULL, IDI_APPLICATION),
		LoadCursor(NULL, IDC_ARROW),
		wndProc ? NULL : (HBRUSH) GetStockObject(BLACK_BRUSH),
		NULL,
		"DexView"
	};
	RegisterClass(&wndClass);
	HWND hWnd = CreateWindow(
		"DexView", text,
		WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, width, height,
		NULL, NULL, NULL, NULL
		);
	ShowWindow(hWnd, SW_SHOW);
	UpdateWindow(hWnd);
	//=============================================================================
	Thread **thread;
	if (threadCnt)
	{
		thread = new Thread *[threadCnt];
		for (int i = 0; i < threadCnt; i++)
			thread[i] = new Thread(
				i, threadProc[i], threadInt[i], useMutex ? &mMutex : NULL
				);
	}
	//=============================================================================
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0))
	{
		mMutex.acquire();
		TranslateMessage(&msg);
		DispatchMessage(&msg);
		mMutex.release();
	}
	DestroyWindow(hWnd);
	//=============================================================================
	if (threadCnt)
	{
		for (int j = 0; j < threadCnt; j++)
			delete thread[j];
		delete []thread;
	}
	//=============================================================================
}

LRESULT WINAPI defWndProc(HWND hWnd, UINT iMsg, WPARAM wParam, LPARAM lParam)
{
	switch (iMsg)
	{
		case WM_CLOSE:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd, iMsg, wParam, lParam);
	}
	return 0;
}