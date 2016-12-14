#ifndef H_KEYBASE
#define H_KEYBASE

#include "misc.h"

typedef void (*funcKey)(BYTE key);
typedef void (*funcMouse)(long key, long x, long y);

struct keyState
{
	BYTE mKey;
	long mPrevState;
	bool mMouseBtn;
};

class keyBase
{
public:
	List<keyState *> mStateList;
	long mHandle;
	long mPrevX;
	long mPrevY;
	long mButton;
	funcKey mKeyDown;
	funcKey mKeyUp;
	funcMouse mMouseDown;
	funcMouse mMouseMove;
	funcMouse mMouseUp;

	keyBase(long handle);
	~keyBase();
	void addListener(BYTE key, bool mouseBtn);
	void remListener(BYTE key);
	bool dispatchEvts(bool &pExit);
	void regEvents(
		funcKey pKeyDown,
		funcKey pKeyUp,
		funcMouse pMouseDown,
		funcMouse pMouseMove,
		funcMouse pMouseUp
	);
};

#endif