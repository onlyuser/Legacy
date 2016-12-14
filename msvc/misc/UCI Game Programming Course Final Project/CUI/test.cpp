#include "test.h"

//====================//
// TEST WRAPPER CLASS //
//====================//

class test
{
public:
	long mHandle;

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
	bool mShroom;

	long pCamera;
	long pLightA;
	long pMeshA;
	long pMeshB;
	long pMeshC;
	long pMeshD;
	long pSpriteA;
	long pSpriteB;
	long pHudA;
	long pHudB;
	long pHudC;

	float mPhase;
	float mValue;

	long mIndexA;
	char *mCaption;

	test();
	~test();
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

test *mTest;

//=============//
// TEST EVENTS //
//=============//

test::test()
{
}

test::~test()
{
}

void test::timer()
{
	mAngle += 0.25;
	mScene->moveMesh(pSpriteA, MOV_ROT, toRad(mAngle * 4), 0, 0);
	mScene->moveMesh(pSpriteB, MOV_ROT, 0, 0, toRad(mAngle * 8));
	if (mShroom)
	{
		if (mPhase < 1)
			mPhase += (float) 0.01;
		else
			mPhase--;
		mValue = (float) sin(mPhase * PI * 2);
		mScene->orbitCamera(pCamera, 0, 0, 0, mRadius + 5 * mValue, mLngAngle, mLatAngle);
		mScene->setBank(pCamera, mValue * toRad(45));
	}
}

//==========//
// RADIANCE //
//==========//

void test::display()
{
	itoa(mScene->render(pCamera, true, true), mCaption, 10);
	SetWindowText((HWND) mHandle, mCaption);

	/*
	float tempA;
	float *dir;

	dir = new float[3];
	itoa(mScene->renderEx(pCamera), mCaption, 10);
	vectorFromAngle(dir, ((camera *) pCamera)->mAngle);
	tempA = mScene->beam(
		((camera *) pCamera)->mOrigin,
		dir,
		10
	);
	sprintf(mCaption, "%f", tempA);
	SetWindowText((HWND) mHandle, mCaption);
	delete []dir;
	*/
}

void test::keyDown(BYTE key)
{
	switch (key)
	{
	case 'q': /* toggle render modes */
		mDrawMode = (mDrawMode + 1) % 9;
		mScene->setDrawMode(mDrawMode);
		break;
	case 'w':
		mShroom = !mShroom;
		if (!mShroom)
		{
			test::mouseDown(1, 0, 0);
			test::mouseMove(1, 0, 0);
			test::mouseUp(1, 0, 0);
		}
		break;
	case 'e':
		mScene->tessByEdge(pMeshB, 1);
	}
}

void test::keyUp(BYTE key)
{
}

void test::mouseDown(long button, long x, long y)
{
	mButton = button;
	mPrevX = x;
	mPrevY = y;
}

void test::mouseMove(long button, long x, long y)
{
	float *tempA;

	tempA = new float[3];
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
		mScene->orbitCamera(pCamera, 0, 0, 0, mRadius, mLngAngle, mLatAngle);
		mPrevX = x;
		mPrevY = y;
	}
	mScene->getVector(pCamera, MOV_POS, tempA[0], tempA[1], tempA[2]);
	mScene->moveLight(pLightA, tempA[0], tempA[1], tempA[2]);
	delete []tempA;
}

void test::mouseUp(long button, long x, long y)
{
	mButton = 0;
}

