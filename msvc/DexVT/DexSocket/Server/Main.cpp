#include <windows.h>
#include <winsock.h>
#include "TDexSocket.h"

#define PORT 6666

void main()
{
	//=============================================================================
	// SERVER PROGRAM
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

	// host listen socket on PORT
	SOCKET socket = dexSocket_host(PORT);

	// send "PING" to client
	dexSocket_send(socket, "PING");

	// recieve "PONG" from client
	char buffer[256] = "";
	dexSocket_recv(socket, buffer);

	// close listen socket
	dexSocket_close(socket);

	FreeLibrary(instLib);
}