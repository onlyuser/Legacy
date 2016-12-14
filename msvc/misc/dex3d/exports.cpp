#include "exports.h"

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason) 
	{ 
		case DLL_PROCESS_ATTACH:
			Dex3D_Init();
			break;
		case DLL_PROCESS_DETACH:
			Dex3D_Destroy();
	}
	return TRUE;
}

void VB_CALL Dex3D_Init()
{
	mScene = new scene();
	mSurface = new surface();
}

void VB_CALL Dex3D_Destroy()
{
	delete mScene;
	delete mSurface;
}

void VB_CALL Dex3D_RegUserFunc(VB_FUNC eventFunc, VB_FUNC clearFunc, PRINT_FUNC printFunc, TRI_FUNC triFunc, GRAD_FUNC gradFunc, PIX_FUNC pixFunc)
{
	mSurface->regUserFunc(eventFunc, clearFunc, printFunc, triFunc, gradFunc, pixFunc);
}

void VB_CALL Dex3D_SetScene(long camIndex, long width, long height, long drawMode, bool dblSided)
{
	camera *pCamera;

	mScene->mCameraList.toIndex(camIndex);
	pCamera = mScene->mCameraList.getData();
	pCamera->setSize(width, height);
	mSurface->setSize(width, height);
	mScene->mDrawMode = drawMode;
	mScene->mDblSided = dblSided;
}

long VB_CALL Dex3D_Render(long camIndex)
{
	return mScene->render(camIndex, mSurface);
}

void VB_CALL Dex3D_Reset()
{
	mScene->reset();
}

long VB_CALL Dex3D_AddMesh(long vertCount, long faceCount)
{
	return mScene->addMesh(vertCount, faceCount);
}

long VB_CALL Dex3D_AddCamera()
{
	return mScene->addCamera();
}

long VB_CALL Dex3D_AddLight()
{
	return mScene->addLight();
}

void VB_CALL Dex3D_RemMesh(long index)
{
	mScene->remMesh(index);
}

void VB_CALL Dex3D_RemCamera(long index)
{
	mScene->remCamera(index);
}

void VB_CALL Dex3D_RemLight(long index)
{
	mScene->remLight(index);
}

void VB_CALL Dex3D_SetMesh(long meshIndex, bool visible)
{
	mScene->setMesh(meshIndex, visible);
}

void VB_CALL Dex3D_SetCamera(long camIndex, float fov, float pNear, float pFar, bool perspect, float zoom, bool reflect, bool fog)
{
	mScene->setCamera(camIndex, fov, pNear, pFar, perspect, zoom, reflect, fog);
}

void VB_CALL Dex3D_SetLight(long lightIndex, long color, float pNear, float pFar)
{
	mScene->setLight(lightIndex, color, pNear, pFar);
}

void VB_CALL Dex3D_MoveMesh(long meshIndex, long moveOp, float a, float b, float c)
{
	mScene->moveMesh(meshIndex, moveOp, a, b, c);
}

void VB_CALL Dex3D_MoveCamera(long camIndex, long moveOp, float a, float b, float c)
{
	mScene->moveCamera(camIndex, moveOp, a, b, c);
}

void VB_CALL Dex3D_MoveLight(long lightIndex, float x, float y, float z)
{
	mScene->moveLight(lightIndex, x, y, z);
}

void VB_CALL Dex3D_SetVertex(long meshIndex, long vertIndex, float x, float y, float z)
{
	mScene->setVertex(meshIndex, vertIndex, x, y, z);
}

void VB_CALL Dex3D_SetFace(long meshIndex, long faceIndex, long a, long b, long c)
{
	mScene->setFace(meshIndex, faceIndex, a, b, c);
}

void VB_CALL Dex3D_SetColor(long meshIndex, long faceIndex, long color, float alpha)
{
	mScene->setColor(meshIndex, faceIndex, color, alpha);
}

void VB_CALL Dex3D_SetAxis(long meshIndex, float x, float y, float z)
{
	mScene->setAxis(meshIndex, x, y, z);
}

void VB_CALL Dex3D_LinkMesh(long meshIndexA, long meshIndexB)
{
	mScene->linkMesh(meshIndexA, meshIndexB);
}

void VB_CALL Dex3D_CenterAxis(long meshIndex)
{
	mScene->centerAxis(meshIndex);
}

void VB_CALL Dex3D_OrbitCamera(long camIndex, float x, float y, float z, float radius, float lngAngle, float latAngle)
{
	mScene->orbitCamera(camIndex, x, y, z, radius, lngAngle, latAngle);
}

void VB_CALL Dex3D_FlipFaces(long meshIndex)
{
	mScene->flipFaces(meshIndex);
}

long VB_CALL Dex3D_AddPoly(float radius, long lngSteps, long latSteps)
{
	return mScene->addPoly(radius, lngSteps, latSteps);
}

long VB_CALL Dex3D_Load(char *filename, long meshIndex)
{
	return mScene->load(filename, meshIndex);
}

void VB_CALL Dex3D_Save(char *filename, long meshIndex)
{
	mScene->save(filename, meshIndex);
}

void VB_CALL Dex3D_Load3ds(char *filename, long meshIndex)
{
	mScene->load3ds(filename, meshIndex);
}
