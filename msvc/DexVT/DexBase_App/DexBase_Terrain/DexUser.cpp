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

int SAMPLE_SIZE = 5;
float DexUser::getHeight(long *data, int mapWidth, int mapHeight, float x, float z)
{
	if (!inRange(x, 0, 1) || !inRange(z, 0, 1))
		return 0;
	int newX = (1 - x) * mapWidth;
	int newY = z * mapHeight;
	if (
		inRange(newX, SAMPLE_SIZE, (mapWidth - 1) - SAMPLE_SIZE) &&
		inRange(newY, SAMPLE_SIZE, (mapHeight - 1) - SAMPLE_SIZE)
		)
	{
		float sum = 0;
		int count = 0;
		for (int i = 0; i < SAMPLE_SIZE * 2 + 1; i++)
			for (int j = 0; j < SAMPLE_SIZE * 2 + 1; j++)
			{
				int index =
					(newY + i - SAMPLE_SIZE) * mapWidth + (newX + j - SAMPLE_SIZE);
				long c = data[index];
				sum += getR(c);
				count++;
			}
		return sum / (count * 255);
	}
	long c = data[newY * mapWidth + newX];
	return (float) getR(c) / 255;
}

float LAND_WIDTH = 200;
float LAND_LENGTH = 200;
float LAND_HEIGHT = 50;
int LAND_STEP_X = 50;
int LAND_STEP_Z = 50;
float TREE_WIDTH = 10;
float TREE_HEIGHT = 10;
int TREE_COUNT = 800;
float SKY_RADIUS = pow(pow(LAND_WIDTH, 2) + pow(LAND_LENGTH, 2), 0.5f) * 0.5f * 4;
float SUN_LAT = toRad(-20);
float SUN_LNG = toRad(60);
float FLARE_SIZE = 0.25;
int FLARE_COUNT = 4;
void DexUser::load(HWND hWnd)
{
	//=============================================================================
	DexBase::load(hWnd);
	//=============================================================================

	mDexGL_fog(rgb(100, 255, 255), 0.005f, 0, 0.5f);

	mHgtMap = FileBmp::loadBmp(
		(char *) (this->getPath() + "Res\\land_h.bmp").c_str(),
		mMapWidth,
		mMapHeight
		);

	//=========================================================
	for (int i = 0; i < FLARE_COUNT; i++)
	{
		std::string id = cstr("lens") + cstr(i + 1);
		mDex3D_addHud((char *) id.c_str(), FLARE_SIZE, FLARE_SIZE);
		mDex3D_alignAxis((char *) id.c_str(), DIR::CENTER);
		mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN, 0, 0, 0);
		mDex3D_setTexMap(
			(char *) id.c_str(),
			(char *) (this->getPath() + "Res\\" + id + ".bmp").c_str(),
			(char *) (this->getPath() + "Res\\" + id + ".bmp").c_str(),
			-1,
			DIR::FRONT
			);
	}
	//=========================================================
	mDex3D_addSphere("sky", SKY_RADIUS, 32, 32);
	mDex3D_alignAxis("sky", DIR::CENTER);
	mDex3D_modify("sky", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("sky", TRANS::ANGLE, 0, toRad(180), 0);
	mDex3D_modify("sky", TRANS::SCALE, 1, 0.5f, 1);
	mDex3D_modify("sky", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_invert("sky");
	mDex3D_imprint("sky");
	mDex3D_setTexMap(
		"sky",
		(char *) (this->getPath() + "Res\\sky.bmp").c_str(),
		"",
		0,
		DIR::TOP
		);
	//mDex3D_setWire("sky");
	//=========================================================
	mDex3D_addGrid("water", LAND_WIDTH, LAND_LENGTH, 2, 2);
	mDex3D_alignAxis("water", DIR::BOTTOM);
	mDex3D_modify("water", TRANS::ORIGIN, 0, LAND_HEIGHT * 0.1f, 0);
	mDex3D_modify("water", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("water");
	mDex3D_setColor("water", rgb(0, 0, 255));
	mDex3D_setAlpha("water", 0.5f);
	//mDex3D_setWire("water");
	//=========================================================
	mDex3D_addGrid("horizon", SKY_RADIUS * 2, SKY_RADIUS * 2, 2, 2);
	mDex3D_alignAxis("horizon", DIR::BOTTOM);
	mDex3D_modify("horizon", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("horizon", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_imprint("horizon");
	mDex3D_setColor("horizon", rgb(0, 200, 0));
	//mDex3D_setWire("horizon");
	//=========================================================
	mDex3D_addGrid("land", LAND_WIDTH, LAND_LENGTH, LAND_STEP_X, LAND_STEP_Z);
	mDex3D_alignAxis("land", DIR::BOTTOM);
	mDex3D_modify("land", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("land", TRANS::LOCK_ANGLE, 1, 1, 1);
	mDex3D_setHgtMap(
		"land",
		(char *) (this->getPath() + "Res\\land_h.bmp").c_str(),
		LAND_HEIGHT
		);
	mDex3D_imprint("land");
	mDex3D_setTexMap(
		"land",
		(char *) (this->getPath() + "Res\\land.bmp").c_str(),
		"",
		0,
		DIR::TOP
		);
	//mDex3D_setWire("land");
	//=========================================================
	for (int j = 0; j < TREE_COUNT; j++)
	{
		float x = rnd();
		float z = rnd();
		float y = getHeight(mHgtMap, mMapWidth, mMapHeight, x, z);
		x = x * LAND_WIDTH - LAND_WIDTH * 0.5f;
		z = z * LAND_LENGTH - LAND_LENGTH * 0.5f;
		y *= LAND_HEIGHT;
		if (inRange(y, LAND_HEIGHT * 0.25f, LAND_HEIGHT * 0.5f))
		{
			std::string id = cstr("tree") + cstr(j);
			mDex3D_addSprite((char *) id.c_str(), TREE_WIDTH, TREE_HEIGHT, false);
			mDex3D_alignAxis((char *) id.c_str(), DIR::BOTTOM);
			mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN, x, y, z);
			mDex3D_setTexMap(
				(char *) id.c_str(),
				(char *) (this->getPath() + "Res\\tree.bmp").c_str(),
				(char *) (this->getPath() + "Res\\tree_m.bmp").c_str(),
				rgb(255, 255, 255),
				DIR::FRONT
				);
		}
	}
	//=========================================================

	this->mouseMove(MOUSE::LEFT, 0, 0);
	this->mouseUp(MOUSE::LEFT, 0, 0);
	this->setSize(480, 480);
}

void DexUser::unload(int &cancel)
{
	delete []mHgtMap;
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
			this->saveImage((char *) (this->getPath() + "Res\\test.bmp").c_str());
			break;
		case 'D':
			this->saveDepthMap(
				(char *) (this->getPath() + "Res\\test.bmp").c_str(), 10, 1, 0
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

float FLY_HEIGHT = 5;
float CAMERA_FOV = toRad(90);
float FLARE_OFFSET = 0.4f;
float mOrbitSpeed = 0.02f;
float mDollySpeed = 0.4f;
float mLngAngle = 0;
float mLatAngle = toRad(45);
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
		//=========================================================
		Vector camPos;
		mDex3D_query("camera", TRANS::ORIGIN, &camPos.x, &camPos.y, &camPos.z);
		float newX = (LAND_WIDTH * 0.5f + camPos.x) / LAND_WIDTH;
		float newZ = (LAND_LENGTH * 0.5f + camPos.z) / LAND_LENGTH;
		float newY = getHeight(mHgtMap, mMapWidth, mMapHeight, newX, newZ);
		newY = newY * LAND_HEIGHT + FLY_HEIGHT;
		camPos.y = max(camPos.y, newY);
		mDex3D_modify("camera", TRANS::ORIGIN, camPos.x, camPos.y, camPos.z);
		//=========================================================
		Vector camFront;
		mDex3D_query("camera", TRANS::ABS_FRONT, &camFront.x, &camFront.y, &camFront.z);
		Vector skyPos = camPos.vec_interp(camFront, 2);
		mDex3D_modify("sky", TRANS::ORIGIN, skyPos.x, skyPos.y, skyPos.z);
		//=========================================================
		Vector camDir;
		mDex3D_query("camera", TRANS::ABS_DIR_FWD, &camDir.x, &camDir.y, &camDir.z);
		Vector sunDir =
			FWD_VECTOR * ComboTrans(
				NULL_VECTOR, Vector(0, SUN_LAT, SUN_LNG), UNIT_VECTOR
				);
		float angle = camDir.angle(sunDir);
		if (acosEx(angle) < CAMERA_FOV * 0.5f)
		{
			Vector sunAngle = sunDir.toAngle();
			Vector camAngle = camDir.toAngle();
			Vector flarePos;
			flarePos.x =
				acosEx((sunDir & Vector(1, 0, 1)).angle(camDir & Vector(1, 0, 1)));
			flarePos.x *= (fabs(sunAngle.yaw - camAngle.yaw) < PI) ?
				-sgn(sunAngle.yaw - camAngle.yaw) : sgn(sunAngle.yaw - camAngle.yaw);
			float sunPitch =
				acosEx(sunDir.angle(sunDir & Vector(1, 0, 1))) * -sgn(sunAngle.pitch);
			float camPitch =
				acosEx(camDir.angle(camDir & Vector(1, 0, 1))) * -sgn(camAngle.pitch);
			flarePos.y = sunPitch - camPitch;
			flarePos /= (CAMERA_FOV * 0.5f);
			flarePos *= 0.5f;
			Vector offset = flarePos * FLARE_OFFSET;
			for (int i = 0; i < FLARE_COUNT; i++)
			{
				std::string id = cstr("lens") + cstr(i + 1);
				mDex3D_setVis((char *) id.c_str(), true);
				mDex3D_modify(
					(char *) id.c_str(), TRANS::ORIGIN, flarePos.x, flarePos.y, 0
					);
				flarePos -= offset;
			}
		}
		else
			for (int i = 0; i < FLARE_COUNT; i++)
			{
				std::string id = cstr("lens") + cstr(i + 1);
				mDex3D_setVis((char *) id.c_str(), false);
			}
		//=========================================================
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