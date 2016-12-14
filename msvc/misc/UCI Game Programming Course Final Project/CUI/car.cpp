#include "car.h"

car::car(long data, char *path)
{
	long i;
	long j;

	setPath(path, "");
	cacheData();

	/* car model */
	mData = data;
	mScene->setMotion(mData, 1, true);
	mPath = path;
	mSafePos = new float[3];
	mSafeRot = new float[3];
	vectorNull(mSafePos);
	vectorNull(mSafeRot);
	mPrevSpd = 0;
	mPrevHit = 0;
	mEngineChan = 0;
	mBrakeChan = 0;
	mHornChan = 0;

	/* constants */
	mGearMax = GEAR_PARK;
	mGearMin = GEAR_DRIVE;
	mMovSpdMax = 0;
	mRotSpdMax = 0;
	mPosAcc = 0;
	mNatFrict = 0;
	mBrakeFrict = 0;
	mBankAngle = 0;

	/* car state */
	mLoaded = false;
	mIgnited = false;
	mGear = GEAR_PARK;
	mWheel = 0;
	mPedal = false;
	mBrake = false;
	mHorn = false;

	mGearHud = new long *[4];
	for (i = 0; i < 4; i++)
		mGearHud[i] = new long[2];
	for (i = 0; i < 4; i++)
		for (j = 0; j < 2; j++)
			mGearHud[i][j] = mScene->addHud();
	mEngineHud = mScene->addHud();
	mScene->setHud(mGearHud[3][0], getPath("hud_p0.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[3][1], getPath("hud_p1.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[2][0], getPath("hud_r0.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[2][1], getPath("hud_r1.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[1][0], getPath("hud_n0.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[1][1], getPath("hud_n1.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[0][0], getPath("hud_d0.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mGearHud[0][1], getPath("hud_d1.bmp"), getPath("hud_mask.bmp"));
	mScene->setHud(mEngineHud, getPath(""), getPath(""));
	mScene->moveHud(mGearHud[3][0], 0, 3 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[3][1], 0, 3 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[2][0], 0, 2 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[2][1], 0, 2 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[1][0], 0, 1 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[1][1], 0, 1 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[0][0], 0, 0 * 48, 0.5, 0.5);
	mScene->moveHud(mGearHud[0][1], 0, 0 * 48, 0.5, 0.5);
	mScene->moveHud(mEngineHud, 0, 4 * 48, 0.5, 0.5);
	refreshHud();
}

car::~car()
{
	long i;

	delete []mSafePos;
	delete []mSafeRot;

	for (i = 0; i < 4; i++)
		delete []mGearHud[i];
}

void car::cacheData()
{
	cacheSound(mSndStartUp, SND_STARTUP);
	cacheSound(mSndEngine, SND_ENGINE);
	cacheSound(mSndShift, SND_SHIFT);
	cacheSound(mSndSteer, SND_STEER);
	cacheSound(mSndPedal, SND_PEDAL);
	cacheSound(mSndBrake, SND_BRAKE);
	cacheSound(mSndHorn, SND_HORN);
	cacheSound(mSndRev, SND_REV);
	cacheSound(mSndGrind, SND_GRIND);
	cacheSound(mSndCrash, SND_CRASH);
	cacheSound(mSndDoor, SND_DOOR);
	cacheSound(mSndRemote, SND_REMOTE);
	cacheSound(mSndJammed, SND_JAMMED);
	cacheSound(mSndShutOff, SND_SHUTOFF);
}

void car::setParams(float movSpd, float rotSpd, float posAcc, float natFrict, float brakeFrict, float bankAngle)
{
	mMovSpdMax = movSpd;
	mRotSpdMax = rotSpd;
	mPosAcc = posAcc;
	mNatFrict = natFrict;
	mBrakeFrict = brakeFrict;
	mBankAngle = bankAngle;
	mScene->setMaxSpeed(mData, movSpd, rotSpd);
}

void car::refreshHud()
{
	long i;

	for (i = 0; i < 4; i++)
		if (i == mGear)
		{
			mScene->enableHud(mGearHud[i][0], false);
			mScene->enableHud(mGearHud[i][1], true);
		}
		else
		{
			mScene->enableHud(mGearHud[i][0], true);
			mScene->enableHud(mGearHud[i][1], false);
		}
	if (mIgnited)
	{
		mScene->enableHud(mEngineHud, true);
		mScene->enableHud(mEngineHud, false);
	}
	else	
	{
		mScene->enableHud(mEngineHud, false);
		mScene->enableHud(mEngineHud, true);
	}
}

//===============//
// ON-OFF STATES //
//===============//

void car::setLoad()
{
	mLoaded = !mLoaded;
	if (mLoaded)
		playSound(mSndDoor, false);
	else
		playSound(mSndRemote, false);
}

void car::setIgnition()
{
	if (mLoaded)
	{
		mIgnited = !mIgnited;
		if (mIgnited)
		{
			playSound(mSndStartUp, false);
			mEngineChan = playSound(mSndEngine, true);
		}
		else
		{
			playSound(mSndShutOff, false);
			stopSound(mEngineChan);
		}
	}
}

//===============//
// TOGGLE STATES //
//===============//

void car::shiftUp()
{
	if (mLoaded)
	{
		if (mIgnited && (mBrake || (mGear + 1 != GEAR_PARK)))
		{
			if (mGear != mGearMax)
			{
				mGear++;
				refreshHud();
				playSound(mSndShift, false);
			}
			else
				playSound(mSndJammed, false);
		}
		else
			playSound(mSndJammed, false);
	}
}
void car::shiftDown()
{
	if (mLoaded)
	{
		if (mIgnited && (mBrake || (mGear != GEAR_PARK)))
		{
			if (mGear != mGearMin)
			{
				mGear--;
				refreshHud();
				playSound(mSndShift, false);
			}
			else
				playSound(mSndJammed, false);
		}
		else
			playSound(mSndJammed, false);
	}
}

//===============//
// SWITCH STATES //
//===============//

void car::steerLeft()
{
	if (mLoaded)
	{
		mWheel = -1;
		if (mPrevSpd != 0)
			mSteerChan = playSound(mSndSteer, false);
	}
}
void car::steerRight()
{
	if (mLoaded)
	{
		mWheel = 1;
		if (mPrevSpd != 0)
			mSteerChan = playSound(mSndSteer, false);
	}
}
void car::reset()
{
	mWheel = 0;
	if (mSteerChan != 0)
		stopSound(mSteerChan);
}

//==================//
// HOLD-DOWN STATES //
//==================//

void car::pedalDown()
{
	if (mLoaded)
	{
		mPedal = true;
		if (mGear != GEAR_NEUTRAL)
			playSound(mSndPedal, false);
		else
			playSound(mSndRev, false);
	}
}
void car::pedalUp()
{mPedal = false;}

void car::brakeDown()
{
	if (mLoaded)
	{
		mBrake = true;
		if (mPrevSpd != 0)
			mBrakeChan = playSound(mSndBrake, false);
	}
}
void car::brakeUp()
{
	mBrake = false;
	if (mBrakeChan != 0)
		stopSound(mBrakeChan);
}

void car::hornDown()
{
	if (mLoaded)
	{
		mHorn = true;
		mHornChan = playSound(mSndHorn, false);
	}
}
void car::hornUp()
{
	mHorn = false;
	if (mHornChan != 0)
		stopSound(mHornChan);
}

//==============//
// STATE UPDATE //
//==============//

void car::update()
{
	//float height;
	float *tempA;
	float *tempB;
	long other;
	long pMeshA;
	long pMeshB;

	tempA = new float[3];
	tempB = new float[3];
	/*
	height = mScene->beamMesh(mData); //sonar-detect ground distance
	mScene->getVector(mData, MOV_POS, tempA[0], tempA[1], tempA[2]);
	if (height != 0)
		tempA[1] = 4; //update car altitude
	else
		tempA[1] = 2;
	mScene->moveMesh(mData, MOV_POS, tempA[0], tempA[1], tempA[2]);
	*/
	other = mScene->collideMesh(mData);
	if (other != 0)
	{
		mScene->moveMesh(mData, MOV_POS, mSafePos[0], mSafePos[1], mSafePos[2]);
		mScene->moveMesh(mData, MOV_ROT, mSafeRot[0], mSafeRot[1], mSafeRot[2]);
		if (other != mPrevHit)
		{
			pMeshA = mScene->addBox(1, 1, 1);
			mScene->enableMesh(pMeshA, false);
			mScene->setMotion(pMeshA, 0, false);
			pMeshB = mScene->addBox(1, 1, 1);
			mScene->enableMesh(pMeshB, false);
			mScene->setMotion(pMeshB, 0, false);

			mScene->getVector(mData, MOV_POS, tempA[0], tempA[1], tempA[2]);
			mScene->getVector(other, MOV_POS, tempB[0], tempB[1], tempB[2]);
			vectorSub(tempB, tempB, tempA);
			vectorNorm(tempB, tempB);
			vectorScale(tempB, tempB, ((mesh *) mData)->mRadius);
			vectorAdd(tempA, tempA, tempB);
			mScene->getVector(mData, MOV_ROT, tempB[0], tempB[1], tempB[2]);

			mScene->moveMesh(pMeshA, MOV_POS, tempA[0], tempA[1], tempA[2]);
			mScene->moveMesh(pMeshA, MOV_ROT, 0, 0, tempB[2] + toRad(180));
			mScene->setPartSrc(pMeshA, (float) 0.5, rgb(255, 0, 0), (float) 0.05, (float) 0.05, toRad(60), 50);
			mScene->setLife(pMeshA, 25);
			mScene->moveMesh(pMeshB, MOV_POS, tempA[0], tempA[1], tempA[2]);
			mScene->moveMesh(pMeshB, MOV_ROT, 0, 0, tempB[2] + toRad(180));
			mScene->setPartSrc(pMeshB, (float) 0.5, rgb(255, 255, 0), (float) 0.05, (float) 0.1, toRad(15), 25);
			mScene->setLife(pMeshB, 25);

			playSound(mSndCrash, false);
		}
	}
	else
	{
		mScene->getVector(mData, MOV_POS, mSafePos[0], mSafePos[1], mSafePos[2]);
		mScene->getVector(mData, MOV_ROT, mSafeRot[0], mSafeRot[1], mSafeRot[2]);
	}
	mScene->getVector(mData, MOV_VEL, tempA[0], tempA[1], tempA[2]);
	if (mGear != GEAR_PARK)
	{
		if (mIgnited && mPedal && mGear != GEAR_NEUTRAL)
		{
			switch (mGear)
			{
			case GEAR_REVERSE:
				if (sgn(tempA[2]) == 1)
				{
					mScene->moveMesh(mData, MOV_VEL, 0, 0, 0);
					playSound(mSndGrind, false);
				}
				mScene->moveMesh(mData, MOV_ACC, 0, 0, -mPosAcc);
				break;
			case GEAR_DRIVE:
				if (sgn(tempA[2]) == -1)
				{
					mScene->moveMesh(mData, MOV_VEL, 0, 0, 0);
					playSound(mSndGrind, false);
				}
				mScene->moveMesh(mData, MOV_ACC, 0, 0, mPosAcc);
			}
		}
		else
		{
			if (mBrake)
			{
				if (sgn(tempA[2]) == -sgn(mPrevSpd))
				{
					mScene->moveMesh(mData, MOV_VEL, 0, 0, 0);
					mScene->moveMesh(mData, MOV_ACC, 0, 0, 0);
				}
				else
					mScene->moveMesh(mData, MOV_ACC, 0, 0, mBrakeFrict * -sgn(tempA[2]));
			}
			else
			{
				if (sgn(tempA[2]) == -sgn(mPrevSpd))
				{
					mScene->moveMesh(mData, MOV_VEL, 0, 0, 0);
					mScene->moveMesh(mData, MOV_ACC, 0, 0, 0);
				}
				else
					mScene->moveMesh(mData, MOV_ACC, 0, 0, mNatFrict * -sgn(tempA[2]));
			}
		}
	}
	else
	{
		mScene->moveMesh(mData, MOV_VEL, 0, 0, 0);
		mScene->moveMesh(mData, MOV_ACC, 0, 0, 0);
	}
	mScene->moveMesh(mData, MOV_ANGVEL, 0, 0, mWheel * tempA[2] / mMovSpdMax * -mRotSpdMax);
	mScene->getVector(mData, MOV_ROT, tempB[0], tempB[1], tempB[2]);
	tempB[0] = mWheel * fabs(tempA[2]) / mMovSpdMax * -mBankAngle;
	mScene->moveMesh(mData, MOV_ROT, tempB[0], tempB[1], tempB[2]);
	mPrevSpd = tempA[2];
	mPrevHit = other;
	delete []tempA;
	delete []tempB;
}