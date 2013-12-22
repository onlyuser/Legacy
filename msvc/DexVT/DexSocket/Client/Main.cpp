#include <windows.h>
#include <winsock.h>
#include "TDexSocket.h"

#define IP "127.0.0.1"
#define PORT 6666

void main()
{
	//=============================================================================
	// CLIENT PROGRAM
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

	// open client socket at IP, PORT
	SOCKET socket = dexSocket_open(IP, PORT);

	// recieve "PING" from server
	char buffer[256] = "";
	dexSocket_recv(socket, buffer);

	// send "PONG" to server
	dexSocket_send(socket, "PONG");

	// close client socket
	dexSocket_close(socket);

	FreeLibrary(instLib);
}