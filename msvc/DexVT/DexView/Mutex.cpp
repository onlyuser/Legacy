#include "Mutex.h"

Mutex::Mutex()
{
	mHandle = CreateMutex(NULL, false, NULL);
}

Mutex::~Mutex()
{
	CloseHandle(mHandle);
}

void Mutex::acquire()
{
	WaitForSingleObject(mHandle, INFINITE);
}

void Mutex::release()
{
	ReleaseMutex(mHandle);
}