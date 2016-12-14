#include "scene.h"

//============//
// ADD OBJECT //
//============//

long scene::addMesh(long vertCnt, long faceCnt)
{
	long result;

	result = (long) new mesh(vertCnt, faceCnt);
	if (result != NULL)
		mMeshList.add((mesh *) result);
	return result;
}

long scene::addCamera()
{
	long result;

	result = (long) new camera(mWidth, mHeight);
	if (result != NULL)
		mCameraList.add((camera *) result);
	return result;
}

long scene::addLight()
{
	long result;
	long handle;

	handle = getNextLight();
	if (handle != -1)
		handle += GL_LIGHT0;
	result = (long) new light(handle);
	if (result != NULL)
		mLightList.add((light *) result);
	return result;
}

long scene::addHud()
{
	long result;

	result = (long) new image();
	if (result != NULL)
		mHudList.add((image *) result);
	return result;
}

//===============//
// REMOVE OBJECT //
//===============//

void scene::remMesh(long data)
{
	if (mMeshList.find((mesh *) data))
		delete (mesh *) mMeshList.remove();
}

void scene::remCamera(long data)
{
	if (mCameraList.find((camera *) data))
		delete (camera *) mCameraList.remove();
}

void scene::remLight(long data)
{
	if (mLightList.find((light *) data))
		delete (light *) mLightList.remove();
}

void scene::remHud(long data)
{
	if (mHudList.find((image *) data))
		delete (image *) mHudList.remove();
}

//===============//
// ENABLE OBJECT //
//===============//

void scene::enableMesh(long data, bool value)
{
	((mesh *) data)->mVisible = value;
}

void scene::enableLight(long data, bool value)
{
	((light *) data)->setEnable(value);
}

void scene::enableHud(long data, bool value)
{
	((image *) data)->mVisible = value;
}

//============//
// SET OBJECT //
//============//

void scene::setMesh(long data, long ambient, long diffuse, long specular, long emission, float shininess)
{
	((mesh *) data)->setParams(ambient, diffuse, specular, emission, shininess);
}

void scene::setCamera(long data, float fov, float aspect, float pNear, float pFar, float range)
{
	((camera *) data)->setParams(fov, aspect, pNear, pFar, range);
}

void scene::setLight(long data, long ambient, long diffuse, long specular)
{
	((light *) data)->setParams(ambient, diffuse, specular);
}

void scene::setTexture(long data, char *filename, long mapDir, bool skybox)
{
	long width;
	long height;
	long *texture;

	texture = loadBmp(filename, width, height);
	((mesh *) data)->setTexture(texture, width, height, mapDir, skybox);
	delete []texture;
}

void scene::setSprite(long data, char *filename, char *pMask, float scale)
{
	long width;
	long height;
	long *sprite;
	long *mask;

	sprite = loadBmp(filename, width, height);
	if (pMask != NULL)
		mask = loadBmp(pMask, width, height);
	else
		mask = NULL;
	((mesh *) data)->setSprite(sprite, width, height, mask, scale);
	delete []sprite;
	if (pMask != NULL)
		delete []mask;
}

void scene::setHud(long data, char *filename, char *pMask)
{
	long width;
	long height;
	long *sprite;
	long *mask;

	sprite = loadBmp(filename, width, height);
	if (pMask != NULL)
		mask = loadBmp(pMask, width, height);
	else
		mask = NULL;
	((image *) data)->setParams(sprite, width, height, mask);
	delete []sprite;
	if (pMask != NULL)
		delete []mask;
}

//=============//
// MOVE OBJECT //
//=============//

void scene::moveMesh(long data, long opCode, float a, float b, float c)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = a;
	tempA[1] = b;
	tempA[2] = c;
	((mesh *) data)->move(opCode, tempA);
	delete []tempA;
}

void scene::moveCamera(long data, long opCode, float a, float b, float c)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = a;
	tempA[1] = b;
	tempA[2] = c;
	((camera *) data)->move(opCode, tempA);
	delete []tempA;
}

void scene::moveLight(long data, float a, float b, float c)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = a;
	tempA[1] = b;
	tempA[2] = c;
	((light *) data)->move(0, tempA);
	delete []tempA;
}

void scene::moveHud(long data, long x, long y, float scaleX, float scaleY)
{
	((image *) data)->move(x, y, scaleX, scaleY, 0);
}

//============//
// GET VECTOR //
//============//

