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

	mDex3D_addGrid("wall", 100, 100, 10, 10);
	mDex3D_alignAxis("wall", DIR::BOTTOM);
	mDex3D_modify("wall", TRANS::ORIGIN, 25, 0, 0);
	mDex3D_modify("wall", TRANS::ANGLE, toRad(60), 0, 0);
	//mDex3D_modify("wall", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("wall", rgb(255, 255, 255));
	//mDex3D_setWire("wall");
	mDex3D_setPhys("wall", 10, 10, 1, 0);

	mDex3D_addBox("box", 10, 10, 10);
	mDex3D_alignAxis("box", DIR::CENTER);
	mDex3D_modify("box", TRANS::ORIGIN, 20, 20, 10);
	//mDex3D_modify("box", TRANS::VEL_ANGLE, toRad(1), toRad(1), toRad(1));
	mDex3D_modify("box", TRANS::VEL_ORIGIN, 0.25f, 0, 0);
	mDex3D_setColor("box", rgb(255, 0, 0));
	mDex3D_setPhys("box", 1, 1, 1, 0);

	mDex3D_addSphere("ball", 5, 16, 16);
	mDex3D_alignAxis("ball", DIR::CENTER);
	mDex3D_modify("ball", TRANS::ORIGIN, -20, 30, 0);
	//mDex3D_modify("ball", TRANS::VEL_ANGLE, toRad(1), toRad(1), toRad(1));
	mDex3D_modify("ball", TRANS::VEL_ORIGIN, 0.25f, 0, 0);
	mDex3D_setColor("ball", rgb(0, 255, 255));
	mDex3D_setPhys("ball", 1, 1, 1, 0);

	mDex3D_addCylndr("cylndr", 5, 10, 16);
	mDex3D_alignAxis("cylndr", DIR::CENTER);
	mDex3D_modify("cylndr", TRANS::ORIGIN, -30, 10, 0);
	//mDex3D_modify("cylndr", TRANS::VEL_ANGLE, toRad(1), toRad(1), toRad(1));
	mDex3D_modify("cylndr", TRANS::VEL_ORIGIN, 0.25f, 0, 0);
	mDex3D_setColor("cylndr", rgb(0, 255, 0));
	//mDex3D_setPhys("cylndr", 1, 1, 1, 0);

	mDex3D_addBox("temp", 10, 10, 10);
	mDex3D_alignAxis("temp", DIR::CENTER);
	mDex3D_modify("temp", TRANS::ORIGIN, -75, -20, 20);
	//mDex3D_modify("temp", TRANS::VEL_ANGLE, toRad(1), toRad(1), toRad(1));
	mDex3D_modify("temp", TRANS::VEL_ORIGIN, 0.25f, 0, 0);
	mDex3D_setColor("temp", rgb(255, 0, 0));
	mDex3D_setPhys("temp", 1, 1, 1, 0);

	mDex3D_relock();

	mDex3D_addBox("left", 1, 1, 1);
	mDex3D_alignAxis("left", DIR::CENTER);
	mDex3D_modify("left", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("left", TRANS::ANGLE, toRad(0), toRad(-90), toRad(0));
	mDex3D_modify("left", TRANS::SCALE, 0.5f, 0.5f, 200);
	mDex3D_setColor("left", rgb(0, 255, 0));

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
	Vector pos;
	mDex3D_query("box", TRANS::ABS_ORIGIN, &pos.x, &pos.y, &pos.z);
	Vector dir;
	mDex3D_query("box", TRANS::ARB_PIVOT_DIR, &dir.x, &dir.y, &dir.z);
	if (dir.mod())
	{
		mDex3D_modify("left", TRANS::ORIGIN, pos.x, pos.y, pos.z);
		pos += dir;
		mDex3D_pointAt("left", pos.x, pos.y, pos.z);
		mDex3D_setVis("left", true);
	}
	else
		mDex3D_setVis("left", false);
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