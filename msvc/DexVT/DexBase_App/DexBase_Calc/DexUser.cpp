#include "DexUser.h"

DexUser::DexUser(
	HINSTANCE libDexGL,
	HINSTANCE libDex3D,
	HINSTANCE libDexSocket,
	HINSTANCE libDexCalc
	) :
	DexBase(libDexGL, libDex3D, libDexSocket, libDexCalc)
{
}

DexUser::~DexUser()
{
}

int PADDING = 2;
void DexUser::plotGraph(
	std::string func, bool radial,
	float minX, float maxX, float minZ, float maxZ,
	int stepX, int stepZ, float width, float length, float height
	)
{
	mDexCalc_setTurbo(true);
	//=========================================================
	std::string newFunc = cstr(mDexCalc_compile((char *) func.c_str()));
	std::string arg1, arg2;
	arg1 = cstr(mDexCalc_compile(radial ? "y=" : "x="));
	arg2 = cstr(mDexCalc_compile(radial ? "p=" : "z="));
	mDex3D_clear();
	if (radial)
		mDex3D_addSphere("grid", 0, stepX - 1, (stepZ - 1) * 2);
	else
		mDex3D_addGrid("grid", 0, 0, stepX, stepZ);
	mDexCalc_eval(radial ? "var(y)" : "var(x)");
	mDexCalc_eval(radial ? "var(p)" : "var(z)");
	mDexCalc_eval(radial ? "var(r)" : "var(y)");
	//=========================================================
	float pMin = BIG_NUMBER, pMax = -BIG_NUMBER;
	int vertCnt = 0;
	for (int i = 0; i < stepX; i++)
		for (int j = 0; j < stepZ; j++)
		{
			Vector v;
			v.x = 1 - (float) i / (stepX - 1);
			v.z = 1 - (float) j / (stepZ - 1);
			if (radial)
			{
				v.x = interp(0, PI * 2, v.x);
				v.z = interp(0, PI, v.z);
			}
			else
			{
				v.x = interp(minX, maxX, v.x);
				v.z = interp(minZ, maxZ, v.z);
			}
			if (!radial || (inRange(v.x, minX, maxX) && inRange(v.z, minZ, maxZ)))
			{
				mDexCalc_eval((char *) (arg1 + cstr(v.x)).c_str());
				mDexCalc_eval((char *) (arg2 + cstr(v.z)).c_str());
				mDexCalc_eval((char *) newFunc.c_str());
				v.y = mDexCalc_eval(radial ? "r" : "y");
			}
			else
				v.y = 0;
			if (radial)
			{
				Vector angle(0, v.z - PI * 0.5f, v.x);
				v = angle.fromAngle(angle) * v.y;
			}
			mDex3D_setVertex("grid", vertCnt++, v.x, v.y, v.z);
			if (!radial)
			{
				pMin = min(v.y, pMin);
				pMax = max(v.y, pMax);
			}
		}
	mDexCalc_setTurbo(false);
	mDexCalc_reset();
	mDex3D_relockMsh("grid");
	//=========================================================
	if (radial)
		mDex3D_normalize("grid");
	else
	{
		mDex3D_modify(
			"grid",
			TRANS::SCALE,
			1 / (maxX - minX),
			((pMax > pMin) ? 1 / (pMax - pMin) : 0),
			1 / (maxZ - minZ)
			);
		mDex3D_imprint("grid");
	}
	mDex3D_modify("grid", TRANS::SCALE, width, height, length);
	mDex3D_imprint("grid");
	mDex3D_alignAxis("grid", DIR::CENTER);
	mDex3D_modify("grid", TRANS::ORIGIN, 0, 0, 0);
	//=========================================================
	mDex3D_setTexMap(
		"grid",
		(char *) (this->getPath() + "rb_v.bmp").c_str(),
		"",
		0,
		radial ? DIR::RADIAL_SPHERE : DIR::FRONT
		);
	//=========================================================
	mDex3D_addBox("box", width, height, length);
	mDex3D_alignAxis("box", DIR::CENTER);
	mDex3D_modify("box", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_setAlpha("box", 0.5f);
	//=========================================================

	//=========================================================
	Vector origin(-width / 2, -height / 2, -length / 2);
	mDex3D_addSphere("origin", 1, 8, 8);
	mDex3D_modify("origin", TRANS::ORIGIN, origin.x, origin.y, origin.z);
	//=========================================================

	//=========================================================
	mDex3D_addCylndr("x_beam", 0.5f, width, 8);
	mDex3D_modify("x_beam", TRANS::ORIGIN, origin.x, origin.y, origin.z);
	mDex3D_modify("x_beam", TRANS::ANGLE, 0, toRad(90), toRad(90));
	mDex3D_setColor("x_beam", rgb(255, 0, 0));
	//=========================================================
	mDex3D_addCone("x_arrow", 1, 2, 8);
	mDex3D_modify("x_arrow", TRANS::ORIGIN, origin.x + width, origin.y, origin.z);
	mDex3D_modify("x_arrow", TRANS::ANGLE, 0, toRad(90), toRad(90));
	mDex3D_setColor("x_arrow", rgb(255, 0, 0));
	mDex3D_setFont("x_arrow", "fixedsys", 16, true, false, false, false);
	mDex3D_setText("x_arrow", (char *) (repeat(" ", PADDING) + "X").c_str());
	//=========================================================

	//=========================================================
	mDex3D_addCylndr("y_beam", 0.5f, height, 8);
	mDex3D_modify("y_beam", TRANS::ORIGIN, origin.x, origin.y, origin.z);
	mDex3D_modify("y_beam", TRANS::ANGLE, 0, 0, 0);
	mDex3D_setColor("y_beam", rgb(0, 255, 0));
	//=========================================================
	mDex3D_addCone("y_arrow", 1, 2, 8);
	mDex3D_modify("y_arrow", TRANS::ORIGIN, origin.x, origin.y + height, origin.z);
	mDex3D_modify("y_arrow", TRANS::ANGLE, 0, 0, 0);
	mDex3D_setColor("y_arrow", rgb(0, 255, 0));
	mDex3D_setFont("y_arrow", "fixedsys", 16, true, false, false, false);
	mDex3D_setText("y_arrow", (char *) (repeat(" ", PADDING) + "Y").c_str());
	//=========================================================

	//=========================================================
	mDex3D_addCylndr("z_beam", 0.5f, length, 8);
	mDex3D_modify("z_beam", TRANS::ORIGIN, origin.x, origin.y, origin.z);
	mDex3D_modify("z_beam", TRANS::ANGLE, 0, toRad(90), 0);
	mDex3D_setColor("z_beam", rgb(0, 0, 255));
	//=========================================================
	mDex3D_addCone("z_arrow", 1, 2, 8);
	mDex3D_modify("z_arrow", TRANS::ORIGIN, origin.x, origin.y, origin.z + length);
	mDex3D_modify("z_arrow", TRANS::ANGLE, 0, toRad(90), 0);
	mDex3D_setColor("z_arrow", rgb(0, 0, 255));
	mDex3D_setFont("z_arrow", "fixedsys", 16, true, false, false, false);
	mDex3D_setText("z_arrow", (char *) (repeat(" ", PADDING) + "Z").c_str());
	//=========================================================
}

std::string GRAPH_FUNC;
bool GRAPH_RADIAL;
float GRAPH_MIN_X;
float GRAPH_MAX_X;
float GRAPH_MIN_Z;
float GRAPH_MAX_Z;
float GRID_STEP_X;
float GRID_STEP_Z;
float GRID_WIDTH;
float GRID_LENGTH;
float GRID_HEIGHT;
void DexUser::load(HWND hWnd)
{
	//=============================================================================
	DexBase::load(hWnd);
	//=============================================================================

	GRAPH_FUNC = "y=0";
	GRAPH_RADIAL = false;
	GRAPH_MIN_X = -10;
	GRAPH_MAX_X = 10;
	GRAPH_MIN_Z = -10;
	GRAPH_MAX_Z = 10;
	GRID_STEP_X = 21;
	GRID_STEP_Z = 21;
	GRID_WIDTH = 50;
	GRID_LENGTH = 50;
	GRID_HEIGHT = 10;
	this->user(GUI::PLOT, 0);

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
void DexUser::keyDown(int key)
{
	switch (key)
	{
		case KEY::ESCAPE:
			this->quit();
			break;
		case KEY::TAB:
			mToggleHUD = !mToggleHUD;
			if (mToggleHUD)
				mDex3D_setWire("grid");
			else
				mDex3D_setSolid("grid");
			break;
		case KEY::ARROW_LEFT: mArrowLeft = true; break;
		case KEY::ARROW_RIGHT: mArrowRight = true; break;
		case KEY::ARROW_UP: mArrowUp = true; break;
		case KEY::ARROW_DOWN: mArrowDown = true; break;
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
	//mCurPick = cstr(mDex3D_pick((float) x / mWidth, (float) y / mHeight));
	if (mCurPick != "")
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
float mLngAngle = toRad(10);
float mLatAngle = toRad(45);
float mRadius = 75;
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
char mMsgBuf[256];
void DexUser::user(long wParam, long lParam)
{
	switch (wParam)
	{
		case GUI::INIT: mInitGUI = true; break;
		case GUI::RESET: mMsgBuf[0] = 0; break;
		case GUI::SEND_CHAR:
			if (!(mMsgBuf[LOWORD(lParam)] = HIWORD(lParam)))
				GRAPH_FUNC = cstr(mMsgBuf);
			break;
		case GUI::SET_RADIAL: GRAPH_RADIAL = (bool) lParam;
		case GUI::SET_MIN_X: memcpy(&GRAPH_MIN_X, &lParam, sizeof(long)); break;
		case GUI::SET_MAX_X: memcpy(&GRAPH_MAX_X, &lParam, sizeof(long)); break;
		case GUI::SET_MIN_Z: memcpy(&GRAPH_MIN_Z, &lParam, sizeof(long)); break;
		case GUI::SET_MAX_Z: memcpy(&GRAPH_MAX_Z, &lParam, sizeof(long)); break;
		case GUI::SET_STEP_X: memcpy(&GRID_STEP_X, &lParam, sizeof(long)); break;
		case GUI::SET_STEP_Z: memcpy(&GRID_STEP_Z, &lParam, sizeof(long)); break;
		case GUI::SET_WIDTH: memcpy(&GRID_WIDTH, &lParam, sizeof(long)); break;
		case GUI::SET_LENGTH: memcpy(&GRID_LENGTH, &lParam, sizeof(long)); break;
		case GUI::SET_HEIGHT: memcpy(&GRID_HEIGHT, &lParam, sizeof(long)); break;
		case GUI::PLOT:
			this->plotGraph(
				GRAPH_FUNC, GRAPH_RADIAL,
				GRAPH_MIN_X, GRAPH_MAX_X, GRAPH_MIN_Z, GRAPH_MAX_Z,
				GRID_STEP_X, GRID_STEP_Z, GRID_WIDTH, GRID_LENGTH, GRID_HEIGHT
				);
	}
}