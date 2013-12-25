#include "N_Net.h"

N_Net::N_Net(int input, int output, int hidden, int layer)
{
	mNodeList = new List<Node *>(MAX_NODE);
	mWeightList = new List<Weight *>(MAX_WEIGHT);
	mInputList = new List<Node *>(MAX_INPUT);
	mOutputList = new List<Node *>(MAX_OUTPUT);
	mMinVector = new float[input + output];
	mMaxVector = new float[input + output];
	build(input + 1, output, hidden + 1, layer);
	config(NET_OFFSET, NET_SCALE, NET_RATE, NET_ALPHA);
	mEventFunc = NULL;
}

N_Net::~N_Net()
{
	int i;

	for (i = 0; i < mNodeList->mCount; i++)
		delete mNodeList->mItem[i];
	for (i = 0; i < mWeightList->mCount; i++)
		delete mWeightList->mItem[i];
	delete mNodeList;
	delete mWeightList;
	delete mInputList;
	delete mOutputList;
	delete []mMinVector;
	delete []mMaxVector;
}

void N_Net::calcCoords(int input, int output, int hidden, int layer)
{
	int i;
	int width;
	int length;
	int index;

	length = (1 + layer + 1) + 1;
	width = hidden;
	if (input > width)
		width = input;
	if (output > width)
		width = output;
	width++;
	for (i = 0; i < mInputList->mCount; i++)
	{
		mInputList->mItem[i]->mX = (float) 1 / length;
		if (i != mInputList->mCount - 1)
			mInputList->mItem[i]->mY = (float) (1 + i) / width;
		else
			mInputList->mItem[i]->mY = (float) (width - 1) / width;
	}
	for (i = 0; i < mOutputList->mCount; i++)
	{
		mOutputList->mItem[i]->mX = (float) (1 + layer + 1) / length;
		mOutputList->mItem[i]->mY = (float) (1 + i) / width;
	}
	index = 0;
	for (i = 0; i < mNodeList->mCount; i++)
	{
		if (!mNodeList->mItem[i]->mIsInput && !mNodeList->mItem[i]->mIsOutput)
		{
			mNodeList->mItem[i]->mX =
				(float) (1 + (1 + (int) index / hidden)) / length;
			mNodeList->mItem[i]->mY = (float) (1 + (index % hidden)) / width;
			index++;
		}
	}
}

void N_Net::build(int input, int output, int hidden, int layer)
{
	int i;
	int nodeIndex;
	int weightIndex;
	int total;

	nodeIndex = 0;
	weightIndex = 0;
	alloc(input, output, hidden, layer);
	weave(input, hidden, nodeIndex, weightIndex, true);
	total = layer - 1;
	for (i = 0; i < total; i++)
		weave(hidden, hidden, nodeIndex, weightIndex, true);
	weave(hidden, output, nodeIndex, weightIndex, false);
	calcCoords(input, output, hidden, layer);
}

void N_Net::alloc(int input, int output, int hidden, int layer)
{
	int i;
	int total;

	total = input + hidden * layer + output;
	for (i = 0; i < total; i++)
	{
		mNodeList->add(new Node());
		mNodeList->mItem[i]->mIndex = i;
	}
	for (i = 0; i < input; i++)
	{
		mInputList->add(mNodeList->mItem[i]);
		mInputList->mItem[i]->mIsInput = true;
	}
	for (i = 0; i < output; i++)
	{
		mOutputList->add(mNodeList->mItem[total - output + i]);
		mOutputList->mItem[i]->mIsOutput = true;
	}
	/* extra weights required to link bias nodes */
	total =
		input * (hidden - 1) + 1 +
		(hidden * (hidden - 1) + 1) * (layer - 1) +
		hidden * output;
	for (i = 0; i < total; i++)
	{
		mWeightList->add(new Weight());
		mWeightList->mItem[i]->mIndex = i;
	}
}

void N_Net::weave(int colA, int colB, int &nodeIndex, int &weightIndex, bool hasBias)
{
	int i;
	int j;
	int baseA;
	int baseB;

	baseA = nodeIndex;
	baseB = baseA + colA;
	for (i = 0; i < colA; i++)
		for (j = 0; j < colB; j++)
			/* link bias nodes to enable recursion */
			if (i == colA - 1 || j != colB - 1 || !hasBias)
			{
				connect(baseA + i, baseB + j, weightIndex);
				weightIndex++;
			}
	mNodeList->mItem[baseA + colA - 1]->mIsBias = true;
	mNodeList->mItem[baseA + colA - 1]->mValue = 1;
	nodeIndex = baseB;
}

void N_Net::connect(int nodeIndexA, int nodeIndexB, int weightIndex)
{
	Node *nodeA;
	Node *nodeB;
	Weight *weight;

	nodeA = mNodeList->mItem[nodeIndexA];
	nodeB = mNodeList->mItem[nodeIndexB];
	weight = mWeightList->mItem[weightIndex];
	nodeA->mNextNode->add(nodeB);
	nodeB->mPrevNode->add(nodeA);
	nodeA->mNextWeight->add(weight);
	nodeB->mPrevWeight->add(weight);
}

