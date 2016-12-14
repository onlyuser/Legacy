#ifndef H_CAR
#define H_CAR

#include "cui.h"

#define SND_STARTUP "starter.wav"
#define SND_ENGINE "engine.wav"
#define SND_SHIFT "shift.wav"
#define SND_STEER "skid.wav"
#define SND_PEDAL ""
#define SND_BRAKE "brake.wav"
#define SND_HORN "horn.wav"
#define SND_REV "rev.wav"
#define SND_GRIND "grind.wav"
#define SND_CRASH "thud.wav"
#define SND_DOOR "door.wav"
#define SND_REMOTE ""
#define SND_JAMMED ""
#define SND_SHUTOFF ""

enum eGear
{
	GEAR_PARK = 3,
	GEAR_REVERSE = 2,
	GEAR_NEUTRAL = 1,
	GEAR_DRIVE = 0
};

class car
{
public:
	/* car model */
	long mData;
	char *mPath;
	float *mSafePos;
	float *mSafeRot;
	float mPrevSpd;
	long mPrevHit;
	long mEngineChan;
	long mBrakeChan;
	long mHornChan;
	long mSteerChan;

	/* constants */
	long mGearMax;
	long mGearMin;
	float mMovSpdMax;
	float mRotSpdMax;
	float mPosAcc;
	float mNatFrict;
	float mBrakeFrict;
	float mBankAngle;

	/* car state */
	bool mLoaded;
	bool mIgnited;
	long mGear;
	long mWheel;
	bool mPedal;
	bool mBrake;
	bool mHorn;

	long **mGearHud;
	long mEngineHud;

	FSOUND_SAMPLE *mSndStartUp;
	FSOUND_SAMPLE *mSndEngine;
	FSOUND_SAMPLE *mSndShift;
	FSOUND_SAMPLE *mSndSteer;
	FSOUND_SAMPLE *mSndPedal;
	FSOUND_SAMPLE *mSndBrake;
	FSOUND_SAMPLE *mSndHorn;
	FSOUND_SAMPLE *mSndRev;
	FSOUND_SAMPLE *mSndGrind;
	FSOUND_SAMPLE *mSndCrash;
	FSOUND_SAMPLE *mSndDoor;
	FSOUND_SAMPLE *mSndRemote;
	FSOUND_SAMPLE *mSndJammed;
	FSOUND_SAMPLE *mSndShutOff;

	car(long data, char *path);
	~car();
	void cacheData();
	void setParams(float movSpd, float rotSpd, float posAcc, float natFrict, float brakeFrict, float bankAngle);
	void refreshHud();

	/* init */
	void setLoad();
	void setIgnition();

	/* toggle states */
	void shiftUp();
	void shiftDown();

	/* switch states */
	void steerLeft();
	void steerRight();
	void reset();

	/* hold-down states */
	void pedalDown();
	void pedalUp();
	void brakeDown();
	void brakeUp();
	void hornDown();
	void hornUp();

	/* other */
	void update();
};

#endif