#include "DexUser.h"

DexUser::DexUser(
	HINSTANCE libDexGL,
	HINSTANCE libDex3D,
	HINSTANCE libDexSocket,
	HINSTANCE libDexTS
	) :
	DexBase(libDexGL, libDex3D, libDexSocket, libDexTS)
{
}

DexUser::~DexUser()
{
}

void DexUser::load(HWND hWnd)
{
	//=============================================================================
	DexBase::load(hWnd);
	//=============================================================================

	mDex3D_addGrid("grid", 100, 100, 10, 10);
	mDex3D_alignAxis("grid", DIR::BOTTOM);
	mDex3D_modify("grid", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("grid", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("grid", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("grid", rgb(255, 255, 255));
	mDex3D_setWire("grid");

	// build a box, color it red
	mDex3D_addBox("box", 10, 10, 10);
	mDex3D_setColor("box", rgb(255, 0, 0));

	// build 5 boxes, color them randomly
	for (int i = 0; i < 5; i++)
	{
		// build a box, color it randomly
		std::string id = cstr("box") + cstr(i + 1);
		mDex3D_addBox((char *) id.c_str(), 10, 10, 10);
		mDex3D_setColor((char *) id.c_str(), RAND_COLOR);

		// offset the new box so it doesn't touch other boxes
		mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN, (i + 1) * 10, 0, 0);
	}

	this->mouseMove(MOUSE::LEFT, 0, 0);
	this->mouseUp(MOUSE::LEFT, 0, 0);
	this->setSize(480, 480);
}

void DexUser::unload(int &cancel)
{
	//=============================================================================
	DexBase::unload(cancel);
	//=============================================================================
}

void DexUser::resize(int width, int height)
{
	//=============================================================================
	DexBase::resize(width, height);
	//=============================================================================
}

void DexUser::paint(HDC hDC)
{
	//=============================================================================
	DexBase::paint(hDC);
	//=============================================================================
}

bool mToggleHUD = false;
bool mArrowLeft = false;
bool mArrowRight = false;
bool mArrowUp = false;
bool mArrowDown = false;
bool mToggleRun = false;
void DexUser::keyDown(int key)
{
	switch (key)
	{
		case KEY::ESCAPE:
			this->quit();
			break;
		case KEY::TAB:
			mToggleHUD = !mToggleHUD;
			break;
		case KEY::BACKSPACE:
			this->user(GUI::RESET, NULL);
			break;
		case KEY::ARROW_LEFT: mArrowLeft = true; break;
		case KEY::ARROW_RIGHT: mArrowRight = true; break;
		case KEY::ARROW_UP: mArrowUp = true; break;
		case KEY::ARROW_DOWN: mArrowDown = true; break;
		case KEY::SPACE:
			if (mToggleRun = !mToggleRun)
				this->user(GUI::GO, NULL);
			else
				this->user(GUI::STOP, NULL);
	}
}

void DexUser::keyUp(int key)
{
	switch (key)
	{
		case KEY::ARROW_LEFT: mArrowLeft = false; break;
		case KEY::ARROW_RIGHT: mArrowRight = false; break;
		case KEY::ARROW_UP: mArrowUp = false; break;
		case KEY::ARROW_DOWN: mArrowDown = false;
	}
}

int mPrevX = 0;
int mPrevY = 0;
int mDragX;
int mDragY;
Vector mCamTarget;
std::string mCurPick;
Vector mPickAngle;
void DexUser::mouseDown(int button, int x, int y)
{
	mPrevX = x;
	mPrevY = y;
	if ((mCurPick = cstr(mDex3D_pick((float) x / mWidth, (float) y / mHeight))) != "")
	{
		mDex3D_query(
			(char *) mCurPick.c_str(),
			TRANS::ANGLE,
			&mPickAngle.roll, &mPickAngle.pitch, &mPickAngle.yaw
			);
		mDragX = x;
		mDragY = y;
	}
}

float mOrbitSpeed = 0.02f;
float mDollySpeed = 0.4f;
float mLngAngle = 0;
float mLatAngle = toRad(30);
float mRadius = 100;
void DexUser::mouseMove(int button, int x, int y)
{
	if (button != MOUSE::NONE)
	{
		switch (button)
		{
			case MOUSE::LEFT:
				if (mCurPick != "")
					mDex3D_modify(
						(char *) mCurPick.c_str(),
						TRANS::ANGLE,
						mPickAngle.roll,
						mPickAngle.pitch + (y - mDragY) * mOrbitSpeed,
						mPickAngle.yaw + (x - mDragX) * mOrbitSpeed
						);
				else
				{
					mLngAngle += (x - mPrevX) * mOrbitSpeed * -1;
					mLatAngle += (y - mPrevY) * mOrbitSpeed;
					mLngAngle = wrap(mLngAngle, 0, PI * 2);
					mLatAngle = limit(mLatAngle, -PI * 0.5f * 0.99f, PI * 0.5f * 0.99f);
				}
				break;
			case MOUSE::RIGHT:
				mRadius += (y - mPrevY) * mDollySpeed;
				mRadius = max(mRadius, 1);
		}
		mDex3D_orbit(
			mCamTarget.x, mCamTarget.y, mCamTarget.z,
			mRadius, mLngAngle, mLatAngle
			);
		this->setText(trim(
			mCurPick + " " +
			"Yaw=" + cstr((int) toDeg(mLngAngle)) + ", " +
			"Pitch=" + cstr((int) toDeg(mLatAngle)) + ", " +
			"Dist=" + cstr((int) mRadius)
			));
	}
	mPrevX = x;
	mPrevY = y;
}

void DexUser::mouseUp(int button, int x, int y)
{
	mCurPick = "";
}

void DexUser::mouseDblClick()
{
}

void DexUser::timer()
{
	//=============================================================================
	DexBase::timer();
	//=============================================================================
}

void DexUser::timerEx(long id)
{
}

bool mInitGUI = false;
void DexUser::user(long wParam, long lParam)
{
	switch (wParam)
	{
		case GUI::INIT: mInitGUI = true; break;
		case GUI::CONNECT: break;
		case GUI::DISCONNECT: break;
		case GUI::RESET: break;
		case GUI::STOP: break;
		case GUI::GO: break;
	}
}