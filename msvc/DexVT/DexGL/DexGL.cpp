#include "DexGL.h"

DexGL::DexGL(HWND hWnd)
{
	this->hWnd = hWnd;
	hDC = GetDC(hWnd);
	#ifdef OGL_ONLY
		//=========================================================
		static PIXELFORMATDESCRIPTOR mPFD =
		{
			sizeof(PIXELFORMATDESCRIPTOR), // size of this pfd
			1,                             // version number
			PFD_DRAW_TO_WINDOW |           // support window
			PFD_SUPPORT_OPENGL |           // support OpenGL
			PFD_DOUBLEBUFFER,              // double buffered
			PFD_TYPE_RGBA,                 // RGBA type
			24,                            // 24-bit color depth
			0, 0, 0, 0, 0, 0,              // color bits ignored
			0,                             // no alpha buffer
			0,                             // shift bit ignored
			0,                             // no accumulation buffer
			0, 0, 0, 0,                    // accum bits ignored
			32,                            // 32-bit z-buffer
			0,                             // no stencil buffer
			0,                             // no auxiliary buffer
			PFD_MAIN_PLANE,                // main layer
			0,                             // reserved
			0, 0, 0                        // layer masks ignored
		};
		int pixelFormat = ChoosePixelFormat(hDC, &mPFD);
		SetPixelFormat(hDC, pixelFormat, &mPFD);
		hRC = wglCreateContext(hDC);
		wglMakeCurrent(hDC, hRC);
		//=========================================================
		char *extList = (char *) glGetString(GL_EXTENSIONS);
		if (strstr(extList, "GL_EXT_compiled_vertex_array"))
		{
			glLockArraysEXT = (PFNGLLOCKARRAYSEXTPROC) wglGetProcAddress("glLockArraysEXT");
			glUnlockArraysEXT = (PFNGLUNLOCKARRAYSEXTPROC) wglGetProcAddress("glUnlockArraysEXT");
		}
		else
			glLockArraysEXT = NULL;
		if (false && strstr(extList, "GL_ARB_vertex_buffer_object"))
		{
			glGenBuffersARB = (PFNGLGENBUFFERSARBPROC) wglGetProcAddress("glGenBuffersARB");
			glDeleteBuffersARB = (PFNGLDELETEBUFFERSARBPROC) wglGetProcAddress("glDeleteBuffersARB");
			glBufferDataARB = (PFNGLBUFFERDATAARBPROC) wglGetProcAddress("glBufferDataARB");
			glBindBufferARB = (PFNGLBINDBUFFERARBPROC) wglGetProcAddress("glBindBufferARB");
		}
		else
			glBindBufferARB = NULL;
		if (strstr(extList, "GL_ARB_imaging"))
		{
			glBlendColorEXT = (PFNGLBLENDCOLORPROC) wglGetProcAddress("glBlendColorEXT");
			glBlendEquationEXT = (PFNGLBLENDEQUATIONPROC) wglGetProcAddress("glBlendEquationEXT");
		}
		else
			glBlendColorEXT = NULL;
		//=========================================================
		this->funcView(NULL, 0, 0, 0);
		//=========================================================
	#else
		mTempDC = CreateCompatibleDC(hDC);
		HBITMAP bitmap = CreateCompatibleBitmap(hDC, 1, 1);
		mPrevBM = (HBITMAP) SelectObject(mTempDC, bitmap);
	#endif
	#ifdef OGL_CVA
		glEnable(GL_CULL_FACE);
		glDepthFunc(GL_LEQUAL);
		glEnable(GL_COLOR_MATERIAL);
		glFogi(GL_FOG_MODE, GL_EXP);
		this->funcFog(0, 0, 0, 1);
	#endif
	#ifdef GDI_FLAT
		HPEN pen = CreatePen(PS_NULL, 0, 0);
		mPrevPen = (HPEN) SelectObject(mTempDC, pen);
	#endif
	#ifdef GDI_GRAD
		mVertex[0].Alpha = 0;
		mVertex[1].Alpha = 0;
		mVertex[2].Alpha = 0;
		mFace.Vertex1 = 0;
		mFace.Vertex2 = 1;
		mFace.Vertex3 = 2;
	#endif
	this->funcMode(DRAW_MODE::TEXTURED);
}

