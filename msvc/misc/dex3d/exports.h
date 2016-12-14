#ifndef H_EXPORTS
#define H_EXPORTS

#include "misc.h"
#include "scene.h"
#include "surface.h"

scene *mScene;
surface *mSurface;

void VB_CALL Dex3D_Init();
void VB_CALL Dex3D_Destroy();
void VB_CALL Dex3D_RegUserFunc(VB_FUNC, VB_FUNC, PRINT_FUNC, TRI_FUNC, GRAD_FUNC, PIX_FUNC);
void VB_CALL Dex3D_SetScene(long, long, long, long, bool);
long VB_CALL Dex3D_Render(long);
void VB_CALL Dex3D_Reset();

long VB_CALL Dex3D_AddMesh(long, long);
long VB_CALL Dex3D_AddCamera();
long VB_CALL Dex3D_AddLight();

void VB_CALL Dex3D_RemMesh(long);
void VB_CALL Dex3D_RemCamera(long);
void VB_CALL Dex3D_RemLight(long);

void VB_CALL Dex3D_SetMesh(long, bool);
void VB_CALL Dex3D_SetCamera(long, float, float, float, bool, float, bool, bool);
void VB_CALL Dex3D_SetLight(long, float, float, float, long, float, float);

void VB_CALL Dex3D_MoveMesh(long, long, float, float, float);
void VB_CALL Dex3D_MoveCamera(long, long, float, float, float);
void VB_CALL Dex3D_MoveLight(long, float, float, float);

void VB_CALL Dex3D_SetVertex(long, long, float, float, float);
void VB_CALL Dex3D_SetFace(long, long, long, long, long);
void VB_CALL Dex3D_SetColor(long, long, long);
void VB_CALL Dex3D_SetAxis(long, float, float, float);

void VB_CALL Dex3D_CenterAxis(long);
void VB_CALL Dex3D_OrbitCamera(long, float, float, float, float, float, float);
void VB_CALL Dex3D_LinkMesh(long, long);
void VB_CALL Dex3D_FlipFaces(long);

long VB_CALL Dex3D_AddPoly(float, long, long);
long VB_CALL Dex3D_Load(char *, long);
void VB_CALL Dex3D_Save(char *, long);
void VB_CALL Dex3D_Load3ds(char *, long);

#endif
