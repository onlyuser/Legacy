#include "surface.h"

surface::surface()
{
}

surface::~surface()
{
}

void surface::regUserFunc(VB_FUNC eventFunc, VB_FUNC clearFunc, PRINT_FUNC printFunc, TRI_FUNC triFunc, GRAD_FUNC gradFunc, PIX_FUNC pixFunc)
{
	mEventFunc = eventFunc;
	mClearFunc = clearFunc;
	mPrintFunc = printFunc;
	mTriFunc = triFunc;
	mGradFunc = gradFunc;
	mPixFunc = pixFunc;
}

void surface::setSize(long width, long height)
{
	mWidth = width;
	mHeight = height;
}

void surface::refresh()
{
	mEventFunc();
}

void surface::clearScreen()
{
	mClearFunc();
}

void surface::printText(char *text, long x, long y, long color)
{
	int i;

	for (i = 0; text[i] != 0; i++);
	mPrintFunc((long) text, i + 1, x, y, color);
}

void surface::drawTriangle(long x1, long y1, long x2, long y2, long x3, long y3, long color)
{
	mTriFunc(x1, y1, x2, y2, x3, y3, color);
}

void surface::drawGradient(long x1, long y1, long x2, long y2, long x3, long y3, long c1, long c2, long c3)
{
	mGradFunc(x1, y1, x2, y2, x3, y3, c1, c2, c3);
}

void surface::drawPixel(long x, long y, long color)
{
	mPixFunc(x, y, color);
}
