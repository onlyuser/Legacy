#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h>
#include "DexGL.h"

typedef VOID (WINAPI *FUNC_EVENT)();
typedef VOID (WINAPI *FUNC_MSG)(LPSTR);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;

static DexGL *mDexGL;

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();

void WINAPI DexGL_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
int WINAPI DexGL_sum(int a, int b);
char *WINAPI DexGL_echo(char *text);

//=============================================================================
void WINAPI DexGL_load(HWND hWnd);
void WINAPI DexGL_unload();
//=============================================================================
void WINAPI DexGL_resize(int width, int height);
void WINAPI DexGL_clear();
void WINAPI DexGL_paint();
void WINAPI DexGL_saveImage(void *data, bool depth, float scale, float bias);
//=============================================================================
long WINAPI DexGL_listGen(long vertCnt, long faceCnt, long *face, float *vertex, float *color, float *normal, float *anchor);
void WINAPI DexGL_listKill(long id);
//=============================================================================
long WINAPI DexGL_texGen(long *data, int width, int height, bool mipmap);
void WINAPI DexGL_texKill(long id);
void WINAPI DexGL_texBind(long id);
//=============================================================================
long WINAPI DexGL_fontGen(char *name, int size, bool bold, bool italic, bool underline, bool strikeOut);
void WINAPI DexGL_fontKill(long id);
void WINAPI DexGL_fontPrint(long id, char *text, float x, float y, float z, long color);
//=============================================================================
void WINAPI DexGL_view(float *trans, float pNear, float pFar, float halfTan);
void WINAPI DexGL_model(float *trans, long id);
//=============================================================================
void WINAPI DexGL_light(long index, float **attrib);
void WINAPI DexGL_brush(float **attrib, float shininess);
void WINAPI DexGL_blend(long blendOp, float alpha);
//=============================================================================
void WINAPI DexGL_mode(long drawMode);
void WINAPI DexGL_fog(long color, float density, float pNear, float pFar);
//=============================================================================
void WINAPI DexGL_tri(
	long c1, long c2, long c3,
	float x1, float y1,
	float x2, float y2,
	float x3, float y3
	);
//=============================================================================

#endif