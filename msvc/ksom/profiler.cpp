#include "Profiler.h"

Profiler::Profiler(KMapEx *map, float *data, int rowSize, int colSize)
{
	mMap = map;
	mData = data;
	mRowSize = rowSize;
	mColSize = colSize;
}

Profiler::~Profiler()
{
	clear();
}

void Profiler::load(int windowSize)
{
	int i;
	int length;
	int newWinSize;
	int newStepSize;
	float *buffer;

	length = mRowSize * mColSize;
	buffer = new float[length];
	for (i = 0; i < length; i++)
		buffer[i] = mData[i];
	normAtten(buffer, mRowSize, mColSize);
	newWinSize = mRowSize * windowSize;
	newStepSize = mRowSize;
	mMap->load(buffer, length, newWinSize, newStepSize, false);
	delete []buffer;
}

void Profiler::normAtten(float *data, int rowSize, int colSize)
{
	int i;
	int j;
	float *buffer;

	buffer = new float[colSize];
	for (i = 0; i < rowSize; i++)
	{
		for (j = 0; j < colSize; j++)
			buffer[j] = data[j * rowSize + i];
		norm(buffer, colSize); /* FIX-ME: needs extreme-value dampening */
		for (j = 0; j < colSize; j++)
			data[j * rowSize + i] = buffer[j];
	}
	delete []buffer;
}

void Profiler::deriveEx(float *data, int rowSize, int colSize)
{
	int i;
	int j;
	float *buffer;

	buffer = new float[colSize];
	for (i = 0; i < rowSize; i++)
	{
		for (j = 0; j < colSize; j++)
			buffer[j] = data[j * rowSize + i];
		derive(buffer, colSize);
		for (j = 0; j < colSize; j++)
			data[j * rowSize + i] = buffer[j];
	}
	delete []buffer;
}

void Profiler::exec(int tallySize)
{
	int i;
	int j;
	int k;
	int length;
	int newWinSize;
	int newTallySize;
	int newStepSize;
	int groupCnt;
	int groupSize;
	float *buffer;
	float *window;
	int startIndex;
	int count;

	length = mRowSize * mColSize;
	//=====================================================
	buffer = new float[length];
	for (i = 0; i < length; i++)
		buffer[i] = mData[i];
	deriveEx(buffer, mRowSize, mColSize);
	//=====================================================
	newWinSize = mMap->getDimCnt();
	newTallySize = mRowSize * tallySize;
	newStepSize = mRowSize;
	//=====================================================
	clear();
	groupCnt = mMap->getGroupCnt();
	for (i = 0; i < groupCnt; i++)
	{
		window = new float[newTallySize];
		for (j = 0; j < newTallySize; j++)
			window[j] = 0;
		groupSize = mMap->getGroupSize(i);
		if (groupSize != 0)
		{
			count = 0;
			for (j = 0; j < groupSize; j++)
			{
				startIndex = mMap->getGroupMember(i, j) * newStepSize;
				if (startIndex + newWinSize + (newTallySize - 1) < length)
				{
					for (k = 0; k < newTallySize; k++)
						window[k] += buffer[startIndex + newWinSize + k];
					count++;
				}
			}
			if (count != 0)
				for (j = 0; j < newTallySize; j++)
					window[j] /= count;
		}
		mTally.push_back(window);
	}
}

int Profiler::classify(float *data)
{
	return mMap->findNearestGroup(data);
}

float Profiler::verify(int windowSize, int tallySize)
{
	int i;
	int j;
	float result;
	int length;
	int newWinSize;
	int newTallySize;
	int newStepSize;
	float *buffer;
	float *buffer2;
	float *window;
	float *window2;
	int count;
	int index;

	length = mRowSize * mColSize;
	//=====================================================
	buffer = new float[length];
	for (i = 0; i < length; i++)
		buffer[i] = mData[i];
	normAtten(buffer, mRowSize, mColSize);
	buffer2 = new float[length];
	for (i = 0; i < length; i++)
		buffer2[i] = mData[i];
	deriveEx(buffer2, mRowSize, mColSize);
	//=====================================================
	newWinSize = mMap->getDimCnt();
	newTallySize = mRowSize * tallySize;
	newStepSize = mRowSize;
	//=====================================================
	window = new float[newWinSize];
	window2 = new float[newTallySize];
	result = 0;
	count = 0;
	for (i = 0; i + (newWinSize - 1) < length; i += newStepSize)
	{
		for (j = 0; j < newWinSize; j++)
			window[j] = buffer[i + j];
		normEx(window, mRowSize, windowSize, 1);
		index = classify(window);
		if (mMap->getGroupSize(index) != 0)
		{
			getGroupTally(index, window2, tallySize);
			if (sgn(avg(&buffer2[i + newWinSize], tallySize)) == sgn(avg(window2, tallySize)))
				result++;
			count++;
		}
	}
	if (count != 0)
		result /= count;
	delete []buffer;
	delete []buffer2;
	delete []window;
	delete []window2;
	return result;
}

void Profiler::getGroupTally(int groupIndex, float *data, int tallySize)
{
	int i;
	int newTallySize;

	newTallySize = mRowSize * tallySize;
	for (i = 0; i < newTallySize; i++)
		data[i] = mTally[groupIndex][i];
}

void Profiler::clear()
{
	int i;

	for (i = 0; i < mTally.size(); i++)
		delete []mTally[i];
	mTally.clear();
}