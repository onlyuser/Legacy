#ifndef H_THREAD
#define H_THREAD

#include "Mutex.h"

typedef LPTHREAD_START_ROUTINE THREAD_PROC;

class Thread
{
private:
	long mNumID;
	THREAD_PROC mThreadProc;
	int mInterval;
	Mutex *mMutex;
	HANDLE mHandle;
public:
	Thread(long id, THREAD_PROC pThreadProc, int interval, Mutex *mutex);
	~Thread();
	void suspend();
	void resume();
	void kill();
	void exec();
};

void WINAPI threadProc(Thread *pThis);

#endif