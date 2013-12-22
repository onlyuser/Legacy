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

Vector boxPos(20, 30, 40);
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

	mDex3D_addBox("box", 5, 5, 10);
	mDex3D_alignAxis("box", DIR::CENTER);
	mDex3D_modify("box", TRANS::ORIGIN, boxPos.x, boxPos.y, boxPos.z);
	mDex3D_modify("box", TRANS::ANGLE, toRad(0), toRad(0), toRad(0));
	mDex3D_setColor("box", rgb(255, 255, 255));
	mDex3D_setWire("box");

	mDex3D_addBox("x_axis", 1, 1, 1);
	mDex3D_alignAxis("x_axis", DIR::BACK);
	mDex3D_modify("x_axis", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("x_axis", TRANS::ANGLE, toRad(0), toRad(0), toRad(90));
	mDex3D_modify("x_axis", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_modify("x_axis", TRANS::SCALE, 1, 1, 20);
	mDex3D_setColor("x_axis", rgb(255, 0, 0));
	mDex3D_link("x_axis", "box");

	mDex3D_addBox("y_axis", 1, 1, 1);
	mDex3D_alignAxis("y_axis", DIR::BACK);
	mDex3D_modify("y_axis", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("y_axis", TRANS::ANGLE, toRad(0), toRad(-90), toRad(0));
	mDex3D_modify("y_axis", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_modify("y_axis", TRANS::SCALE, 1, 1, 20);
	mDex3D_setColor("y_axis", rgb(0, 255, 0));
	mDex3D_link("y_axis", "box");

	mDex3D_addBox("z_axis", 1, 1, 1);
	mDex3D_alignAxis("z_axis", DIR::BACK);
	mDex3D_modify("z_axis", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("z_axis", TRANS::ANGLE, toRad(0), toRad(0), toRad(0));
	mDex3D_modify("z_axis", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_modify("z_axis", TRANS::SCALE, 1, 1, 20);
	mDex3D_setColor("z_axis", rgb(0, 0, 255));
	mDex3D_link("z_axis", "box");

	mDex3D_addBox("left", 1, 1, 1);
	mDex3D_alignAxis("left", DIR::BACK);
	mDex3D_modify("left", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("left", TRANS::ANGLE, toRad(0), toRad(0), toRad(0));
	mDex3D_modify("left", TRANS::SCALE, 0.5f, 0.5f, 100);
	mDex3D_setColor("left", rgb(255, 0, 255));

	mDex3D_addBox("vert", 1, 1, 1);
	mDex3D_alignAxis("vert", DIR::BACK);
	mDex3D_modify("vert", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("vert", TRANS::ANGLE, toRad(0), toRad(90), toRad(0));
	mDex3D_modify("vert", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_modify("vert", TRANS::SCALE, 0.5f, 0.5f, 100);
	mDex3D_setColor("vert", rgb(0, 255, 255));

	mDex3D_addCylndr("cyl", 0.5f, 100, 16);
	mDex3D_modify("cyl", TRANS::ANGLE, 0, toRad(90), 0);
	mDex3D_imprint("cyl");
	mDex3D_modify("cyl", TRANS::ORIGIN, 0, 0, 20);
	mDex3D_pointAt("cyl", 1, 1, 21);
	mDex3D_modify("cyl", TRANS::LOCK_ANGLE, 1, 1, 1);

	//mDex3D_modify("box", TRANS::LOCAL_ANGLE, 0, toRad(5), 0);
	//mDex3D_rotLocal("box", 0, 0, toRad(90));

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
		case 'C':
			this->saveImage((char *) (this->getPath() + "test.bmp").c_str());
			break;
		case 'D':
			this->saveDepthMap(
				(char *) (this->getPath() + "test.bmp").c_str(), 10, 1, 0
				);
			break;
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
Vector mCamTarget(0, 0, 0);
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
		/*
		this->setText(trim(
			mCurPick + " " +
			"Yaw=" + cstr((int) toDeg(mLngAngle)) + ", " +
			"Pitch=" + cstr((int) toDeg(mLatAngle)) + ", " +
			"Dist=" + cstr((int) mRadius)
			));
			*/
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

Vector pivotPos(0, 0, 20);
Vector pivotDir(1, 1, 1);
float mIncre = toRad(5);
void DexUser::timer()
{
	if (mArrowLeft)
		mDex3D_modify("box", TRANS::LOCAL_ANGLE, 0, 0, mIncre);
	if (mArrowRight)
		mDex3D_modify("box", TRANS::LOCAL_ANGLE, 0, 0, -mIncre);
	if (mArrowUp)
		mDex3D_modify("box", TRANS::LOCAL_ANGLE, 0, -mIncre, 0);
	if (mArrowDown)
		mDex3D_modify("box", TRANS::LOCAL_ANGLE, 0, mIncre, 0);
	if (mToggleRun)
		mDex3D_rotArb(
			"box",
			pivotPos.x, pivotPos.y, pivotPos.z,
			pivotDir.x, pivotDir.y, pivotDir.z,
			mIncre
			);
	Vector pos;
	mDex3D_query("box", TRANS::ABS_ORIGIN, &pos.x, &pos.y, &pos.z);
	mDex3D_modify("left", TRANS::ORIGIN, pos.x, pos.y, pos.z);
	mDex3D_modify("vert", TRANS::ORIGIN, pos.x, pos.y, pos.z);
	mDex3D_query("box", TRANS::ABS_FRONT, &pos.x, &pos.y, &pos.z);
	mDex3D_pointAt("left", pos.x, pos.y, pos.z);
	mDex3D_query("left", TRANS::ABS_LEFT, &pos.x, &pos.y, &pos.z);
	mDex3D_pointAt("left", pos.x, pos.y, pos.z);
	Vector angle;
	mDex3D_query("box", TRANS::ANGLE, &angle.roll, &angle.pitch, &angle.yaw);
	this->setText(
		"Roll=" + cstr((int) toDeg(angle.roll)) + ", " +
		"Pitch=" + cstr((int) toDeg(angle.pitch)) + ", " +
		"Yaw=" + cstr((int) toDeg(angle.yaw))
		);
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