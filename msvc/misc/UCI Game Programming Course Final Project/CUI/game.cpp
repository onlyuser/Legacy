#include "game.h"

//====================//
// GAME WRAPPER CLASS //
//====================//

class game
{
public:
	long mButton;
	long mPrevX;
	long mPrevY;

	float mOrbitSpeed;
	float mDollySpeed;
	float mAngle;
	float mLngAngle;
	float mLatAngle;
	float mRadius;

	long mDrawMode;
	long mViewMode;
	bool mMusic;

	long pCamera;
	long pLightA;
	long pMeshA;

	car *mCar;
	float mMovSpdMax;
	float mRotSpdMax;
	float mPosAcc;
	float mNatFrict;
	float mBrakeFrict;
	float mBankAngle;

	FSOUND_STREAM *mMp3TrackA;
	FMUSIC_MODULE *mModTrackA;
	FSOUND_STREAM *mSndTrackA;

	game();
	~game();
	void cacheData();
	void timer();
	void display();
	void keyDown(BYTE key);
	void keyUp(BYTE key);
	void mouseDown(long button, long x, long y);
	void mouseMove(long button, long x, long y);
	void mouseUp(long button, long x, long y);
	void load(char *appPath, char *resPath, long handle);
	void unload();
};

game *mGame;

//=============//
// GAME EVENTS //
//=============//

game::game()
{
}

game::~game()
{
}

void game::cacheData()
{
	loadStream(mMp3TrackA, MP3_TRACK_A);
	cacheMusic(mModTrackA, MOD_TRACK_A);
	loadStream(mSndTrackA, SND_TRACK_A);
}

void game::timer()
{
	float *tempA;
	float *tempB;
	float *tempC;

	mScene->runNPC(NPC_MOVSPD, toRad(NPC_ROTSPD));
	if (mCar != 0)
		mCar->update();
	else
		mViewMode = 0;
	tempA = new float[3];
	tempB = new float[3];
	tempC = new float[3];
	vectorNull(tempA);
	vectorNull(tempB);
	vectorNull(tempC);
	if (mViewMode != 0)
		mScene->getVector(pMeshA, MOV_POS, tempA[0], tempA[1], tempA[2]);
	if (mCar != 0)
	{
		mScene->getVector(pMeshA, MOV_ROT, tempB[0], tempB[1], tempB[2]);
		mScene->getVector(pMeshA, MOV_ANGVEL, tempC[0], tempC[1], tempC[2]);
	}
	switch (mViewMode)
	{
	case 0:
		tempB[2] = mLngAngle;
		tempB[1] = mLatAngle;
		break;
	case 1:
		tempB[2] += mLngAngle;
		tempB[1] += mLatAngle;
		break;
	case 2:
		mRadius = DOLLY_RADIUS_CHASE;
		tempB[2] += -tempC[2];
		tempB[1] += toRad(DOLLY_PITCH_CHASE);
		break;
	case 3:
		mRadius = DOLLY_RADIUS_TOP;
		tempB[2] = 0;
		tempB[1] = toRad(90);
	}
	mScene->orbitCamera(pCamera, tempA[0], tempA[1], tempA[2], mRadius, tempB[2], tempB[1]);
	mScene->getVector(pCamera, MOV_POS, tempA[0], tempA[1], tempA[2]);
	mScene->moveLight(pLightA, tempA[0], tempA[1], tempA[2]);
	delete []tempA;
	delete []tempB;
	delete []tempC;
}

void game::display()
{
	mScene->render(pCamera, true, true);
}

void game::keyDown(BYTE key)
{
	switch (key)
	{
	case 'q':
		mDrawMode = (mDrawMode + 1) % 9;
		mScene->setDrawMode(mDrawMode);
		break;
	case 'w':
		mMusic = !mMusic;
		if (mMusic)
		{
			playStream(mMp3TrackA);
			//playMusic(mModTrackA, true);
			playStream(mSndTrackA);
		}
		else
		{
			stopStream(mMp3TrackA);
			//stopMusic(mModTrackA);
			stopStream(mSndTrackA);
		}
		break;
	case KEY_CAMERA:
		mViewMode = (mViewMode + 1) % 4;
		break;
	}
	if (mCar == 0)
		return;
	switch (key)
	{
	case KEY_LOAD:
		mCar->setLoad();
		break;
	case KEY_IGNITION:
		mCar->setIgnition();
		break;
	case KEY_SHIFTUP:
		mCar->shiftUp();
		break;
	case KEY_SHIFTDN:
		mCar->shiftDown();
		break;
	case KEY_LEFT:
		mCar->steerLeft();
		break;
	case KEY_RIGHT:
		mCar->steerRight();
		break;
	case KEY_PEDAL:
		mCar->pedalDown();
		break;
	case KEY_BRAKE:
		mCar->brakeDown();
		break;
	case KEY_HORN:
		mCar->hornDown();
	}
}

