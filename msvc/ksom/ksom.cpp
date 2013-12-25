#include "kmapex.h"

KMapEx::KMapEx(int groupCnt, int dimCnt) : KMap(groupCnt, dimCnt)
{
}

KMapEx::~KMapEx()
{
	resetCascade();
}

void KMapEx::load(string data)
{
	long i;
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
}

void KMapEx::load(float *data, int length)
{
	int i;

	mBuffer.clear();
	for (i = 0; i < length; i++)
		mBuffer.push_back(data[i]);
}

void KMapEx::cascade(int windowSize, int stepSize)
{
	int i;
	int j;
	float *temp;

	resetCascade();
	for (i = 0; i + (windowSize - 1) < mBuffer.size(); i += stepSize)
	{
		temp = new float[windowSize];
		for (j = 0; j < windowSize; j++)
			temp[j] = mBuffer[i + j];
		mCascade.push_back(temp);
	}
}

void KMapEx::resetCascade()
{
	int i;

	for (i = 0; i < mCascade.size(); i++)
		delete []mCascade[i];
	mCascade.clear();
}

void KMapEx::exec(int iters, int maxEpochs, float maxEntropy)
{
	setInput(mCascade);
	KMap::exec(iters, maxEpochs, maxEntropy);
}

string KMapEx::print()
{
	return KMap::print();
}