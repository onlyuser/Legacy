#ifndef H_TDEXSOCKET
#define H_TDEXSOCKET

#include <windows.h>

//=============================================================================
typedef INT (WINAPI *DEXSOCKET_OPEN)(LPSTR, INT);
typedef VOID (WINAPI *DEXSOCKET_CLOSE)(INT);
typedef VOID (WINAPI *DEXSOCKET_SEND)(INT, LPSTR);
typedef VOID (WINAPI *DEXSOCKET_RECV)(INT, LPSTR);
//=============================================================================

#endif