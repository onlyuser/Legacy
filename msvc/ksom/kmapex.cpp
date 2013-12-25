#include "kmapex.h"

KMapEx::KMapEx(int groupCnt, int dimCnt, float min, float max) : KMap(groupCnt, dimCnt, min, max)
{
}

KMapEx::~KMapEx()
{
	resetCascade();
}

void KMapEx::load(string data, int windowSize, int stepSize, bool kernel)
{
	int i;
	string newData;
	string token;

	newData = editDespace(data);
	mBuffer.clear();
	i = 0;
	while (i < newData.length())
	{
		token = scanText(newData, i, ",");
		token = trim(token);
		mBuffer.push_back(val(token));
	}
	cascade(windowSize, stepSize);
	if (!kernel)
		setInput(mCascade);
	else
		setKernel(mCascade);
}

void KMapEx::load(float *data, int length, int windowSize, int stepSize, bool kernel)
{
	int i;

	mBuffer.clear();
	for (i = 0; i < length; i++)
		mBuffer.push_back(data[i]);
	cascade(windowSize, stepSize);
	if (!kernel)
		setInput(mCascade);
	else
		setKernel(mCascade);
}

void KMapEx::cascade(int windowSize, int stepSize)
{
	int i;
	int j;
	float *window;
	int rowSize;
	int colSize;

	if (stepSize != 1)
	{
		rowSize = stepSize;
		colSize = windowSize / stepSize;
	}
	resetCascade();
	for (i = 0; i + (windowSize - 1) < mBuffer.size(); i += stepSize)
	{
		window = new float[windowSize];
		for (j = 0; j < windowSize; j++)
			window[j] = mBuffer[i + j];
		//saveArray("c:\\test\\input" + cstr(i) + ".txt", window, windowSize);
		if (stepSize < windowSize)
			if (stepSize == 1)
				normEx(window, windowSize, 1, 0);
			else
				normEx(window, rowSize, colSize, 1);
		//saveArray("c:\\test\\input" + cstr(i) + "b.txt", window, windowSize);
		mCascade.push_back(window);
		if (stepSize == 0)
			break; /* kernel */
	}
}

void KMapEx::resetCascade()
{
	int i;

	for (i = 0; i < mCascade.size(); i++)
		delete []mCascade[i];
	mCascade.clear();
}