void test::load(char *appPath, char *resPath, long handle)
{
	setPath(appPath, resPath);
	mHandle = handle;

	mOrbitSpeed = (float) 0.01;
	mDollySpeed = (float) 0.1;
	mAngle = 0;
	mLngAngle = 0;
	mLatAngle = 0;
	mRadius = 10;

	mDrawMode = -1;

	/* load material library */
	mScene->loadMatLib(getPath("materials.lib"));

	/* cameras, lights */
	pCamera = mScene->addCamera();
	pLightA = mScene->addLight();
	mScene->moveLight(pLightA, 10, 10, -10);

	goto Skip2;

	pMeshA = mScene->addBox(10, 10, 10);
	mScene->centAxis(pMeshA);
	mScene->moveMesh(pMeshA, MOV_POS, 0, 0, 0);
	mScene->tessByEdge(pMeshA, 4);
	//mScene->tessByColor(pMeshA, 0.1); // FIX ME!!
	mScene->setTexture(pMeshA, getPath("red2.bmp"), DIR_RADIAL, true);
	mScene->flipFaces(pMeshA);
	mScene->partMesh(pMeshA, 400);

	goto Skip1;
Skip2:

	/* tex-mapped airplane */
	//pMeshA = mScene->load3ds(getPath("dc10b.3ds"), 0);
	pMeshA = mScene->load3ds(getPath("sphere.3ds"), 0);
	//pMeshA = mScene->addRamp(10, 5, 15);
	//mScene->flipFaces(pMeshA);
	//mScene->moveMesh(pMeshA, MOV_SCALE, (float) 0.01, (float) 0.01, (float) 0.01);
	mScene->moveMesh(pMeshA, MOV_SCALE, (float) 0.1, (float) 0.1, (float) 0.1);
	//mScene->setTexture(pMeshA, getPath("face.bmp"), DIR_BACK, false);
	mScene->setMaterial(pMeshA, "Copper");
	mScene->setMeshName(pMeshA, "ball", "qwe");
	mIndexA = mScene->findMesh("ball");
	if (mIndexA != 0)
		mScene->setTexture(mIndexA, getPath("face_x.bmp"), DIR_BACK, false);

	/* tex-mapped block */
	pMeshB = mScene->addBox(1, 1, 1);
	mScene->centAxis(pMeshB);
	mScene->moveMesh(pMeshB, MOV_SCALE, 1, 1, 4);
	mScene->moveMesh(pMeshB, MOV_POS, 2, 0, 0);
	mScene->setTexture(pMeshB, getPath("boy.bmp"), DIR_BACK, false);
	mScene->setMaterial(pMeshB, "Ruby");

	/* sky-box */
	//pMeshC = mScene->addBox(1, 1, 1);
	pMeshC = mScene->addGeo(1, 3);
	mScene->centAxis(pMeshC);
	mScene->flipFaces(pMeshC);
	mScene->moveMesh(pMeshC, MOV_SCALE, 10, 10, 10);
	//mScene->imprintMesh(pMeshC);
	//mScene->moveMesh(pMeshC, MOV_ROT, 0, toRad(-90), 0);
	//mScene->setTexture(pMeshC, getPath("mars.bmp"), DIR_TOP, true);
	//mScene->setTexture(pMeshC, getPath("sky2.bmp"), DIR_TOP, true);
	//mScene->setTexture(pMeshC, getPath("sky2b.bmp"), DIR_RADIAL, true);
	mScene->setTexture(pMeshC, getPath("sky3.bmp"), DIR_RADIAL, true);
	//mScene->partMesh(pMeshC, 100);

	/* garry's pimp-mobile */
	pMeshD = mScene->load3ds(getPath("qwe.3ds"), 0);
	mScene->moveMesh(pMeshD, MOV_SCALE, (float) 0.005, (float) 0.005, (float) 0.005);
	mScene->moveMesh(pMeshD, MOV_POS, 0, 0, -2);
	mScene->setTexture(pMeshD, getPath("face.bmp"), DIR_FRONT, false);
	mScene->setMaterial(pMeshD, "Emerald");

	/* floating sprite */
	pSpriteA = mScene->addBox(1, 1, 1);
	mScene->moveMesh(pSpriteA, MOV_POS, 1, 1, 4);
	mScene->setSprite(pSpriteA, getPath("face_x.bmp"), getPath("face_m.bmp"), (float) 0.1);

	/* floating sprite */
	pSpriteB = mScene->addBox(1, 1, 1);
	mScene->moveMesh(pSpriteB, MOV_POS, 0, 2, 0);
	mScene->setSprite(pSpriteB, getPath("face.bmp"), NULL, (float) 0.1);

	/* heads-up display */
	pHudA = mScene->addHud();
	mScene->setHud(pHudA, getPath("grid.bmp"), getPath("grid_m.bmp"));
	mScene->moveHud(pHudA, 5, 5, 10, 10);
	pHudB = mScene->addHud();
	mScene->setHud(pHudB, getPath("grid2.bmp"), NULL);
	mScene->moveHud(pHudB, 45, 5, 10, 10);
	pHudC = mScene->addHud();
	mScene->setHud(pHudC, getPath("face_x.bmp"), getPath("face_m.bmp"));
	mScene->moveHud(pHudC, 85, 5, 1, 1);

	/* fly plane in barrel-loop */
	mScene->setMotion(pMeshA, 1, false);
	mScene->setMaxSpeed(pMeshA, (float) 0.1, toRad(2));
	mScene->moveMesh(pMeshA, MOV_ACC, 0, 0, (float) 0.001);
	mScene->moveMesh(pMeshA, MOV_ANGACC, 0, -toRad((float) 0.1), 0);
	mScene->setPartSrc(pMeshA, (float) 0.5, rgb(0, 0, 255), (float) 0.1, (float) 0.1, toRad(20), 100);
	//mScene->setLife(pMeshA, 50);

	/* spin block */
	mScene->moveMesh(pMeshB, MOV_ANGVEL, toRad(5), 0, 0);

	/* spin car */
	mScene->moveMesh(pMeshD, MOV_ANGVEL, 0, 0, toRad(5));

	/* link hierarchy */
	mScene->linkMesh(pSpriteB, pSpriteA);
	mScene->linkMesh(pSpriteA, pMeshA);
	mScene->unlinkMesh(pSpriteA);

Skip1:

	/* init drunkenness */
	mPhase = 0;
	mShroom = false;
	//mScene->setFilter(LOG_INVERT);

	/* bind key-listener */
	mKeyBase->addListener('q', false);
	mKeyBase->addListener('w', false);
	//mKeyBase->addListener('e', false);

	/* call these to initialize camera */
	test::mouseDown(1, 0, 0);
	test::mouseMove(1, 0, 0);
	test::mouseUp(1, 0, 0);
	test::keyDown('q');

	mCaption = new char[10];
}

void test::unload()
{
	delete []mCaption;
}

//===============//
// TEST REDIRECT //
//===============//

void test_timer()
{mTest->timer();}

void test_display()
{mTest->display();}

void test_keyDown(BYTE key)
{mTest->keyDown(key);}

void test_keyUp(BYTE key)
{mTest->keyUp(key);}

void test_mouseDown(long button, long x, long y)
{mTest->mouseDown(button, x, y);}

void test_mouseMove(long button, long x, long y)
{mTest->mouseMove(button, x, y);}

void test_mouseUp(long button, long x, long y)
{mTest->mouseUp(button, x, y);}

void test_load(char *appPath, char *resPath, long handle)
{
	mTest = new test();
	mTest->load(appPath, resPath, handle);
}

void test_unload()
{
	mTest->unload();
	delete mTest;
}