DexGL::~DexGL()
{
	#ifdef GDI_FLAT
		HPEN pen = (HPEN) SelectObject(mTempDC, mPrevPen);
		DeleteObject(pen);
	#endif
	#ifdef OGL_ONLY
		wglMakeCurrent(NULL, NULL);
		wglDeleteContext(hRC);
	#else
		HBITMAP bitmap = (HBITMAP) SelectObject(mTempDC, mPrevBM);
		DeleteObject(bitmap);
		DeleteDC(mTempDC);
	#endif
	ReleaseDC(hWnd, hDC);
}

//=============================================================================

void DexGL::resize(int width, int height)
{
	#ifdef OGL_ONLY
		if (width && height)
			glViewport(0, 0, width, height);
	#else
		HBITMAP bitmap = (HBITMAP) SelectObject(mTempDC, mPrevBM);
		DeleteObject(bitmap);
		bitmap = CreateCompatibleBitmap(hDC, width, height);
		mPrevBM = (HBITMAP) SelectObject(mTempDC, bitmap);
	#endif
	mWidth = width;
	mHeight = height;
}

void DexGL::clear()
{
	#ifdef OGL_ONLY
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	#else
		BitBlt(mTempDC, 0, 0, mWidth, mHeight, NULL, 0, 0, BLACKNESS);
	#endif
}

void DexGL::paint()
{
	#ifdef OGL_ONLY
		glFlush();
		SwapBuffers(hDC);
	#else
		BitBlt(hDC, 0, 0, mWidth, mHeight, mTempDC, 0, 0, SRCCOPY);
	#endif
}

void DexGL::saveImage(void *data, bool depth, float scale, float bias)
{
	#ifdef OGL_ONLY
		if (!depth)
			glReadPixels(0, 0, mWidth, mHeight, GL_RGBA, GL_UNSIGNED_BYTE, data);
		else
		{
			glPixelTransferf(GL_DEPTH_SCALE, scale);
			glPixelTransferf(GL_DEPTH_BIAS, bias);
			glReadPixels(0, 0, mWidth, mHeight, GL_DEPTH_COMPONENT, GL_FLOAT, data);
		}
	#endif
}

//=============================================================================

long DexGL::funcListGen(
	long vertCnt, long faceCnt, long *face,
	float *vertex, float *color, float *normal, float *anchor
	)
{
	#ifdef OGL_CVA
		unsigned int vbo[4];
		if (glBindBufferARB)
		{
			glGenBuffersARB(1, &vbo[0]);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[0]);
			glBufferDataARB(
				GL_ARRAY_BUFFER_ARB,
				vertCnt * (sizeof(float) * 3), vertex, GL_STATIC_DRAW_ARB
				);
			glGenBuffersARB(1, &vbo[1]);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[1]);
			glBufferDataARB(
				GL_ARRAY_BUFFER_ARB,
				vertCnt * (sizeof(float) * 3), color, GL_STATIC_DRAW_ARB
				);
			glGenBuffersARB(1, &vbo[2]);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[2]);
			glBufferDataARB(
				GL_ARRAY_BUFFER_ARB,
				vertCnt * (sizeof(float) * 3), normal, GL_STATIC_DRAW_ARB
				);
			glGenBuffersARB(1, &vbo[3]);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[3]);
			glBufferDataARB(
				GL_ARRAY_BUFFER_ARB,
				vertCnt * (sizeof(float) * 2), anchor, GL_STATIC_DRAW_ARB
				);
		}
		long result = glGenLists(2);
		glNewList(result, GL_COMPILE);
		//=========================================================
		if (glBindBufferARB)
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[0]);
			glVertexPointer(3, GL_FLOAT, 0, NULL);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[1]);
			glVertexPointer(3, GL_FLOAT, 0, NULL);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[2]);
			glVertexPointer(3, GL_FLOAT, 0, NULL);
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo[3]);
			glTexCoordPointer(2, GL_FLOAT, 0, NULL);
		}
		else
		{
			glVertexPointer(3, GL_FLOAT, 0, vertex);
			glColorPointer(3, GL_FLOAT, 0, color);
			glNormalPointer(GL_FLOAT, 0, normal);
			glTexCoordPointer(2, GL_FLOAT, 0, anchor);
		}
		//=========================================================
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		glEnableClientState(GL_NORMAL_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		if (glLockArraysEXT)
		{
			glLockArraysEXT(0, faceCnt * 3);
			glDrawElements(GL_TRIANGLES, faceCnt * 3, GL_UNSIGNED_INT, face);
			glUnlockArraysEXT();
		}
		else
			glDrawElements(GL_TRIANGLES, faceCnt * 3, GL_UNSIGNED_INT, face);
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_NORMAL_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		//=========================================================
		glEndList();
		glNewList(result + 1, GL_COMPILE);
		//=========================================================
		if (glBindBufferARB)
		{
			glDeleteBuffersARB(1, &vbo[0]);
			glDeleteBuffersARB(1, &vbo[1]);
			glDeleteBuffersARB(1, &vbo[2]);
			glDeleteBuffersARB(1, &vbo[3]);
		}
		//=========================================================
		glEndList();
		return result;
	#endif
	return 0;
}

