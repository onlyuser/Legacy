#ifndef H_CRITSECTION
#define H_CRITSECTION

#include <windows.h> // CRITICAL_SECTION

class CritSection
{
private:
	CRITICAL_SECTION mCritSection;
public:
	CritSection();
	~CritSection();
	void enter();
	void leave();
};

#endif