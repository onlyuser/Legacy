#ifndef H_VBCALL
#define H_VBCALL

#include <comdef.h> /* SysAllocString */
#include "string.h"

#ifndef VB_CALL
	#define VB_CALL __stdcall /* export calling convention */
#endif
typedef (VB_CALL *VB_FUNC)(); /* import callback pointer */
typedef (VB_CALL *VB_FUNC2)(char *text); /* import callback pointer */

extern VB_FUNC mEventFunc;
extern VB_FUNC2 mMessageFunc;

void VB_CALL regUserFunc(VB_FUNC eventFunc, VB_FUNC2 messageFunc);
void sleep();
void output(string message);

#endif