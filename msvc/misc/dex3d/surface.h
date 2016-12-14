#ifndef H_SURFACE
#define H_SURFACE

#include "misc.h"

typedef (VB_CALL *PRINT_FUNC)(long, long, long, long, long);
typedef (VB_CALL *TRI_FUNC)(long, long, long, long, long, long, long);
typedef (VB_CALL *GRAD_FUNC)(long, long, long, long, long, long, long, long, long);
typedef (VB_CALL *PIX_FUNC)(long, long, long);

class surface
{
private:
	VB_FUNC mEventFunc;
	VB_FUNC mClearFunc;
	PRINT_FUNC mPrintFunc;
	TRI_FUNC mTriFunc;
	GRAD_FUNC mGradFunc;
	PIX_FUNC mPixFunc;

public:
	long mWidth;
	long mHeight;

	surface();
	~surface();
	void regUserFunc(VB_FUNC, VB_FUNC, PRINT_FUNC, TRI_FUNC, GRAD_FUNC, PIX_FUNC);
	void setSize(long, long);
	void refresh();
	void clearScreen();
	void printText(char *, long, long, long);
	void drawTriangle(long, long, long, long, long, long, long);
	void drawGradient(long, long, long, long, long, long, long, long, long);
	void drawPixel(long, long, long);
};

#endif