void N_Net::config(float offset, float scale, float rate, float alpha)
{
	int i;

	for (i = 0; i < mNodeList->mCount; i++)
		mNodeList->mItem[i]->config(offset, scale);
	mRate = rate;
	mAlpha = alpha;
	randomize();
	/* initialize deltas */
	reset(true);
}

void N_Net::randomize()
{
	int i;

	for (i = 0; i < mWeightList->mCount; i++)
		mWeightList->mItem[i]->randomize();
}

float N_Net::run(bool train)
{
	propForward();
	if (train)
	{
		applyDelta(mAlpha);
		propBackward();
		applyDelta(1);
		return sumError();
	}
	return -1;
}

void N_Net::propForward()
{
	int i;

	reset(false);
	for (i = 0; i < mOutputList->mCount; i++)
		mOutputList->mItem[i]->sumFactor();
}

void N_Net::propBackward()
{
	int i;

	reset(false);
	for (i = 0; i < mInputList->mCount; i++)
		mInputList->mItem[i]->sumError();
}

void N_Net::reset(bool init)
{
	int i;

	if (!init)
		for (i = 0; i < mNodeList->mCount; i++)
			mNodeList->mItem[i]->reset();
	else
		for (i = 0; i < mWeightList->mCount; i++)
			mWeightList->mItem[i]->reset();
}

void N_Net::applyDelta(float alpha)
{
	int i;

	for (i = 0; i < mWeightList->mCount; i++)
		mWeightList->mItem[i]->mValue +=
			mRate * mWeightList->mItem[i]->mDelta * alpha;
}

float N_Net::sumError()
{
	int i;
	float error;

	error = 0;
	for (i = 0; i < mOutputList->mCount; i++)
		error += (float)
			fabs(
				mOutputList->mItem[i]->mTarget -
				mOutputList->mItem[i]->mValue
			);
	return error;
}

void N_Net::setVector(float *vector)
{
	int i;
	int input;
	int output;

	/* subtract bias node from inputs */
	input = mInputList->mCount - 1;
	output = mOutputList->mCount;
	for (i = 0; i < input; i++)
		mInputList->mItem[i]->mValue = vector[i];
	for (i = 0; i < output; i++)
		mOutputList->mItem[i]->mTarget = vector[input + i];
}

void N_Net::getVector(float *vector)
{
	int i;
	int input;
	int output;

	input = mInputList->mCount - 1;
	output = mOutputList->mCount;
	for (i = 0; i < output; i++)
		vector[input + i] = mOutputList->mItem[i]->mValue;
}

void N_Net::normVector(float *vector, int start, int end, float &min, float &max, bool newBounds)
{
	int i;
	float diff;

	if (newBounds)
	{
		min = vector[start];
		max = vector[start];
		for (i = start + 1; i <= end; i++)
		{
			if (vector[i] < min)
				min = vector[i];
			if (vector[i] > max)
				max = vector[i];
		}
	}
	diff = max - min;
	if (diff != 0)
		for (i = start; i <= end; i++)
			vector[i] = (vector[i] - min) / diff;
	else
		for (i = start; i <= end; i++)
			vector[i] = 0;
}

void N_Net::denormVector(float *vector, int start, int end, float min, float max)
{
	int i;
	float diff;

	diff = max - min;
	for (i = start; i <= end; i++)
		vector[i] = min + vector[i] * diff;
}

void N_Net::print(char *string)
{
	int i;
	int j;
	int b;
	Node *node;

	b = 0;

	b += sprintf(&string[b], "<input> ");
	mInputList->print(string, b);
	b += sprintf(&string[b], "\n");

	b += sprintf(&string[b], "<output> ");
	mOutputList->print(string, b);
	b += sprintf(&string[b], "\n");

	b += sprintf(&string[b], "<begin>\n");
	for (i = 0; i < mNodeList->mCount; i++)
	{
		node = mNodeList->mItem[i];
		node->print(string, b);
		b += sprintf(&string[b], "\n");
		for (j = 0; j < node->mPrevNode->mCount; j++)
		{
			b += sprintf(&string[b], "(");
			b += sprintf(&string[b], "n%d", node->mIndex);
			b += sprintf(&string[b], " <- ");
			b += sprintf(&string[b], "n%d", node->mPrevNode->mItem[j]->mIndex);
			b += sprintf(&string[b], "); ");
			node->mPrevWeight->mItem[j]->print(string, b);
			b += sprintf(&string[b], "\n");
		}
		for (j = 0; j < node->mNextNode->mCount; j++)
		{
			b += sprintf(&string[b], "(");
			b += sprintf(&string[b], "n%d", node->mIndex);
			b += sprintf(&string[b], " -> ");
			b += sprintf(&string[b], "n%d", node->mNextNode->mItem[j]->mIndex);
			b += sprintf(&string[b], "); ");
			node->mNextWeight->mItem[j]->print(string, b);
			b += sprintf(&string[b], "\n");
		}
	}
	b += sprintf(&string[b], "<end>\n");
}