void DexGL::funcListKill(long id)
{
	#ifdef OGL_CVA
		glCallList(id);
		glDeleteLists(id, 2);
	#endif
}

//=============================================================================

long DexGL::funcTexGen(long *data, int width, int height, bool mipmap)
{
	#ifdef OGL_CVA
		unsigned int result;
		glGenTextures(1, &result);
		glBindTexture(GL_TEXTURE_2D, result);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		if (mipmap)
		{
			glTexParameteri(
				GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR
				);
			gluBuild2DMipmaps(
				GL_TEXTURE_2D, 4,
				width, height,
				GL_RGBA, GL_UNSIGNED_BYTE, data
			);
		}
		else
		{
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexImage2D(
				GL_TEXTURE_2D, 0, 4,
				width, height, 0,
				GL_RGBA, GL_UNSIGNED_BYTE, data
			);
		}
		return result;
	#endif
	return 0;
}

void DexGL::funcTexKill(long id)
{
	#ifdef OGL_CVA
		unsigned int result = id;
		glDeleteTextures(1, &result);
	#endif
}

void DexGL::funcTexBind(long id)
{
	#ifdef OGL_CVA
		unsigned int result = id;
		glBindTexture(GL_TEXTURE_2D, result);
	#endif
}

//=============================================================================

long DexGL::funcFontGen(
	char *name, int size, bool bold, bool italic, bool underline, bool strikeOut
	)
{
	#ifdef OGL_CVA
		long result = glGenLists(CHAR_COUNT);
		HDC hDC = GetDC(hWnd);
		HFONT font = CreateFont(
			-1 * size,
			0, 0, 0,
			bold ? FW_BOLD : FW_NORMAL,
			italic, underline, strikeOut,
			ANSI_CHARSET,
			OUT_TT_PRECIS,
			CLIP_DEFAULT_PRECIS,
			ANTIALIASED_QUALITY,
			FF_DONTCARE | DEFAULT_PITCH,
			name
			);
		//=========================================================
		HFONT prevFont = (HFONT) SelectObject(hDC, font);
		wglUseFontBitmaps(hDC, CHAR_START, CHAR_COUNT, result);
		SelectObject(hDC, prevFont);
		//=========================================================
		DeleteObject(font);
		ReleaseDC(hWnd, hDC);
		return result;
	#endif
	return 0;
}

void DexGL::funcFontKill(long id)
{
	#ifdef OGL_CVA
		glDeleteLists(id, CHAR_COUNT);
	#endif
}

void DexGL::funcFontPrint(long id, char *text, float x, float y, float z, long color)
{
	#ifdef OGL_CVA
		glPushAttrib(GL_LIST_BIT | GL_ENABLE_BIT);
		glDisable(GL_TEXTURE_2D);
		glDisable(GL_LIGHTING);
		glRasterPos3f(x, y, z);
		glColor4ub(getR(color), getG(color), getB(color), getA(color));
		glListBase(id - CHAR_START);
		glCallLists(strlen(text), GL_UNSIGNED_BYTE, text);
		glPopAttrib();
	#endif
}

//=============================================================================

void DexGL::funcView(float *trans, float pNear, float pFar, float halfTan)
{
	#ifdef OGL_ONLY
		if (trans)
		{
			glMatrixMode(GL_PROJECTION);
			glLoadIdentity();
			glFrustum(-halfTan, halfTan, -halfTan, halfTan, pNear, pFar);
			glMatrixMode(GL_MODELVIEW);
			glLoadMatrixf(trans);
			glEnable(GL_DEPTH_TEST);
			glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		}
		else
		{
			glMatrixMode(GL_PROJECTION);
			glLoadIdentity();
			glOrtho(0, 1, 0, 1, -1, 1);
			glMatrixMode(GL_MODELVIEW);
			glLoadIdentity();
			glDisable(GL_DEPTH_TEST);
			glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
		}
	#endif
}

