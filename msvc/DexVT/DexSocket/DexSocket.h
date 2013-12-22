#ifndef H_DEXSOCKET
#define H_DEXSOCKET

#include <stdio.h>
#include <winsock.h>
#include "Exception.h"
#include "String.h"
#include "TDexSocket.h"

#define BUFFER_SIZE 80

class WSException : public Exception
{
public:
	WSException(char *data);
};

class DexSocket
{
private:
	int mPort;
public:
	DexSocket();
	~DexSocket();
	//=============================================================================
	SOCKET open(char *ip, int port);
	void close(SOCKET pSocket);
	//=============================================================================
	void sendData(SOCKET pSocket, char *data);
	void recvData(SOCKET pSocket, char *data);
	//=============================================================================
	SOCKET host(int port);
	//=============================================================================
};

#endif