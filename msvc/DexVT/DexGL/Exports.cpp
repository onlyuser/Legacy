#include "Exports.h"

BOOL WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason)
	{
		case DLL_PROCESS_ATTACH:
			dll_init();
			break;
		case DLL_PROCESS_DETACH:
			dll_destroy();
	}
	return true;
}

void dll_init()
{
}

void dll_destroy()
{
}

void WINAPI DexGL_regUserFunc(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
{
	mFuncEvent = funcEvent;
	mFuncMsg = funcMsg;
}

int WINAPI DexGL_sum(int a, int b)
{
	return a + b;
}

char *WINAPI DexGL_echo(char *text)
{
	return text;
}

//=============================================================================

void WINAPI DexGL_load(HWND hWnd)
{
	mDexGL = new DexGL(hWnd);
}

void WINAPI DexGL_unload()
{
	delete mDexGL;
}

//=============================================================================

void WINAPI DexGL_resize(int width, int height)
{
	mDexGL->resize(width, height);
}

void WINAPI DexGL_clear()
{
	mDexGL->clear();
}

void WINAPI DexGL_paint()
{
	mDexGL->paint();
}

void WINAPI DexGL_saveImage(void *data, bool depth, float scale, float bias)
{
	mDexGL->saveImage(data, depth, scale, bias);
}

//=============================================================================

long WINAPI DexGL_listGen(long vertCnt, long faceCnt, long *face, float *vertex, float *color, float *normal, float *anchor)
{
	return mDexGL->funcListGen(vertCnt, faceCnt, face, vertex, color, normal, anchor);
}

void WINAPI DexGL_listKill(long id)
{
	mDexGL->funcListKill(id);
}

//=============================================================================

long WINAPI DexGL_texGen(long *data, int width, int height, bool mipmap)
{
	return mDexGL->funcTexGen(data, width, height, mipmap);
}

void WINAPI DexGL_texKill(long id)
{
	mDexGL->funcTexKill(id);
}

void WINAPI DexGL_texBind(long id)
{
	mDexGL->funcTexBind(id);
}

long WINAPI DexGL_fontGen(char *name, int size, bool bold, bool italic, bool underline, bool strikeOut)
{
	return mDexGL->funcFontGen(name, size, bold, italic, underline, strikeOut);
}

void WINAPI DexGL_fontKill(long id)
{
	mDexGL->funcFontKill(id);
}

void WINAPI DexGL_fontPrint(long id, char *text, float x, float y, float z, long color)
{
	mDexGL->funcFontPrint(id, text, x, y, z, color);
}

//=============================================================================

void WINAPI DexGL_view(float *trans, float pNear, float pFar, float halfTan)
{
	mDexGL->funcView(trans, pNear, pFar, halfTan);
}

void WINAPI DexGL_model(float *trans, long id)
{
	mDexGL->funcModel(trans, id);
}

//=============================================================================

void WINAPI DexGL_light(long index, float **attrib)
{
	mDexGL->funcLight(index, attrib);
}

void WINAPI DexGL_brush(float **attrib, float shininess)
{
	mDexGL->funcBrush(attrib, shininess);
}

void WINAPI DexGL_blend(long blendOp, float alpha)
{
	mDexGL->funcBlend((BLEND_OP::BLEND_OP) blendOp, alpha);
}

//=============================================================================

void WINAPI DexGL_mode(long drawMode)
{
	mDexGL->funcMode((DRAW_MODE::DRAW_MODE) drawMode);
}

void WINAPI DexGL_fog(long color, float density, float pNear, float pFar)
{
	mDexGL->funcFog(color, density, pNear, pFar);
}

//=============================================================================

void WINAPI DexGL_tri(
	long c1, long c2, long c3,
	float x1, float y1,
	float x2, float y2,
	float x3, float y3
	)
{
	mDexGL->funcTri(c1, c2, c3, x1, y1, x2, y2, x3, y3);
}