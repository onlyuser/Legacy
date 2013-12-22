#ifndef H_TDEXVIEW
#define H_TDEXVIEW

#include <windows.h>

typedef LPTHREAD_START_ROUTINE THREAD_PROC;

//=============================================================================
typedef VOID (WINAPI *DEXVIEW_LAUNCHEX)(
	LPSTR,
	LPSTR, LPSTR, INT, INT,
	INT, THREAD_PROC *, PINT, BOOL
	);
typedef VOID (WINAPI *DEXVIEW_LAUNCH)(
	WNDPROC, LPSTR, INT, INT,
	INT, THREAD_PROC *, PINT, BOOL
	);
//=============================================================================

#endif