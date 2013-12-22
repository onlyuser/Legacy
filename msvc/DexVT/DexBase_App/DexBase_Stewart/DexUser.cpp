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

int PADDING = 2;
int HUD_COUNT = 6 + 2;
void DexUser::load(HWND hWnd)
{
	//=============================================================================
	DexBase::load(hWnd);
	//=============================================================================

	float offset = 0;
	for (int i = 0; i < HUD_COUNT; i++)
	{
		std::string id = cstr("hud") + cstr(i + 1);
		mDex3D_addHud((char *) id.c_str(), 0, 0);
		mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN, -0.4f, 0.4f + offset, 0);
		mDex3D_setColor((char *) id.c_str(), rgb(0, 255, 0));
		if (i == 5)
			offset = -0.4f - 0.4f;
		else if (i == 6)
			offset = -0.4f - 0.4f + 0.05f;
		else
			offset -= 0.05f;
	}

	float baseHgt = 0;

	mDex3D_addGrid("grid", 100, 100, 10, 10);
	mDex3D_alignAxis("grid", DIR::BOTTOM);
	mDex3D_modify("grid", TRANS::ORIGIN, 0, baseHgt, 0);
	mDex3D_modify("grid", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("grid", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("grid", rgb(255, 255, 255));
	mDex3D_setWire("grid");

	baseHgt += 0;

	//=========================================================
	mDex3D_addBox("beam1", 40, 2, 4);
	mDex3D_alignAxis("beam1", DIR::BOTTOM);
	mDex3D_modify("beam1", TRANS::ORIGIN, 0, baseHgt, -20);
	mDex3D_modify("beam1", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("beam1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("beam1", rgb(0, 0, 255));
	//=========================================================
	mDex3D_addBox("beam2", 40, 2, 4);
	mDex3D_alignAxis("beam2", DIR::BOTTOM);
	mDex3D_modify("beam2", TRANS::ORIGIN, 0, baseHgt, 20);
	mDex3D_modify("beam2", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("beam2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("beam2", rgb(0, 0, 255));
	//=========================================================
	mDex3D_addBox("beam3", 4, 2, 40);
	mDex3D_alignAxis("beam3", DIR::BOTTOM);
	mDex3D_modify("beam3", TRANS::ORIGIN, -20, baseHgt, 0);
	mDex3D_modify("beam3", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("beam3", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("beam3", rgb(0, 0, 255));
	//=========================================================
	mDex3D_addBox("beam4", 4, 2, 40);
	mDex3D_alignAxis("beam4", DIR::BOTTOM);
	mDex3D_modify("beam4", TRANS::ORIGIN, 20, baseHgt, 0);
	mDex3D_modify("beam4", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("beam4", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("beam4", rgb(0, 0, 255));
	//=========================================================

	//=========================================================
	mDex3D_addBox("m_beam1", 40, 2, 4);
	mDex3D_alignAxis("m_beam1", DIR::BOTTOM);
	mDex3D_modify("m_beam1", TRANS::ORIGIN, 0, baseHgt, -10);
	mDex3D_modify("m_beam1", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("m_beam1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("m_beam1", rgb(0, 0, 255));
	//=========================================================
	mDex3D_addBox("m_beam2", 40, 2, 4);
	mDex3D_alignAxis("m_beam2", DIR::BOTTOM);
	mDex3D_modify("m_beam2", TRANS::ORIGIN, 0, baseHgt, 10);
	mDex3D_modify("m_beam2", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("m_beam2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("m_beam2", rgb(0, 0, 255));
	//=========================================================

	baseHgt += 2;

	//=========================================================
	mDex3D_addCylndr("base1", 20, 2, 3);
	//mDex3D_alignAxis("base1", DIR::BOTTOM);
	mDex3D_modify("base1", TRANS::ORIGIN, 0, baseHgt, 0);
	mDex3D_modify("base1", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("base1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("base1", rgb(255, 255, 0));
	//=========================================================
	mDex3D_addCylndr("base2", 20, 2, 3);
	//mDex3D_alignAxis("base2", DIR::BOTTOM);
	mDex3D_modify("base2", TRANS::ORIGIN, 0, baseHgt + 20, 0);
	mDex3D_modify("base2", TRANS::ANGLE, 0, 0, toRad(180));
	//mDex3D_modify("base2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("base2");
	mDex3D_setAxis("base2", 0, baseHgt + 20, 0);
	mDex3D_setColor("base2", rgb(255, 255, 0));
	//=========================================================
	mDex3D_addBox("box", 10, 7.5, 15);
	mDex3D_alignAxis("box", DIR::BOTTOM);
	mDex3D_modify("box", TRANS::ORIGIN, 0, baseHgt, 0);
	mDex3D_modify("box", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("box", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("box", rgb(100, 100, 100));
	//=========================================================
	mDex3D_addBox("seatBase", 10, 2, 15);
	mDex3D_alignAxis("seatBase", DIR::BOTTOM);
	mDex3D_modify("seatBase", TRANS::ORIGIN, 0, 2 + 2, 0);
	mDex3D_modify("seatBase", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("seatBase", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("seatBase", rgb(255, 0, 0));
	mDex3D_link("seatBase", "base2");
	//=========================================================
	mDex3D_addBox("seatBack", 10, 20, 2);
	mDex3D_alignAxis("seatBack", DIR::BOTTOM);
	mDex3D_modify("seatBack", TRANS::ORIGIN, 0, 2 + 2, 5);
	mDex3D_modify("seatBack", TRANS::ANGLE, 0, toRad(5), 0);
	mDex3D_modify("seatBack", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("seatBack", rgb(255, 0, 0));
	mDex3D_link("seatBack", "base2");
	//=========================================================
	mDex3D_addBox("seatArmR", 2, 5, 10);
	mDex3D_alignAxis("seatArmR", DIR::BOTTOM);
	mDex3D_modify("seatArmR", TRANS::ORIGIN, 5 + 1, 2, 0);
	mDex3D_modify("seatArmR", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("seatArmR", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("seatArmR", rgb(255, 0, 0));
	mDex3D_link("seatArmR", "base2");
	//=========================================================
	mDex3D_addBox("seatArmL", 2, 5, 10);
	mDex3D_alignAxis("seatArmL", DIR::BOTTOM);
	mDex3D_modify("seatArmL", TRANS::ORIGIN, -5 - 1, 2, 0);
	mDex3D_modify("seatArmL", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("seatArmL", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("seatArmL", rgb(255, 0, 0));
	mDex3D_link("seatArmL", "base2");
	//=========================================================

	baseHgt += 2;

	Vector v1;
	Vector v2;

	v1 = Vector(0, 0, 20);
	v2 = Vector(0, 0, -20);
	//=========================================================
	mDex3D_addSphere("ballBtm1", 2, 12, 12);
	mDex3D_alignAxis("ballBtm1", DIR::CENTER);
	mDex3D_modify("ballBtm1", TRANS::ORIGIN, v1.x, v1.y, v1.z);
	mDex3D_modify("ballBtm1", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballBtm1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballBtm1", rgb(255, 0, 0));
	mDex3D_link("ballBtm1", "base1");
	mDex3D_setText("ballBtm1", (char *) (repeat(" ", PADDING) + "A1").c_str());
	//=========================================================
	mDex3D_addSphere("ballTop1", 2, 12, 12);
	mDex3D_alignAxis("ballTop1", DIR::CENTER);
	mDex3D_modify("ballTop1", TRANS::ORIGIN, v2.x, v2.y, v2.z);
	mDex3D_modify("ballTop1", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballTop1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballTop1", rgb(255, 0, 0));
	mDex3D_link("ballTop1", "base2");
	mDex3D_setText("ballTop1", (char *) (repeat(" ", PADDING) + "B1").c_str());
	//=========================================================
	mDex3D_addCylndr("shaft1", 1, 1, 8);
	mDex3D_alignAxis("shaft1", DIR::BOTTOM);
	mDex3D_modify("shaft1", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft1", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft1", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft1");
	mDex3D_setColor("shaft1", rgb(255, 255, 255));
	//=========================================================
	mDex3D_addCylndr("shaft2", 1, 1, 8);
	mDex3D_alignAxis("shaft2", DIR::BOTTOM);
	mDex3D_modify("shaft2", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft2", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft2");
	mDex3D_setColor("shaft2", rgb(255, 255, 255));
	//=========================================================

	v1 = Vector(10 * sqrt(3), 0, -10);
	v2 = Vector(-10 * sqrt(3), 0, 10);
	//=========================================================
	mDex3D_addSphere("ballBtm2", 2, 12, 12);
	mDex3D_alignAxis("ballBtm2", DIR::CENTER);
	mDex3D_modify("ballBtm2", TRANS::ORIGIN, v1.x, v1.y, v1.z);
	mDex3D_modify("ballBtm2", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballBtm2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballBtm2", rgb(0, 255, 0));
	mDex3D_link("ballBtm2", "base1");
	mDex3D_setText("ballBtm2", (char *) (repeat(" ", PADDING) + "A2").c_str());
	//=========================================================
	mDex3D_addSphere("ballTop2", 2, 12, 12);
	mDex3D_alignAxis("ballTop2", DIR::CENTER);
	mDex3D_modify("ballTop2", TRANS::ORIGIN, v2.x, v2.y, v2.z);
	mDex3D_modify("ballTop2", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballTop2", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballTop2", rgb(0, 255, 0));
	mDex3D_link("ballTop2", "base2");
	mDex3D_setText("ballTop2", (char *) (repeat(" ", PADDING) + "B2").c_str());
	//=========================================================
	mDex3D_addCylndr("shaft3", 1, 1, 8);
	mDex3D_alignAxis("shaft3", DIR::BOTTOM);
	mDex3D_modify("shaft3", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft3", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft3", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft3");
	mDex3D_setColor("shaft3", rgb(255, 255, 255));
	//=========================================================
	mDex3D_addCylndr("shaft4", 1, 1, 8);
	mDex3D_alignAxis("shaft4", DIR::BOTTOM);
	mDex3D_modify("shaft4", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft4", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft4", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft4");
	mDex3D_setColor("shaft4", rgb(255, 255, 255));
	//=========================================================

	v1 = Vector(-10 * sqrt(3), 0, -10);
	v2 = Vector(10 * sqrt(3), 0, 10);
	//=========================================================
	mDex3D_addSphere("ballBtm3", 2, 12, 12);
	mDex3D_alignAxis("ballBtm3", DIR::CENTER);
	mDex3D_modify("ballBtm3", TRANS::ORIGIN, v1.x, v1.y, v1.z);
	mDex3D_modify("ballBtm3", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballBtm3", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballBtm3", rgb(0, 255, 255));
	mDex3D_link("ballBtm3", "base1");
	mDex3D_setText("ballBtm3", (char *) (repeat(" ", PADDING) + "A3").c_str());
	//=========================================================
	mDex3D_addSphere("ballTop3", 2, 12, 12);
	mDex3D_alignAxis("ballTop3", DIR::CENTER);
	mDex3D_modify("ballTop3", TRANS::ORIGIN, v2.x, v2.y, v2.z);
	mDex3D_modify("ballTop3", TRANS::ANGLE, 0, 0, 0);
	mDex3D_modify("ballTop3", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setColor("ballTop3", rgb(0, 255, 255));
	mDex3D_link("ballTop3", "base2");
	mDex3D_setText("ballTop3", (char *) (repeat(" ", PADDING) + "B3").c_str());
	//=========================================================
	mDex3D_addCylndr("shaft5", 1, 1, 8);
	mDex3D_alignAxis("shaft5", DIR::BOTTOM);
	mDex3D_modify("shaft5", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft5", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft5", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft5");
	mDex3D_setColor("shaft5", rgb(255, 255, 255));
	//=========================================================
	mDex3D_addCylndr("shaft6", 1, 1, 8);
	mDex3D_alignAxis("shaft6", DIR::BOTTOM);
	mDex3D_modify("shaft6", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("shaft6", TRANS::ANGLE, 0, toRad(90), 0);
	//mDex3D_modify("shaft6", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("shaft6");
	mDex3D_setColor("shaft6", rgb(255, 255, 255));
	//=========================================================

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
	int i, j;
	switch (key)
	{
		case KEY::ESCAPE:
			this->quit();
			break;
		case KEY::TAB:
			for (i = 0; i < HUD_COUNT; i++)
			{
				std::string id = cstr("hud") + cstr(i + 1);
				mDex3D_setVis((char *) id.c_str(), mToggleHUD);
			}
			for (j = 0; j < 3; j++)
			{
				std::string id1 = cstr("ballTop") + cstr(j + 1);
				mDex3D_setVis((char *) id1.c_str(), mToggleHUD);
				std::string id2 = cstr("ballBtm") + cstr(j + 1);
				mDex3D_setVis((char *) id2.c_str(), mToggleHUD);
			}
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

float PUMP_LENGTH = 20;
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
		if (mCurPick != "")
		{
			Vector basePos;
			mDex3D_query("base2", TRANS::ABS_ORIGIN, &basePos.x, &basePos.y, &basePos.z);
			int prevIndex = -1, index2;
			for (int i = 0; i < 6; i++)
			{
				int index1 = i >> 1;
				if (index1 != prevIndex)
				{
					prevIndex = index1;
					index2 = (index1 + 1) % 3;
				}
				//=========================================================
				Vector v1, v2;
				mDex3D_query(
					(char *) (cstr("ballBtm") + cstr(index1 + 1)).c_str(),
					TRANS::ABS_ORIGIN, &v1.x, &v1.y, &v1.z
					);
				mDex3D_query(
					(char *) (cstr("ballTop") + cstr(index2 + 1)).c_str(),
					TRANS::ABS_ORIGIN, &v2.x, &v2.y, &v2.z
					);
				//=========================================================
				std::string id = cstr("shaft") + cstr(i + 1);
				mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN, v1.x, v1.y, v1.z);
				float dist = v1.dist(v2);
				mDex3D_modify((char *) id.c_str(), TRANS::SCALE, 1, 1, dist);
				mDex3D_pointAt((char *) id.c_str(), v2.x, v2.y, v2.z);
				std::string label =
					cstr("A") + cstr(index1 + 1) + "-B" + cstr(index2 + 1);
				mDex3D_setText(
					(char *) (cstr("hud") + cstr(i + 1)).c_str(),
					(char *) (cstr("[") + label + "]: " + cstr(dist)).c_str()
					);
				//=========================================================
				index2 = (index2 + 1) % 3;
			}
			//=========================================================
			Vector pos;
			mDex3D_query("base2", TRANS::ORIGIN, &pos.x, &pos.y, &pos.z);
			mDex3D_setText(
				"hud7",
				(char *) (
					cstr("X=") + cstr(pos.x) + "," +
					cstr("Y=") + cstr(pos.y) + "," +
					cstr("Z=") + cstr(pos.z)
					).c_str()
				);
			//=========================================================
			Vector angle;
			mDex3D_query("base2", TRANS::ANGLE, &angle.roll, &angle.pitch, &angle.yaw);
			mDex3D_setText(
				"hud8",
				(char *) (
					cstr("R=") + cstr(toDeg(angle.roll)) + "," +
					cstr("P=") + cstr(toDeg(angle.pitch)) + "," +
					cstr("Y=") + cstr(toDeg(angle.yaw))
					).c_str()
				);
			//=========================================================
		}
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