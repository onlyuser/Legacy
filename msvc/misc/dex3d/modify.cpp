#include "scene.h"

long scene::addMesh(long vertCount, long faceCount)
{
	long result;

	mMeshList.add(new mesh(vertCount, faceCount));
	refresh();
	result = mMeshList.count() - 1;
	return result;
}

long scene::addCamera()
{
	long result;

	mCameraList.add(new camera());
	result = mCameraList.count() - 1;
	return result;
}

long scene::addLight()
{
	long result;

	mLightList.add(new light());
	result = mLightList.count() - 1;
	return result;
}

void scene::remMesh(long index)
{
	mMeshList.toIndex(index);
	mMeshList.remove();
	refresh();
}

void scene::remCamera(long index)
{
	mCameraList.toIndex(index);
	mCameraList.remove();
}

void scene::remLight(long index)
{
	mLightList.toIndex(index);
	mLightList.remove();
}

void scene::setMesh(long meshIndex, bool visible)
{
	mesh *pMesh;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	pMesh->mVisible = visible;
}

void scene::setCamera(long camIndex, float fov, float pNear, float pFar, bool perspect, float zoom, bool reflect, bool fog)
{
	camera *pCamera;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	pCamera->mFov = fov;
	pCamera->mNear = pNear;
	pCamera->mFar = pFar;
	pCamera->mPerspect = perspect;
	pCamera->mZoom = zoom;
	pCamera->mReflect = reflect;
	pCamera->mFog = fog;
}

void scene::setLight(long lightIndex, long color, float pNear, float pFar)
{
	light *pLight;

	mLightList.toIndex(lightIndex);
	pLight = mLightList.getData();
	pLight->mColor = color;
	pLight->mNear = pNear;
	pLight->mFar = pFar;
}

void scene::moveMesh(long meshIndex, long moveOp, float a, float b, float c)
{
	mesh *pMesh;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	switch (moveOp)
	{
	case 0:
		pMesh->mOrigin[0] = a;
		pMesh->mOrigin[1] = b;
		pMesh->mOrigin[2] = c;
		break;
	case 1:
		pMesh->mAngle[0] = a;
		pMesh->mAngle[1] = b;
		pMesh->mAngle[2] = c;
		break;
	case 2:
		pMesh->mScale[0] = a;
		pMesh->mScale[1] = b;
		pMesh->mScale[2] = c;
	}
	pMesh->buildTrans();
}

void scene::moveCamera(long camIndex, long moveOp, float a, float b, float c)
{
	camera *pCamera;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	switch (moveOp)
	{
	case 0:
		pCamera->mOrigin[0] = a;
		pCamera->mOrigin[1] = b;
		pCamera->mOrigin[2] = c;
		break;
	case 1:
		pCamera->mAngle[0] = a;
		pCamera->mAngle[1] = b;
		pCamera->mAngle[2] = c;
	}
	pCamera->buildTrans();
}

void scene::moveLight(long lightIndex, float x, float y, float z)
{
	light *pLight;

	mLightList.toIndex(lightIndex);
	pLight = mLightList.getData();
	pLight->mOrigin[0] = x;
	pLight->mOrigin[1] = y;
	pLight->mOrigin[2] = z;
}

void scene::setVertex(long meshIndex, long vertIndex, float x, float y, float z)
{
	mesh *pMesh;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	pMesh->mVertex[vertIndex][0] = x;
	pMesh->mVertex[vertIndex][1] = y;
	pMesh->mVertex[vertIndex][2] = z;
}

void scene::setFace(long meshIndex, long faceIndex, long a, long b, long c)
{
	mesh *pMesh;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	pMesh->mFace[faceIndex].a = a;
	pMesh->mFace[faceIndex].b = b;
	pMesh->mFace[faceIndex].c = c;
}

void scene::setColor(long meshIndex, long faceIndex, long color, float alpha)
{
	int i;
	mesh *pMesh;
	face *pFace;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	if (faceIndex != -1)
	{
		pFace = &(pMesh->mFace[faceIndex]);
		pFace->mColor = color;
		pFace->mAlpha = alpha;
	}
	else
		for (i = 0; i < pMesh->mFaceCount; i++)
			setColor(meshIndex, i, color, alpha);
}

void scene::setAxis(long meshIndex, float x, float y, float z)
{
	mesh *pMesh;
	float *axis;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	axis = new float[3];
	axis[0] = x;
	axis[1] = y;
	axis[2] = z;
	pMesh->setAxis(axis);
	delete []axis;
}

void scene::linkMesh(long meshIndexA, long meshIndexB)
{
	mesh *pMeshA;
	mesh *pMeshB;

	mMeshList.toIndex(meshIndexA);
	pMeshA = mMeshList.getData();
	mMeshList.toIndex(meshIndexB);
	pMeshB = mMeshList.getData();
	if (meshIndexB != -1)
		pMeshA->mParent = pMeshB;
	else
		pMeshA->mParent = NULL;
}

void scene::centerAxis(long meshIndex)
{
	mesh *pMesh;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	pMesh->centerAxis();
}

void scene::flipFaces(long meshIndex)
{
	int i;
	mesh *pMesh;
	face *pFace;
	long tempA;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	for (i = 0; i < pMesh->mFaceCount; i++)
	{
		pFace = &(pMesh->mFace[i]);
		tempA = pFace->b;
		pFace->b = pFace->c;
		pFace->c = tempA;
	}
}

void scene::orbitCamera(long camIndex, float x, float y, float z, float radius, float lngAngle, float latAngle)
{
	camera *pCamera;
	float *origin;

	mCameraList.toIndex(camIndex);
	pCamera = mCameraList.getData();
	origin = new float[3];
	origin[0] = x;
	origin[1] = y;
	origin[2] = z;
	pCamera->orbit(origin, radius, lngAngle, latAngle);
	delete []origin;
}
