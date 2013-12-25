#include "knode.h"

KNode::KNode(int dimCnt, float radius)
{
	mWeights = new float[dimCnt];
	mDimCnt = dimCnt;
	mRadius = radius;
}

KNode::~KNode()
{
	delete []mWeights;
}

void KNode::merge(KNode *node, vector<float *> &input)
{
	int i;

	for (i = 0; i < node->size(); i++)
		addMember(node->getMembers()[i], input);
	node->resetMembership();
	focus(input);
}

void KNode::initWeights(set<int> &extrema, vector<float *> &input)
{
	int i;
	set<int>::iterator j;
	int k;
	float *ratios;
	float sum;

	// generate random normalized ratios
	ratios = new float[extrema.size()];
	sum = 0;
	for (i = 0; i < extrema.size(); i++)
	{
		ratios[i] = rand();
		sum += ratios[i];
	}
	for (i = 0; i < extrema.size(); i++)
		ratios[i] /= sum;

	// interpolate weights between extremas
	for (i = 0; i < mDimCnt; i++)
	{
		mWeights[i] = 0;
		k = 0;
		for (j = extrema.begin(); j != extrema.end(); j++)
		{
			mWeights[i] += input[*j][i] * ratios[k];
			k++;
		}
	}

	delete []ratios;
}

void KNode::initWeights(float min, float max)
{
	int i;

	for (i = 0; i < mDimCnt; i++)
		mWeights[i] = randEx(min, max);
}

void KNode::initWeights(float *weights)
{
	int i;

	for (i = 0; i < mDimCnt; i++)
		mWeights[i] = weights[i];
}

void KNode::setRadius(float radius)
{
	mRadius = radius;
}

void KNode::updateWeights(float *data)
{
	int i;
	float temp;
	float temp2;
	float temp3;
	float ratio;

	temp = distance(data);
	temp2 = mRadius;
	temp3 = exp(-temp / temp2);
	ratio = (float) 1 / (mMembers.size() + 1) * temp3;
	for (i = 0; i < mDimCnt; i++)
		mWeights[i] = mWeights[i] * (1 - ratio) + data[i] * ratio;
}

void KNode::addMember(int index, vector<float *> &input)
{
	updateWeights(input[index]);
	mMembers.push_back(index);
	mError = getMaxError(input);
}

void KNode::resetMembership()
{
	mMembers.clear();
	mError = 0;
}

void KNode::focus(vector<float *> &input)
{
	int i;
	int j;
	int index;

	if (mMembers.size() != 0)
	{
		for (i = 0; i < mDimCnt; i++)
			mWeights[i] = 0;
		for (i = 0; i < mMembers.size(); i++)
		{
			index = mMembers[i];
			for (j = 0; j < mDimCnt; j++)
				mWeights[j] += input[index][j];
		}
		for (i = 0; i < mDimCnt; i++)
			mWeights[i] /= mMembers.size();
		mError = getMaxError(input);
	}
}

float KNode::distance(float *data)
{
	float result;

	result = dist(data, mWeights, mDimCnt);
	if (result < SMALL_NUMBER)
		result = 0;
	return result;
}

float KNode::distance(KNode *node)
{
	return distance(node->getKernel());
}

float KNode::distance(int memberIndex, vector<float *> &input)
{
	int index;

	index = mMembers[memberIndex];
	return distance(input[index]);
}

float KNode::getMaxError(vector<float *> &input)
{
	int i;
	float result;
	int index;

	result = 0;
	for (i = 0; i < mMembers.size(); i++)
	{
		index = mMembers[i];
		result = max2(result, distance(input[index]));
	}
	return result;
}

int KNode::size()
{
	return mMembers.size();
}

vector<int> KNode::getMembers()
{
	return mMembers;
}

float *KNode::getKernel()
{
	return mWeights;
}

string KNode::print()
{
	int i;
	int j;
	string result;

	if (mDimCnt < MID_THRESH)
	{
		for (i = 0; i < mDimCnt; i++)
			result += cstr(mWeights[i]) + ", ";
	}
	else
		result += "[dim=" + cstr(mDimCnt) + "], ";
	result = left(result, result.length() - 2);
	result = "(" + result + "), (ERR=" + cstr((float) sqrt(mError)) + "), ";
	if (mMembers.size() < LO_THRESH)
	{
		for (j = 0; j < mMembers.size(); j++)
			result += cstr((int) mMembers[j]) + ", ";
	}
	else
		result += "[size=" + cstr((int) mMembers.size()) + "], ";
	result = left(result, result.length() - 2);
	return result;
}