void scene::getVector(long data, long opCode, float &a, float &b, float &c)
{
	float *tempA;

	tempA = new float[3];
	((mesh *) data)->getVector(opCode, tempA);
	a = tempA[0];
	b = tempA[1];
	c = tempA[2];
	delete []tempA;
}

//==================//
// SET MESH DETAILS //
//==================//

void scene::runNPC(float movSpd, float rotSpd)
{
	mesh *pMesh;
	mesh *wayPoint; 

	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh->mName != NULL)
			if (strcmp(pMesh->mName, "npc") == 0)
			{
				if (pMesh->mTarget == NULL)
				{
					pMesh->mTarget = new float[3];
					setMotion((long) pMesh, 1, false);
					moveMesh(
						(long) pMesh,
						MOV_VEL,
						0,
						0,
						randEx(movSpd * 0.5, movSpd)
					);
					moveMesh(
						(long) pMesh,
						MOV_ANGVEL,
						randEx(rotSpd * 0.5, rotSpd),
						randEx(rotSpd * 0.5, rotSpd),
						randEx(rotSpd * 0.5, rotSpd)
					);
					wayPoint = (mesh *) findWaypoint((long) pMesh);
					if (wayPoint != NULL)
					{
						vectorCopy(pMesh->mTarget, wayPoint->mOrigin);
						pMesh->mNext = wayPoint;
					}
				}
				else
				{
					wayPoint = pMesh->mNext;
					if
						(
							vectorDist(pMesh->mOrigin, wayPoint->mOrigin) <
							pMesh->mRadius + wayPoint->mRadius
						)
					{
						wayPoint = wayPoint->mNext;
						if (wayPoint != NULL)
						{
							vectorCopy(pMesh->mTarget, wayPoint->mOrigin);
							pMesh->mNext = wayPoint;
						}
					}
				}
			}
	}
}

long scene::findWaypoint(long data)
{
	long result;
	mesh *pMesh;
	float curDist;
	float bestDist;

	result = NULL;
	bestDist = BIG_NUMBER;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh != ((mesh *) data))
			if (pMesh->mTag != NULL)
				if (strlen(pMesh->mTag) != 0)
				{
					curDist = vectorDist(pMesh->mOrigin, ((mesh *) data)->mOrigin);
					if (curDist < bestDist)
					{
						result = (long) pMesh;
						bestDist = curDist;
					}
				}
	}
	return result;
}

long scene::collideMesh(long data)
{
	long result;
	long index;
	mesh *pMesh;

	result = NULL;
	if (((mesh *) data)->mCollide)
	{
		((mesh *) data)->applyTrans();
		index = mMeshList.getIndex();
		for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
		{
			pMesh = mMeshList.getData();
			if (pMesh != ((mesh *) data))
				if (pMesh->mCollide)
					if (
						vectorDist(pMesh->mOrigin, ((mesh *) data)->mOrigin) <
						pMesh->mRadius + ((mesh *) data)->mRadius
					)
						if (collide(pMesh->mBoxEx, ((mesh *) data)->mBoxEx))
							result = (long) pMesh;
		}
		mMeshList.moveTo(index);
	}
	return result;
}

float scene::beam(float *origin, float *dir, float dist)
{
	long i;
	float result;
	mesh *pMesh;
	float curDist;

	result = BIG_NUMBER;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		for (i = 0; i < pMesh->mFaceCnt; i++)
		{
			curDist = segTriSect(
				origin,
				dir,
				dist,
				pMesh->mVertex[pMesh->mFace[i].a],
				pMesh->mVertex[pMesh->mFace[i].b],
				pMesh->mVertex[pMesh->mFace[i].c]
			);
			if (curDist != -1 && curDist < result)
				result = curDist;
		}
	}
	if (result == BIG_NUMBER)
		result = -1;
	return result;
}

bool scene::occluded(float *vectA, float *vectB)
{
	bool result;
	float *tempA;
	float dist;

	tempA = new float[3];
	vectorSub(tempA, vectB, vectA);
	dist = vectorMod(tempA);
	vectorNorm(tempA, tempA);
	if (beam(vectA, tempA, dist) != -1)
		result = true;
	else
		result = false;
	delete []tempA;
	return result;
}

void scene::setPartSrc(long data, float freq, long color, float size, float speed, float spread, long ticks)
{
	((mesh *) data)->mPartSys.mFreq = freq;
	((mesh *) data)->mPartSys.mColor = color;
	((mesh *) data)->mPartSys.mSize = size;
	((mesh *) data)->mPartSys.mSpeed = speed;
	((mesh *) data)->mPartSys.mSpread = spread;
	((mesh *) data)->mPartSys.mTicks = ticks;
}

