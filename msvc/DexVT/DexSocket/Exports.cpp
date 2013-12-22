#include "Exports.h"

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason)
	{
		case DLL_PROCESS_ATTACH:
			dll_init();
			break;
		case DLL_PROCESS_DETACH:
			dll_destroy();
	}
	return true;
}

void dll_init()
{
}

void dll_destroy()
{
}

void WINAPI DexSocket_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI DexSocket_sum(int a, int b)
{
	return a + b;
}

char *WINAPI DexSocket_echo(char *text)
{
	return text;
}

void sendError(Exception &e)
{
	if (mFuncMsg)
		if (mModeVB)
		{
			BSTR temp = SysAllocString(_bstr_t(e.getData()));
			mFuncMsg((char *) temp);
			SysFreeString(temp);
		}
		else
			mFuncMsg(e.getData());
}

void WINAPI DexSocket_setModeVB(bool value)
{
	mModeVB = value;
}

int WINAPI DexSocket_open(char *ip, int port)
{
	try
	{
		return (int) mDexSocket.open(ip, port);
	}
	catch (Exception e)
	{
		sendError(e);
	}
	return 0;
}

void WINAPI DexSocket_close(int pSocket)
{
	try
	{
		mDexSocket.close((SOCKET) pSocket);
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

void WINAPI DexSocket_send(int pSocket, char *data)
{
	try
	{
		mDexSocket.sendData((SOCKET) pSocket, data);
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

void WINAPI DexSocket_recv(int pSocket, char *data)
{
	try
	{
		mDexSocket.recvData((SOCKET) pSocket, data);
	}
	catch (Exception e)
	{
		sendError(e);
	}
}

int WINAPI DexSocket_host(int port)
{
	try
	{
		return (int) mDexSocket.host(port);
	}
	catch (Exception e)
	{
		sendError(e);
	}
	return 0;
}