#ifndef H_TDEXCALC
#define H_TDEXCALC

#include <windows.h> // WINAPI

//=============================================================================
typedef VOID (WINAPI *DEXCALC_SETMODEVB)(BOOL);
typedef VOID (WINAPI *DEXCALC_CHANGEBSE)(LPSTR, INT, INT, LPSTR);
//=============================================================================
typedef VOID (WINAPI *DEXCALC_ENTERSCPE)();
typedef INT (WINAPI *DEXCALC_EXITSCOPE)();
typedef VOID (WINAPI *DEXCALC_RESET)();
//=============================================================================
typedef VOID (WINAPI *DEXCALC_SETTURBO)(BOOL);
typedef LPSTR (WINAPI *DEXCALC_COMPILE)(LPSTR);
//=============================================================================
typedef FLOAT (WINAPI *DEXCALC_EVAL)(LPSTR);
typedef VOID (WINAPI *DEXCALC_DEFVAR)(LPSTR);
typedef VOID (WINAPI *DEXCALC_UNDEFVAR)(LPSTR);
//=============================================================================

#endif