void DexGL::funcModel(float *trans, long id)
{
	#ifdef OGL_CVA
		glPushMatrix();
		glLoadMatrixf(trans);
		glCallList(id);
		glPopMatrix();
	#endif
}

//=============================================================================

void DexGL::funcLight(long index, float **attrib)
{
	#ifdef OGL_CVA
		long id = GL_LIGHT0 + index;
		if (attrib)
		{
			glEnable(GL_LIGHTING);
			glEnable(id);
			glLightfv(id, GL_AMBIENT, attrib[0]);
			glLightfv(id, GL_DIFFUSE, attrib[1]);
			glLightfv(id, GL_SPECULAR, attrib[2]);
			glLightfv(id, GL_POSITION, attrib[3]);
		}
		else
		{
			glDisable(GL_LIGHTING);
			glDisable(id);
		}
	#endif
}

void DexGL::funcBrush(float **attrib, float shininess)
{
	#ifdef OGL_CVA
		glMaterialfv(GL_FRONT, GL_AMBIENT, attrib[0]);
		glMaterialfv(GL_FRONT, GL_DIFFUSE, attrib[1]);
		glMaterialfv(GL_FRONT, GL_SPECULAR, attrib[2]);
		glMaterialfv(GL_FRONT, GL_EMISSION, attrib[3]);
		glMaterialf(GL_FRONT, GL_SHININESS, shininess);
	#endif
}

void DexGL::funcBlend(BLEND_OP::BLEND_OP blendOp, float alpha)
{
	#ifdef OGL_ONLY
		switch (blendOp)
		{
			case BLEND_OP::NONE:
				glDisable(GL_BLEND);
				glDepthMask(GL_TRUE);
				break;
			case BLEND_OP::ALPHA_TEX_MASK:
			case BLEND_OP::ALPHA_TEX_GLOW:
			case BLEND_OP::ALPHA_SET:
				glEnable(GL_BLEND);
				glDepthMask(GL_FALSE);
		}
		switch (blendOp)
		{
			case BLEND_OP::ALPHA_TEX_MASK:
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
				break;
			case BLEND_OP::ALPHA_TEX_GLOW:
				glBlendFunc(GL_SRC_ALPHA, GL_ONE);
				break;
			case BLEND_OP::ALPHA_SET:
				if (glBlendColorEXT)
				{
					glBlendFunc(GL_CONSTANT_ALPHA, GL_ONE_MINUS_CONSTANT_ALPHA);
					glBlendColorEXT(0, 0, 0, alpha);
				}
				else
					glBlendFunc(GL_ONE, GL_ONE);
		}
	#endif
}

//=============================================================================

void DexGL::funcMode(DRAW_MODE::DRAW_MODE drawMode)
{
	mWire = (drawMode == DRAW_MODE::WIRE);
	#ifdef OGL_ONLY
		switch (drawMode)
		{
			case DRAW_MODE::WIRE:
				glPolygonMode(GL_FRONT, GL_LINE);
				break;
			case DRAW_MODE::SOLID:
			case DRAW_MODE::TEXTURED:
				glPolygonMode(GL_FRONT, GL_FILL);
		}
		switch (drawMode)
		{
			case DRAW_MODE::WIRE:
			case DRAW_MODE::SOLID:
				glDisable(GL_TEXTURE_2D);
				break;
			case DRAW_MODE::TEXTURED:
				glEnable(GL_TEXTURE_2D);
		}
	#endif
}

void DexGL::funcFog(long color, float density, float pNear, float pFar)
{
	#ifdef OGL_CVA
		if (density)
		{
			glEnable(GL_FOG);
			float temp[4], t = (float) 1 / 255;
			temp[0] = getR(color) * t;
			temp[1] = getG(color) * t;
			temp[2] = getB(color) * t;
			temp[3] = getA(color) * t;
			glFogfv(GL_FOG_COLOR, temp);
			glFogf(GL_FOG_DENSITY, density);
			glFogf(GL_FOG_START, pNear);
			glFogf(GL_FOG_END, pFar);
			glClearColor(temp[0], temp[1], temp[2], temp[3]);
		}
		else
			glDisable(GL_FOG);
	#endif
}

