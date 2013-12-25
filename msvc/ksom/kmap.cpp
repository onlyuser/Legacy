#include "kmap.h"

KMap::KMap(int groupCnt, int dimCnt, float min, float max)
{
	mGroupCnt = groupCnt;
	mDimCnt = dimCnt;
	mMin = min;
	mMax = max;
}

KMap::~KMap()
{
	clear();
}

void KMap::setInput(vector<float *> &input)
{
	mInput = input;
}

void KMap::setKernel(vector<float *> &kernel)
{
	mKernel = kernel;
}

void KMap::reset()
{
	mInput.clear();
	mKernel.clear();
}

void KMap::initGroups()
{
	int i;
	int j;
	float curDist;
	float bestDist;
	set<int> extrema;
	bool changed;
	int indexA;
	int indexB;

	// locate input space extremas
	mMaxRadius = -1;
	do
	{
		// find two inputs with the farthest euclidean distance
		bestDist = 0;
		changed = false;
		for (i = 0; i < mInput.size(); i++)
			for (j = 0; j < mInput.size(); j++)
				if (i != j && extrema.find(j) == extrema.end())
				{
					curDist = dist(mInput[i], mInput[j], mDimCnt);
					if (curDist >= bestDist)
					{
						bestDist = curDist;
						indexA = i;
						indexB = j;
						changed = true;
					}
				}
		if (changed)
		{
			if (mMaxRadius == -1)
				mMaxRadius = bestDist / 4;
			extrema.insert(indexA);
			extrema.insert(indexB);
		}
	} while (changed);

	// create groups
	clear();
	mGroups.reserve(mGroupCnt);
	for (i = 0; i < mGroupCnt; i++)
		mGroups.push_back(new KNode(mDimCnt, mMaxRadius));

	// initialize group weights
	for (i = 0; i < mGroups.size(); i++)
		((KNode *) mGroups[i])->initWeights(extrema, mInput);
}

void KMap::initGroups(float min, float max)
{
	int i;

	// assume maximum error
	mMaxRadius = pow(max - min, 2) * mDimCnt / 4;

	// create groups
	clear();
	mGroups.reserve(mGroupCnt);
	for (i = 0; i < mGroupCnt; i++)
		mGroups.push_back(new KNode(mDimCnt, mMaxRadius));

	// initialize group weights
	for (i = 0; i < mGroups.size(); i++)
		((KNode *) mGroups[i])->initWeights(min, max);
}

void KMap::initGroups(vector<float *> &kernel)
{
	int i;
	int j;
	float curDist;
	float bestDist;

	// find two kernels with the farthest euclidean distance
	bestDist = 0;
	for (i = 0; i < kernel.size(); i++)
		for (j = 0; j < kernel.size(); j++)
			if (i != j)
			{
				curDist = dist(kernel[i], kernel[j], mDimCnt);
				if (curDist >= bestDist)
					bestDist = curDist;
			}
	mMaxRadius = bestDist / 4;

	// create groups
	clear();
	mGroups.reserve(mGroupCnt);
	for (i = 0; i < mGroupCnt; i++)
		mGroups.push_back(new KNode(mDimCnt, mMaxRadius));

	// initialize group kernel
	for (i = 0; i < mGroups.size(); i++)
		((KNode *) mGroups[i])->initWeights(kernel[i]);
}

int KMap::findNearestGroup(float *data)
{
	int i;
	int result;
	float curDist;
	float bestDist;
	float worstDist;

	bestDist = -1;
	worstDist = -1;
	for (i = 0; i < mGroups.size(); i++)
	{
		//saveArray("c:\\test\\kernel" + cstr(i) + ".txt", ((KNode *) mGroups[i])->getKernel(), mDimCnt);
		curDist = ((KNode *) mGroups[i])->distance(data);
		if (curDist < bestDist || bestDist == -1)
		{
			bestDist = curDist;
			result = i;
		}
		if (curDist > worstDist || worstDist == -1)
			worstDist = curDist;
	}
	return result;
}

void KMap::setLocalRadius(float radius)
{
	int i;

	for (i = 0; i < mGroups.size(); i++)
		((KNode *) mGroups[i])->setRadius(radius);
}

