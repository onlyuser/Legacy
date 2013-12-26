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

void WINAPI DexCalc_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI DexCalc_sum(int a, int b)
{
	return a + b;
}

char *WINAPI DexCalc_echo(char *text)
{
	return text;
}

void sendError(Exception &e)
{
	if (mFuncMsg != NULL)
		if (mModeVB)
		{
			BSTR temp = SysAllocString(_bstr_t(e.getData()));
			mFuncMsg((char *) temp);
			SysFreeString(temp);
		}
		else
			mFuncMsg(e.getData());
}

//=============================================================================

void WINAPI DexCalc_setModeVB(bool value)
{
	mModeVB = value;
}

void WINAPI DexCalc_changeBse(char *expr, int base, int newBase, char *buffer)
{
	strcpy(buffer, (char *) changeBase(expr, base, newBase).c_str());
}

//=============================================================================

void WINAPI DexCalc_enterScpe()
{
	try
	{
		mDexCalc.enterScope();
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

int WINAPI DexCalc_exitScope()
{
	try
	{
		return mDexCalc.exitScope();
	}
	catch (Exception e)
	{
		sendError(e);
	}
	return 0;
}

void WINAPI DexCalc_reset()
{
	try
	{
		mDexCalc.reset();
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

//=============================================================================

void WINAPI DexCalc_setTurbo(bool value)
{
	try
	{
		mDexCalc.setTurbo(value);
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

char *WINAPI DexCalc_compile(char *expr)
{
	try
	{
		return (char *) mDexCalc.compile(expr).c_str();
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

//=============================================================================

float WINAPI DexCalc_eval(char *expr)
{
	try
	{
		return mDexCalc.eval(cstr(expr));
	}
	catch (Exception e)
	{
		sendError(e);
	}
	return 0;
}

void WINAPI DexCalc_defVar(char *var)
{
	try
	{
		mDexCalc.defVar(cstr(var));
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

void WINAPI DexCalc_undefVar(char *var)
{
	try
	{
		mDexCalc.undefVar(cstr(var));
	}
	catch (Exception e)
	{
		sendError(e);
	}
}