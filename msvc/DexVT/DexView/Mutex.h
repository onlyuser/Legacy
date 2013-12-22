#ifndef H_MUTEX
#define H_MUTEX

#include <windows.h>

class Mutex
{
private:
	HANDLE mHandle;
public:
	Mutex();
	~Mutex();
	void acquire();
	void release();
};

#endif