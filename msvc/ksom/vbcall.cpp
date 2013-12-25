#include "vbcall.h"

VB_FUNC mEventFunc;
VB_FUNC2 mMessageFunc;

void VB_CALL regUserFunc(VB_FUNC eventFunc, VB_FUNC2 messageFunc)
{
	mEventFunc = eventFunc;
	mMessageFunc = messageFunc;
}

void sleep()
{
	mEventFunc();
}

void output(string message)
{
	mMessageFunc((char *) SysAllocString((_bstr_t) c_str(message)));
	mEventFunc();
}