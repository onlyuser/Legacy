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

Vector DexUser::getPos(std::string id)
{
	float v[3];
	mDex3D_query((char *) id.c_str(), TRANS::ABS_ORIGIN, &v[0], &v[1], &v[2]);
	return Vector(v);
}

Vector DexUser::getAngle(std::string id)
{
	float v[3];
	mDex3D_query((char *) id.c_str(), TRANS::ANGLE, &v[0], &v[1], &v[2]);
	return Vector(v);
}

void DexUser::setAngle(std::string id, Vector &v)
{
	mDex3D_modify((char *) id.c_str(), TRANS::ANGLE, v.roll, v.pitch, v.yaw);
}

const float MAX_BANK = toRad(90);
const float PITCH_STEP = toRad(1);
const float YAW_STEP = toRad(1);
const float MAX_PITCH = toRad(60);
bool DexUser::adjustHeading(std::string id, Vector &target, bool &engage, float engageDist, float evadeDist)
{
	bool result = false;
	Vector origin = getPos(id);
	Vector angle = getAngle(id);
	Vector diff = target - origin;
	Vector bestAngle = diff.toAngle();
	int dir = wrap_sgn(angle.yaw, bestAngle.yaw, toRad(-180), toRad(180));
	float offset =
		wrap_dist(angle.yaw, bestAngle.yaw, toRad(-180), toRad(180)) / toRad(180);
	float dist = diff.mod();
	int pole = (engage ? dist > engageDist : dist > evadeDist) * 2 - 1;
	if (engage && dist < engageDist)
		engage = false;
	if (!engage && dist > evadeDist)
	{
		result = true;
		engage = true;
	}
	angle.roll = -dir * (1 - fabs(0.5f - offset) / 0.5f) * MAX_BANK;
	angle.pitch = angle.pitch - sgn(target.y - origin.y) * PITCH_STEP;
	angle.yaw = angle.yaw + dir * pole * YAW_STEP;
	angle.pitch = min(fabs(angle.pitch), MAX_PITCH) * sgn(angle.pitch);
	this->setAngle(id, angle);
	return result;
}

