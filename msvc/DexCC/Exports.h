#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h> // WINAPI
#include <comdef.h> // _bstr_t()
#include "DexCC.h"
#include "Exception.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(char *text);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

static DexCC mDexCC;
static bool mModeVB = false;

void WINAPI DexCC_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
long WINAPI DexCC_sum(long a, long b);
char *WINAPI DexCC_echo(char *text);

void sendError(Exception *e);

void WINAPI DexCC_setModeVB(bool value);
void WINAPI DexCC_reset();
void WINAPI DexCC_load(char *filename, char *root);
void WINAPI DexCC_toString(char *buffer);
void WINAPI DexCC_buildTable(char *root);
void WINAPI DexCC_parse(char *root, char *expr, char *buffer);
void WINAPI DexCC_getFirst(char *expr, char *buffer);
void WINAPI DexCC_getFollow(char *root, char *expr, char *buffer);
void WINAPI DexCC_getItems(char *buffer);

#endif