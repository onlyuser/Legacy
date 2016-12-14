#include "keyBase.h"

keyBase::keyBase(long handle)
{
	/* attributes */
	mHandle = handle;
	mPrevX = 0;
	mPrevY = 0;
	mButton = 0;
	mKeyDown = NULL;
	mKeyUp = NULL;
	mMouseDown = NULL;
	mMouseMove = NULL;
	mMouseUp = NULL;

	/* misc */
	addListener(VK_LBUTTON, true);
	addListener(VK_RBUTTON, true);
	addListener(VK_MBUTTON, true);
	addListener(27, false);
}

keyBase::~keyBase()
{
}

void keyBase::addListener(BYTE key, bool mouseBtn)
{
	keyState *pState;

	pState = new keyState();
	pState->mKey = key;
	pState->mPrevState = 0;
	pState->mMouseBtn = mouseBtn;
	remListener(key);
	mStateList.add(pState);
}

void keyBase::remListener(BYTE key)
{
	keyState *pState;

	for (mStateList.moveFirst(); !mStateList.eof(); mStateList.moveNext())
	{
		pState = mStateList.getData();
		if (pState->mKey == key)
		{
			delete mStateList.remove();
			mStateList.moveEnd();
		}
	}
}

bool keyBase::dispatchEvts(bool &pExit)
{
	bool result;
	POINT cursor;
	RECT window;
	RECT client;
	long x;
	long y;
	keyState *pState;
	long pKeyState;

	result = false;
	if (mHandle == (long) GetForegroundWindow())
	{
		GetCursorPos(&cursor);
		if ((long) WindowFromPoint(cursor) == mHandle)
		{
			GetWindowRect((HWND) mHandle, &window);
			GetClientRect((HWND) mHandle, &client);
			window.right -= window.left;
			window.bottom -= window.top;
			client.left = (window.right - client.right) / 2;
			client.top = (window.bottom - client.bottom) - client.left;
			x = cursor.x - (window.left + client.left);
			y = cursor.y - (window.top + client.top);
			y = client.bottom - y;
			if (x != mPrevX || y != mPrevY)
			{
				mMouseMove(mButton, x, y);
				mPrevX = x;
				mPrevY = y;
				result = true;
			}
		}
		for (mStateList.moveFirst(); !mStateList.eof(); mStateList.moveNext())
		{
			pState = mStateList.getData();
			if (!pState->mMouseBtn)
				pKeyState = GetAsyncKeyState(toupper(pState->mKey));
			else
				pKeyState = GetAsyncKeyState(pState->mKey);
			pKeyState = pKeyState >> 1;
			if (pKeyState != pState->mPrevState)
			{
				if (!pState->mMouseBtn)
				{
					if (pKeyState != 0)
					{
						mKeyDown(pState->mKey);
						if (pState->mKey == 27)
							pExit = true;
					}
					else
						mKeyUp(pState->mKey);
				}
				else
				{
					if (pKeyState != 0)
					{
						mMouseDown(pState->mKey, x, y);
						mButton = pState->mKey;
					}
					else
					{
						mMouseUp(pState->mKey, x, y);
						mButton = 0;
					}
				}
				pState->mPrevState = pKeyState;
				result = true;
			}
		}
	}
	return result;
}

void keyBase::regEvents(
		funcKey pKeyDown,
		funcKey pKeyUp,
		funcMouse pMouseDown,
		funcMouse pMouseMove,
		funcMouse pMouseUp
	)
{
	mKeyDown = pKeyDown;
	mKeyUp = pKeyUp;
	mMouseDown = pMouseDown;
	mMouseMove = pMouseMove;
	mMouseUp = pMouseUp;
}