void KMap::focus()
{
	int i;

	for (i = 0; i < mGroups.size(); i++)
		((KNode *) mGroups[i])->focus(mInput);
}

void KMap::simplify(float nearThresh)
{
	int i;
	int j;

	for (i = 0; i < mGroups.size(); i++)
		for (j = 0; j < mGroups.size(); j++)
			if (
				i != j &&
				((KNode *) mGroups[i])->size() != 0 &&
				((KNode *) mGroups[j])->size() != 0 &&
				((KNode *) mGroups[i])->distance((KNode *) mGroups[j]) <= mMaxRadius * 4 * pow(nearThresh, 2)
				)
				((KNode *) mGroups[i])->merge((KNode *) mGroups[j], mInput);
}

void KMap::exec()
{
	exec(false, false, false);
}

float KMap::exec(bool init, bool train, bool eval)
{
	int i;
	float result;
	int index;

	result = 0;
	if (init)
		if (mKernel.size() != 0)
			initGroups(mKernel);
		else
			if (mMax - mMin != 0)
				initGroups(mMin, mMax);
			else
				initGroups();
	if (train)
	{
		for (i = 0; i < mGroups.size(); i++)
			((KNode *) mGroups[i])->resetMembership();
		for (i = 0; i < mInput.size(); i++)
		{
			//saveArray("c:\\test\\input" + cstr(i) + ".txt", mInput[i], mDimCnt);
			index = findNearestGroup(mInput[i]);
			((KNode *) mGroups[index])->addMember(i, mInput);
			if (mInput.size() > HI_THRESH)
				output("state: processing.. " + cstr((int) ((float) i / mInput.size() * 100)) + "%");
		}
		//focus();
		if (mInput.size() > HI_THRESH)
			output("state: done!");
	}
	if (eval)
		if (size() != 0)
			result = getMaxError(mInput);
		else
			result = mMaxRadius;
	return result;
}

void KMap::exec(int iters, int maxEpochs, float maxEntropy)
{
	int i;
	float maxError;
	int count;

	maxError = exec(true, false, true) * (float) pow(maxEntropy, 2);
	count = 0;
	do
	{
		for (i = 0; i < iters; i++)
		{
			exec(false, true, false);
			setLocalRadius(mMaxRadius * exp(-i / iters));
		}
		count++;
	} while (count < maxEpochs && getMaxError(mInput) > maxError);
}

float KMap::getMaxError(vector<float *> &input)
{
	int i;
	float result;

	result = 0;
	for (i = 0; i < mGroups.size(); i++)
		result = max2(result, ((KNode *) mGroups[i])->getMaxError(input));
	return result;
}

int KMap::getDimCnt()
{
	return mDimCnt;
}

int KMap::getGroupCnt()
{
	return mGroups.size();
}

int KMap::getGroupSize(int index)
{
	return ((KNode *) mGroups[index])->size();
}

int KMap::getGroupMember(int groupIndex, int index)
{
	return ((KNode *) mGroups[groupIndex])->getMembers()[index];
}

void KMap::getGroupKernel(int groupIndex, float *data)
{
	int i;
	float *weights;

	weights = ((KNode *) mGroups[groupIndex])->getKernel();
	for (i = 0; i < mDimCnt; i++)
		data[i] = weights[i];
}

string KMap::getGroupInfo(int groupIndex)
{
	return cstr(groupIndex) + ": " + ((KNode *) mGroups[groupIndex])->print();
}

float KMap::getGroupError(int groupIndex)
{
	return ((KNode *) mGroups[groupIndex])->getMaxError(mInput);
}

float KMap::getGroupMemberError(int groupIndex, int index)
{
	return ((KNode *) mGroups[groupIndex])->distance(index, mInput);
}

void KMap::clear()
{
	int i;

	for (i = 0; i < mGroups.size(); i++)
		delete mGroups[i];
	mGroups.clear();
}

int KMap::size()
{
	int i;
	int result;

	result = 0;
	for (i = 0; i < mGroups.size(); i++)
		result += getGroupSize(i);
	return result;
}

string KMap::print()
{
	int i;
	string result;

	for (i = 0; i < mGroups.size(); i++)
		if (getGroupSize(i) != 0)
			result += getGroupInfo(i) + "\n";
	return result;
}