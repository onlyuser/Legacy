#ifndef H_DEXVIEW
#define H_DEXVIEW

#include <windows.h>
#include "Thread.h"
#include "Mutex.h"
#include "TDexView.h"

class DexView
{
private:
	Mutex mMutex;
public:
	DexView();
	~DexView();
	void launch(
		char *library,
		char *entryWndProc, char *text, int width, int height,
		int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
		);
	void launch(
		WNDPROC wndProc, char *text, int width, int height,
		int threadCnt, THREAD_PROC *threadProc, int *threadInt, bool useMutex
		);
};

void WINAPI pThreadProc(DexView *pThis);

LRESULT WINAPI defWndProc(HWND hWnd, UINT iMsg, WPARAM wParam, LPARAM lParam);

#endif