void game::keyUp(BYTE key)
{
	if (mCar == 0)
		return;
	switch (key)
	{
	case KEY_LEFT:
		mCar->reset();
		break;
	case KEY_RIGHT:
		mCar->reset();
		break;
	case KEY_PEDAL:
		mCar->pedalUp();
		break;
	case KEY_BRAKE:
		mCar->brakeUp();
		break;
	case KEY_HORN:
		mCar->hornUp();
	}
}

void game::mouseDown(long button, long x, long y)
{
	mButton = button;
	mPrevX = x;
	mPrevY = y;
}

void game::mouseMove(long button, long x, long y)
{
	if (mButton != 0)
	{
		switch (mButton)
		{
		case 1:
			mLngAngle += (x - mPrevX) * mOrbitSpeed * -1;
			mLatAngle += (y - mPrevY) * mOrbitSpeed * -1;
			break;
		case 2:
			mRadius += (y - mPrevY) * mDollySpeed * -1;
		}
		if (mLngAngle > PI * 2) mLngAngle -= PI * 2;
		if (mLngAngle < 0) mLngAngle += PI * 2;
		if (mLatAngle > PI / 2) mLatAngle = PI / 2;
		if (mLatAngle < -PI / 2) mLatAngle = -PI / 2;
		if (mRadius < 0) mRadius = 0;
		mPrevX = x;
		mPrevY = y;
	}
}

void game::mouseUp(long button, long x, long y)
{
	mButton = 0;
}

void game::load(char *appPath, char *resPath, long handle)
{
	setPath(appPath, resPath);
	initSound();
	cacheData();

	mOrbitSpeed = (float) 0.01;
	mDollySpeed = (float) 0.1;
	mAngle = 0;
	mLngAngle = 0;
	mLatAngle = 0;
	mRadius = 10;

	mDrawMode = -1;
	mViewMode = 0;
	mMusic = false;

	/* setup camera, light */
	pCamera = mScene->addCamera();
	pLightA = mScene->addLight();

	/* load package */
	mScene->loadPak(getPath("test.pak"), getPath(""));
	pMeshA = mScene->findMesh("player1");
	if (pMeshA != 0)
	{
		mCar = new car(pMeshA, getPath(""));
		mMovSpdMax = 0.5;
		mRotSpdMax = toRad(2);
		mPosAcc = 0.01;
		mNatFrict = 0.001;
		mBrakeFrict = 0.05;
		mBankAngle = toRad(5);
		mCar->setParams(mMovSpdMax, mRotSpdMax, mPosAcc, mNatFrict, mBrakeFrict, mBankAngle);
	}
	else
		mCar = 0;

	/* listen for input */
	mKeyBase->addListener('q', false);
	mKeyBase->addListener('w', false);
	mKeyBase->addListener(KEY_CAMERA, false);
	mKeyBase->addListener(KEY_LOAD, false);
	mKeyBase->addListener(KEY_IGNITION, false);
	mKeyBase->addListener(KEY_SHIFTUP, false);
	mKeyBase->addListener(KEY_SHIFTDN, false);
	mKeyBase->addListener(KEY_LEFT, false);
	mKeyBase->addListener(KEY_RIGHT, false);
	mKeyBase->addListener(KEY_PEDAL, false);
	mKeyBase->addListener(KEY_BRAKE, false);
	mKeyBase->addListener(KEY_HORN, false);

	/* initialize switches */
	keyDown('q');
	keyDown('w');
	keyDown(KEY_CAMERA);
	keyDown(KEY_CAMERA);
	keyDown(KEY_LOAD);
}

void game::unload()
{
	if (mCar != 0)
		delete mCar;
}

//===============//
// GAME REDIRECT //
//===============//

void game_timer()
{mGame->timer();}

void game_display()
{mGame->display();}

void game_keyDown(BYTE key)
{mGame->keyDown(key);}

void game_keyUp(BYTE key)
{mGame->keyUp(key);}

void game_mouseDown(long button, long x, long y)
{mGame->mouseDown(button, x, y);}

void game_mouseMove(long button, long x, long y)
{mGame->mouseMove(button, x, y);}

void game_mouseUp(long button, long x, long y)
{mGame->mouseUp(button, x, y);}

void game_load(char *appPath, char *resPath, long handle)
{
	mGame = new game();
	mGame->load(appPath, resPath, handle);
}

void game_unload()
{
	mGame->unload();
	delete mGame;
}