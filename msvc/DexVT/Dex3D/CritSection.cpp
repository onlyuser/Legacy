#include "CritSection.h"

CritSection::CritSection()
{
	InitializeCriticalSection(&mCritSection);
}

CritSection::~CritSection()
{
	DeleteCriticalSection(&mCritSection);
}

void CritSection::enter()
{
	EnterCriticalSection(&mCritSection);
}

void CritSection::leave()
{
	LeaveCriticalSection(&mCritSection);
}