void scene::setMaterial(long data, char *name)
{
	long index;
	material *pMaterial;

	index = mMeshList.getIndex();
	for (mMatList.moveFirst(); !mMatList.eof(); mMatList.moveNext())
	{
		pMaterial = mMatList.getData();
		if (strcmp(pMaterial->mName, name) == 0)
		{
			((mesh *) data)->setParams(
				pMaterial->mAmbient,
				pMaterial->mDiffuse,
				pMaterial->mSpecular,
				pMaterial->mEmission,
				pMaterial->mShininess
			);
			mMatList.moveEnd();
		}
	}
	mMeshList.moveTo(index);
}

void scene::setMotion(long data, long style, bool collide)
{
	((mesh *) data)->setMotion(style, collide);
}

void scene::setMaxSpeed(long data, float movSpd, float rotSpd)
{
	((mesh *) data)->mMovSpdMax = movSpd;
	((mesh *) data)->mRotSpdMax = rotSpd;
}

void scene::setMeshName(long data, char *name, char *tag)
{
	((mesh *) data)->setName(name, tag);
}

long scene::findMesh(char *name)
{
	long result;
	long index;
	mesh *pMesh;

	result = NULL;
	index = mMeshList.getIndex();
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh->mName != NULL)
			if (strcmp(pMesh->mName, name) == 0)
			{
				result = (long) pMesh;
				mMeshList.moveEnd();
			}
	}
	mMeshList.moveTo(index);
	return result;
}

void scene::setVertex(long data, long index, float x, float y, float z)
{
	((mesh *) data)->setVertex(index, x, y, z);
}

void scene::setFace(long data, long index, long a, long b, long c)
{
	((mesh *) data)->setFace(index, a, b, c);
}

void scene::setAxis(long data, float x, float y, float z)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = x;
	tempA[1] = y;
	tempA[2] = z;
	((mesh *) data)->setAxis(tempA);
	delete []tempA;
}

void scene::centAxis(long data)
{
	((mesh *) data)->centAxis();
}

void scene::imprintMesh(long data)
{
	((mesh *) data)->imprint();
}

void scene::setSpan(long data, float x, float y, float z)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = x;
	tempA[1] = y;
	tempA[2] = z;
	((mesh *) data)->setSpan(tempA);
	delete []tempA;
}

void scene::setBox(long data, float x, float y, float z)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = x;
	tempA[1] = y;
	tempA[2] = z;
	((mesh *) data)->setBox(tempA);
	delete []tempA;
}

void scene::alignMesh(long data, float pos, long opCode)
{
	((mesh *) data)->align(pos, opCode);
}

void scene::flipFaces(long data)
{
	((mesh *) data)->flipFaces();
}

void scene::normalize(long data, float radius)
{
	((mesh *) data)->normalize(radius);
}

void scene::mergeMesh(long data, long other)
{
	((mesh *) data)->merge((mesh *) other);
}

void scene::tessByFace(long data, long iters)
{
	((mesh *) data)->tessByFace(iters);
}

void scene::tessByEdge(long data, long iters)
{
	((mesh *) data)->tessByEdge(iters);
}

void scene::tessByColor(long data, float maxRatio)
{
	((mesh *) data)->tessByColor(maxRatio);
}

void scene::lockMesh(long data)
{
	((mesh *) data)->lock();
}

void scene::partMesh(long data, long minThresh)
{
	((mesh *) data)->partition(minThresh);
}

void scene::setLife(long data, long ticks)
{
	((mesh *) data)->setLife(ticks);
}

void scene::linkMesh(long child, long parent)
{
	((mesh *) child)->link((mesh *) parent);
}

void scene::unlinkMesh(long data)
{
	((mesh *) data)->unlink();
}

//====================//
// SET CAMERA DETAILS //
//====================//

void scene::orbitCamera(long data, float x, float y, float z, float radius, float lngAngle, float latAngle)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = x;
	tempA[1] = y;
	tempA[2] = z;
	((camera *) data)->orbit(tempA, radius, lngAngle, latAngle);
	delete []tempA;
}

void scene::lookAt(long data, float x, float y, float z)
{
	float *tempA;

	tempA = new float[3];
	tempA[0] = x;
	tempA[1] = y;
	tempA[2] = z;
	((camera *) data)->lookAt(tempA);
	delete []tempA;
}

void scene::setBank(long data, float offset)
{
	((camera *) data)->setBank(offset);
}