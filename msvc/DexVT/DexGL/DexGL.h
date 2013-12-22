#ifndef H_DEXGL
#define H_DEXGL

#include <windows.h>
#include <gl\gl.h>
#include <gl\glu.h>
#include "glext.h"
#include <string>
#include "math.h"
#include "TDexGL.h"

#define OGL_ONLY
#define OGL_FLAT
//#define OGL_GRAD
#define OGL_CVA
//#define GDI_FLAT
//#define GDI_GRAD

#define getR(c) (c & 0xFF)
#define getG(c) ((c >> 8) & 0xFF)
#define getB(c) ((c >> 16) & 0xFF)
#define getA(c) ((c >> 24) & 0xFF)

#define CHAR_START 32
#define CHAR_COUNT 96

class DexGL
{
private:
	HWND hWnd;
	HDC hDC;
	int mWidth;
	int mHeight;
	bool mWire;
	#ifdef OGL_ONLY
		PFNGLLOCKARRAYSEXTPROC glLockArraysEXT;
		PFNGLUNLOCKARRAYSEXTPROC glUnlockArraysEXT;
		PFNGLGENBUFFERSARBPROC glGenBuffersARB;
		PFNGLDELETEBUFFERSARBPROC glDeleteBuffersARB;
		PFNGLBUFFERDATAARBPROC glBufferDataARB;
		PFNGLBINDBUFFERARBPROC glBindBufferARB;
		PFNGLBLENDCOLORPROC glBlendColorEXT;
		PFNGLBLENDEQUATIONPROC glBlendEquationEXT;
		HGLRC hRC;
	#else
		HDC mTempDC;
		HBITMAP mPrevBM;
	#endif
	#ifdef GDI_FLAT
		POINT mPoint[3];
		HPEN mPrevPen;
	#endif
	#ifdef GDI_GRAD
		TRIVERTEX mVertex[3];
		GRADIENT_TRIANGLE mFace;
	#endif
public:
	DexGL(HWND hWnd);
	~DexGL();
	//=============================================================================
	void resize(int width, int height);
	void clear();
	void paint();
	void saveImage(void *data, bool depth, float scale, float bias);
	//=============================================================================
	long funcListGen(long vertCnt, long faceCnt, long *face, float *vertex, float *color, float *normal, float *anchor);
	void funcListKill(long id);
	//=============================================================================
	long funcTexGen(long *data, int width, int height, bool mipmap);
	void funcTexKill(long id);
	void funcTexBind(long id);
	//=============================================================================
	long funcFontGen(char *name, int size, bool bold, bool italic, bool underline, bool strikeOut);
	void funcFontKill(long id);
	void funcFontPrint(long id, char *text, float x, float y, float z, long color);
	//=============================================================================
	void funcView(float *trans, float pNear, float pFar, float halfTan);
	void funcModel(float *trans, long id);
	//=============================================================================
	void funcLight(long index, float **attrib);
	void funcBrush(float **attrib, float shininess);
	void funcBlend(BLEND_OP::BLEND_OP blendOp, float alpha);
	//=============================================================================
	void funcMode(DRAW_MODE::DRAW_MODE drawMode);
	void funcFog(long color, float density, float pNear, float pFar);
	//=============================================================================
	void funcTri(
		long c1, long c2, long c3,
		float x1, float y1,
		float x2, float y2,
		float x3, float y3
		);
	//=============================================================================
};

#endif