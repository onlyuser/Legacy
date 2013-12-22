#include "DexSocket.h"

WSException::WSException(char *data) :
	Exception((char *) (std::string(data) + ": " + cstr((int) WSAGetLastError())).c_str())
{
}

//=============================================================================

DexSocket::DexSocket()
{
	WORD wVersionRequested = MAKEWORD(1, 1);
	WSADATA wsaData;
	int retVal = WSAStartup(wVersionRequested, &wsaData);
	if (wsaData.wVersion != wVersionRequested)
		throw Exception("wrong version");
}

DexSocket::~DexSocket()
{
	WSACleanup();
}

//=============================================================================

SOCKET DexSocket::open(char *ip, int port)
{
	int retVal;
	SOCKET pSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (pSocket == INVALID_SOCKET)
	{
		retVal = WSAGetLastError();
		throw WSException("socket()");
	}
    LPHOSTENT lpHostEntry = gethostbyname(ip);
    if (lpHostEntry == NULL)
	{
		retVal = WSAGetLastError();
        throw WSException("gethostbyname()");
	}
	SOCKADDR_IN saServer;
	saServer.sin_family = AF_INET;
	saServer.sin_addr = *((LPIN_ADDR) *lpHostEntry->h_addr_list);
	saServer.sin_port = port;//htons(port);
	retVal = connect(pSocket, (LPSOCKADDR) &saServer, sizeof(struct sockaddr));
	if (retVal == SOCKET_ERROR)
	{
		retVal = WSAGetLastError();
		closesocket(pSocket);
		throw WSException("connect()");
	}
	return pSocket;
}

void DexSocket::close(SOCKET pSocket)
{
	closesocket(pSocket);
}

//=============================================================================

void DexSocket::sendData(SOCKET pSocket, char *data)
{
	int retVal = send(pSocket, data, strlen(data), 0);
	if (retVal == SOCKET_ERROR)
	{
		retVal = WSAGetLastError();
		closesocket(pSocket);
		throw WSException("send()");
	}
}

void DexSocket::recvData(SOCKET pSocket, char *data)
{
	int retVal = recv(pSocket, data, BUFFER_SIZE, 0);
	data[retVal] = '\0';
	if (retVal == SOCKET_ERROR)
	{
		retVal = WSAGetLastError();
		closesocket(pSocket);
		throw WSException("recv()");
	}
}

//=============================================================================

SOCKET DexSocket::host(int port)
{
	int retVal;
	SOCKET listeningSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (listeningSocket == INVALID_SOCKET)
	{
		retVal = WSAGetLastError();
		throw WSException("NETWORK_ERROR");
	}
	SOCKADDR_IN serverInfo;
	serverInfo.sin_family = AF_INET;
	serverInfo.sin_addr.s_addr = INADDR_ANY;
	serverInfo.sin_port = port;//htons(port);
	retVal = bind(listeningSocket, (LPSOCKADDR)&serverInfo, sizeof(struct sockaddr));
	if (retVal == SOCKET_ERROR)
	{
		retVal = WSAGetLastError();
		throw WSException("NETWORK_ERROR");
	}
	retVal = listen(listeningSocket, 10);
	if (retVal == SOCKET_ERROR)
	{
		retVal = WSAGetLastError();
		throw WSException("NETWORK_ERROR");
	}
	SOCKET pSocket = accept(listeningSocket, NULL, NULL);
	if (pSocket == INVALID_SOCKET)
	{
		retVal = WSAGetLastError();
		throw WSException("NETWORK_ERROR");
	}
	closesocket(listeningSocket);
	return pSocket;
}