#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h> // WINAPI
#include <comdef.h> // _bstr_t()
#include "DexCalc.h"
#include "String.h"
#include "Exception.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR text);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static DexCalc mDexCalc;
static bool mModeVB = false;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI DexCalc_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI DexCalc_sum(int a, int b);
char *WINAPI DexCalc_echo(char *text);

void sendError(Exception &e);

//=============================================================================
void WINAPI DexCalc_setModeVB(bool value);
void WINAPI DexCalc_changeBse(char *expr, int base, int newBase, char *buffer);
//=============================================================================
void WINAPI DexCalc_enterScpe();
int WINAPI DexCalc_exitScope();
void WINAPI DexCalc_reset();
//=============================================================================
void WINAPI DexCalc_setTurbo(bool value);
char *WINAPI DexCalc_compile(char *expr);
//=============================================================================
float WINAPI DexCalc_eval(char *expr);
void WINAPI DexCalc_defVar(char *var);
void WINAPI DexCalc_undefVar(char *var);
//=============================================================================

#endif