const float LAND_WIDTH = 500;
const float LAND_LENGTH = 500;
const float LAND_HEIGHT = 50;
const int LAND_STEP_X = 50;
const int LAND_STEP_Z = 50;
const float BASE_HEIGHT = -200;
const int JET_COUNT = 20;
const float ZONE_BEGIN = -50;
const float ZONE_END = 50;
const float MAX_SPEED = 2;
const float MID_SPEED = 1;
const float MIN_SPEED = 0.5f;
bool mJetState[JET_COUNT];
int mJetTarget[JET_COUNT];
void DexUser::load(HWND hWnd)
{
	//=============================================================================
	DexBase::load(hWnd);
	//=============================================================================

	mDex3D_addGrid("land", LAND_WIDTH, LAND_LENGTH, LAND_STEP_X, LAND_STEP_Z);
	mDex3D_alignAxis("land", DIR::BOTTOM);
	mDex3D_modify("land", TRANS::ORIGIN, 0, BASE_HEIGHT, 0);
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
	mDex3D_setNoClip("land", true);

	mDex3D_load3ds("jet", (char *) (this->getPath() + "Res\\F16B.3DS").c_str(), -1);
	mDex3D_invert("jet");
	mDex3D_alignAxis("jet", DIR::CENTER);
	mDex3D_modify("jet", TRANS::ORIGIN, 0, 0, 0);
	mDex3D_modify("jet", TRANS::SCALE, 1, 1, 1);
	mDex3D_imprint("jet");
	mDex3D_setPhys("jet", 1, 0, 0, 0);
	mDex3D_setColor("jet", rgb(100, 100, 255));
	mDex3D_setText("jet", "H");

	for (int i = 0; i < JET_COUNT; i++)
	{
		std::string id = cstr("jet") + cstr(i);
		mDex3D_copyMesh("jet", (char *) id.c_str());
		mDex3D_modify((char *) id.c_str(), TRANS::ORIGIN,
			rndEx(ZONE_BEGIN, ZONE_END),
			rndEx(ZONE_BEGIN, ZONE_END),
			rndEx(ZONE_BEGIN, ZONE_END)
			);
		mDex3D_modify((char *) id.c_str(), TRANS::LOC_VEL_ORIGIN,
			0, 0, rndEx(MIN_SPEED, MAX_SPEED)
			);
		mDex3D_setPhys((char *) id.c_str(), 1, 0, 0, 0);
		mJetState[i] = true;
		mJetTarget[i] = -1;
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
bool mThrotUp = false;
bool mThrotDown = false;
bool mAuxView = false;
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
		case 'A': mThrotUp = true; break;
		case 'Z': mThrotDown = true; break;
		case KEY::CTRL: mAuxView = true; break;
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
		case KEY::ARROW_DOWN: mArrowDown = false; break;
		case 'A': mThrotUp = false; break;
		case 'Z': mThrotDown = false; break;
		case KEY::CTRL: mAuxView = false;
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

const int ENGAGE_DIST = 50;
const int EVADE_DIST = 200;
const int MAX_DIST = 400;
void DexUser::timer()
{
	mDex3D_modify("jet", TRANS::VEL_ANGLE, 0, 0, 0);
	if (mArrowLeft)
		mDex3D_modify("jet", TRANS::VEL_ANGLE, 0, 0, YAW_STEP);
	if (mArrowRight)
		mDex3D_modify("jet", TRANS::VEL_ANGLE, 0, 0, -YAW_STEP);
	if (mArrowUp)
		mDex3D_modify("jet", TRANS::VEL_ANGLE, 0, PITCH_STEP, 0);
	if (mArrowDown)
		mDex3D_modify("jet", TRANS::VEL_ANGLE, 0, -PITCH_STEP, 0);
	if (mThrotUp)
		mDex3D_modify("jet", TRANS::LOCAL_ORIGIN, 0, 0, MID_SPEED);
	if (mThrotDown)
		mDex3D_modify("jet", TRANS::LOCAL_ORIGIN, 0, 0, -MID_SPEED);
	if (mThrotUp || mThrotDown)
	{
		mDex3D_query("jet", TRANS::ORIGIN, &mCamTarget.x, &mCamTarget.y, &mCamTarget.z);
		mDex3D_orbit(
			mCamTarget.x, mCamTarget.y, mCamTarget.z,
			mRadius, mLngAngle, mLatAngle
			);
	}
	if (mAuxView)
	{
		std::string id = (mJetTarget[0] == -1) ?
			"jet" : cstr("jet") + cstr(mJetTarget[0]);
		Vector v1[3], v2[3];
		mDex3D_query("jet0", TRANS::ORIGIN, &v1[0].x, &v1[1].y, &v1[2].z);
		mDex3D_query((char *) id.c_str(), TRANS::ORIGIN, &v2[0].x, &v2[1].y, &v2[2].z);
		mDex3D_lookFrom(v1[0].x, v1[1].y, v1[2].z);
		mDex3D_lookAt(v2[0].x, v2[1].y, v2[2].z);
	}
	for (int i = 0; i < JET_COUNT; i++)
	{
		std::string id = cstr("jet") + cstr(i);
		//=========================================================
		Vector player = this->getPos("jet");
		Vector target = (mJetTarget[i] == -1) ?
			player : this->getPos(cstr("jet") + cstr(mJetTarget[i]));
		if (this->adjustHeading(
			id, target, mJetState[i], ENGAGE_DIST, EVADE_DIST
			))
			while ((mJetTarget[i] = (int) rndEx(0, JET_COUNT)) == i);
		if (target.dist(player) > MAX_DIST)
			mJetTarget[i] = -1;
		//=========================================================
		if (!mJetState[i])
			mDex3D_setText((char *) id.c_str(), (char *) cstr(i).c_str());
		else
			if (mJetTarget[i] == -1)
				mDex3D_setText(
					(char *) id.c_str(), (char *) (cstr(i) + "->H").c_str()
					);
			else
				mDex3D_setText(
					(char *) id.c_str(),
					(char *) (cstr(i) + "->" + cstr(mJetTarget[i])).c_str()
					);
	}
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