//=============================================================================

void DexGL::funcTri(
	long c1, long c2, long c3,
	float x1, float y1,
	float x2, float y2,
	float x3, float y3
	)
{
	if (mWire)
	{
		#ifdef OGL_FLAT
			glColor3ub(getR(c1), getG(c1), getB(c1));
			glBegin(GL_LINES);
				glVertex2f(x1, y1); glVertex2f(x2, y2);
				glVertex2f(x2, y2); glVertex2f(x3, y3);
				glVertex2f(x3, y3); glVertex2f(x1, y1);
			glEnd();
		#endif
		#ifdef GDI_FLAT
			mPoint[0].x = (long) (x1 * mWidth);
			mPoint[0].y = (long) ((1 - y1) * mHeight);
			mPoint[1].x = (long) (x2 * mWidth);
			mPoint[1].y = (long) ((1 - y2) * mHeight);
			mPoint[2].x = (long) (x3 * mWidth);
			mPoint[2].y = (long) ((1 - y3) * mHeight);
			HPEN pen = CreatePen(PS_SOLID, 1, c1);
			HPEN prevPen = (HPEN) SelectObject(mTempDC, pen);
			HBRUSH prevBrush =
				(HBRUSH) SelectObject(mTempDC, GetStockObject(NULL_BRUSH));
			Polygon(mTempDC, mPoint, 3);
			SelectObject(mTempDC, prevBrush);
			SelectObject(mTempDC, prevPen);
			DeleteObject(pen);
		#endif
	}
	else
	{
		#ifdef OGL_FLAT
			glColor3ub(getR(c1), getG(c1), getB(c1));
			glBegin(GL_TRIANGLES);
				glVertex2f(x1, y1);
				glVertex2f(x2, y2);
				glVertex2f(x3, y3);
			glEnd();
		#endif
		#ifdef OGL_GRAD
			glBegin(GL_TRIANGLES);
				glColor3ub(getR(c1), getG(c1), getB(c1));
				glVertex2f(x1, y1);
				glColor3ub(getR(c2), getG(c2), getB(c2));
				glVertex2f(x2, y2);
				glColor3ub(getR(c3), getG(c3), getB(c3));
				glVertex2f(x3, y3);
			glEnd();
		#endif
		#ifdef GDI_FLAT
			mPoint[0].x = (long) (x1 * mWidth);
			mPoint[0].y = (long) ((1 - y1) * mHeight);
			mPoint[1].x = (long) (x2 * mWidth);
			mPoint[1].y = (long) ((1 - y2) * mHeight);
			mPoint[2].x = (long) (x3 * mWidth);
			mPoint[2].y = (long) ((1 - y3) * mHeight);
			HBRUSH brush = CreateSolidBrush(c1);
			HBRUSH prevBrush = (HBRUSH) SelectObject(mTempDC, brush);
			Polygon(mTempDC, mPoint, 3);
			SelectObject(mTempDC, prevBrush);
			DeleteObject(brush);
		#endif
		#ifdef GDI_GRAD
			mVertex[0].x     = (long) (x1 * mWidth);
			mVertex[0].y     = (long) ((1 - y1) * mHeight);
			mVertex[0].Red   = ((short) getR(c1)) << 8;
			mVertex[0].Green = ((short) getG(c1)) << 8;
			mVertex[0].Blue  = ((short) getB(c1)) << 8;
			mVertex[1].x     = (long) (x2 * mWidth);
			mVertex[1].y     = (long) ((1 - y2) * mHeight);
			mVertex[1].Red   = ((short) getR(c2)) << 8;
			mVertex[1].Green = ((short) getG(c2)) << 8;
			mVertex[1].Blue  = ((short) getB(c2)) << 8;
			mVertex[2].x     = (long) (x3 * mWidth);
			mVertex[2].y     = (long) ((1 - y3) * mHeight);
			mVertex[2].Red   = ((short) getR(c3)) << 8;
			mVertex[2].Green = ((short) getG(c3)) << 8;
			mVertex[2].Blue  = ((short) getB(c3)) << 8;
			GradientFill(mTempDC, mVertex, 4, &mFace, 1, GRADIENT_FILL_TRIANGLE);
		#endif
	}
}