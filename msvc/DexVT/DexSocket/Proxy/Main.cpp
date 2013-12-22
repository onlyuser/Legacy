#include <windows.h>
#include <winsock.h>
#include "TDexSocket.h"
#include "String.h"

/*
#define IP "127.0.0.1"
#define IN_PORT 6666
#define OUT_PORT 6667
*/

std::string getPath()
{
	char buf[256];
	GetModuleFileName(NULL, buf, 256);
	std::string temp = std::string(buf);
	long pos = findLast(temp, "\\");
	return left(temp, pos) + "\\";
}

void main()
{
	//=============================================================================
	// PROXY PROGRAM
	//=============================================================================

	HINSTANCE instLib = LoadLibrary("DexSocket.dll");

	// get function pointers
	DEXSOCKET_OPEN dexSocket_open =
		(DEXSOCKET_OPEN) GetProcAddress(instLib, "DexSocket_open");
	DEXSOCKET_CLOSE dexSocket_close =
		(DEXSOCKET_CLOSE) GetProcAddress(instLib, "DexSocket_close");
	DEXSOCKET_SEND dexSocket_send =
		(DEXSOCKET_SEND) GetProcAddress(instLib, "DexSocket_send");
	DEXSOCKET_RECV dexSocket_recv =
		(DEXSOCKET_RECV) GetProcAddress(instLib, "DexSocket_recv");
	DEXSOCKET_HOST dexSocket_host =
		(DEXSOCKET_HOST) GetProcAddress(instLib, "DexSocket_host");

	// read INI
	std::string text = loadText(getPath() + "proxy.ini");
	std::string IP;
	int IN_PORT, OUT_PORT;
	int i = 0;
	while (i < text.length())
	{
		std::string token = scanText(text, i, "\r\n");
		std::string LHS = getEntry(token, "=", 0);
		std::string RHS = getEntry(token, "=", 1);
		if (LHS == "IP") IP = RHS;
		if (LHS == "IN_PORT") IN_PORT = val(RHS);
		if (LHS == "OUT_PORT") OUT_PORT = val(RHS);
	}

	// open proxy sockets
	SOCKET in_socket = dexSocket_host(IN_PORT);
	SOCKET out_socket = dexSocket_open((char *) IP.c_str(), OUT_PORT);

	// proxy loop
	char buffer[256] = "";
	do
	{
		dexSocket_recv(in_socket, buffer);
		dexSocket_send(out_socket, buffer);
	} while (strcmp(buffer, "stop"));

	// close proxy sockets
	dexSocket_close(in_socket);
	dexSocket_close(out_socket);

	FreeLibrary(instLib);
}