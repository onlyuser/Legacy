#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h>
#include <comdef.h>
#include "DexSocket.h"
#include "Exception.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static DexSocket mDexSocket;
static bool mModeVB = false;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI DexSocket_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI DexSocket_sum(int a, int b);
char *WINAPI DexSocket_echo(char *text);

void sendError(Exception &e);

int WINAPI DexSocket_open(char *ip, int port);
void WINAPI DexSocket_close(int pSocket);
void WINAPI DexSocket_send(int pSocket, char *data);
void WINAPI DexSocket_recv(int pSocket, char *data);
int WINAPI DexSocket_host(int port);

#endif