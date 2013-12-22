#include "Exports.h"

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason) 
	{ 
		case DLL_PROCESS_ATTACH:
			dll_init();
			break;
		case DLL_PROCESS_DETACH:
			dll_destroy();
	}
	return TRUE;
}

void dll_init()
{
}

void dll_destroy()
{
}

void WINAPI DexCC_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

long WINAPI DexCC_sum(long a, long b)
{
	return a + b;
}

char *WINAPI DexCC_echo(char *text)
{
	return text;
}

void sendError(Exception *e)
{
	if (mFuncMsg != NULL)
		if (mModeVB)
		{
			BSTR bstr = SysAllocString(_bstr_t(e->getData()));
			mFuncMsg((char *) bstr);
			SysFreeString(bstr);
		}
		else
			mFuncMsg(e->getData());
}

void WINAPI DexCC_setModeVB(bool value)
{
	mModeVB = value;
}

void WINAPI DexCC_reset()
{
	mDexCC.reset();
}

void WINAPI DexCC_load(char *filename, char *root)
{
	mDexCC.load(filename, root);
}

void WINAPI DexCC_toString(char *buffer)
{
	mDexCC.toString(buffer);
}

void WINAPI DexCC_buildTable(char *root)
{
	mDexCC.buildTable(root);
}

void WINAPI DexCC_parse(char *root, char *expr, char *buffer)
{
	try
	{
		mDexCC.parse(root, expr ? expr : "", buffer);
	}
	catch (Exception *e)
	{
		sendError(e);
		delete e;
	}
}

void WINAPI DexCC_getFirst(char *expr, char *buffer)
{
	mDexCC.getFirst(expr, buffer);
}

void WINAPI DexCC_getFollow(char *root, char *expr, char *buffer)
{
	mDexCC.getFollow(root, expr, buffer);
}

void WINAPI DexCC_getItems(char *buffer)
{
	mDexCC.getItems(buffer);
}