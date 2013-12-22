#include "Thread.h"

Thread::Thread(long id, THREAD_PROC pThreadProc, int interval, Mutex *mutex)
{
	mNumID = id;
	mThreadProc = pThreadProc;
	mInterval = interval;
	mMutex = mutex;
	long temp;
	mHandle = CreateThread(
		NULL, 0,
		(THREAD_PROC) threadProc, this,
		0, (unsigned long *) &temp
		);
}

Thread::~Thread()
{
	this->kill();
	CloseHandle(mHandle);
}

void Thread::suspend()
{
	SuspendThread(mHandle);
}

void Thread::resume()
{
	ResumeThread(mHandle);
}

void Thread::kill()
{
	mInterval = -1;
	WaitForSingleObject(mHandle, INFINITE);
}

void Thread::exec()
{
	do
	{
		if (mMutex)
		{
			mMutex->acquire();
			mThreadProc((void *) mNumID);
			mMutex->release();
		}
		else
			mThreadProc((void *) mNumID);
		if (mInterval >= 0)
			Sleep(mInterval);
	}
	while (mInterval >= 0);
}

void WINAPI threadProc(Thread *pThis)
{
	pThis->exec();
}