#include "Node.h"

Node::Node()
{
	mPrevNode = new List<Node *>(MAX_PREV);
	mPrevWeight = new List<Weight *>(MAX_PREV);
	mNextNode = new List<Node *>(MAX_NEXT);
	mNextWeight = new List<Weight *>(MAX_NEXT);
	mIsBias = false;
	mIsInput = false;
	mIsOutput = false;
}

Node::~Node()
{
	delete mPrevNode;
	delete mPrevWeight;
	delete mNextNode;
	delete mNextWeight;
}

void Node::config(float offset, float scale)
{
	mOffset = offset;
	mScale = scale;
}

void Node::reset()
{
	mVisited = false;
}

float Node::sigmoid(float x)
{
	return 1 / (1 + (float) exp(-1 * (x - mOffset) / mScale));
}

float Node::sigmoidPri(float y)
{
	return y * (1 - y) / mScale;
}

void Node::sumFactor()
{
	int i;
	float sum;

	if (mVisited) return;
	mVisited = true;
	if (mPrevNode->mCount != 0)
	{
		sum = 0;
		for (i = 0; i < mPrevNode->mCount; i++)
		{
			/* do not calculate bias node influence */
			if (!mPrevNode->mItem[i]->mIsBias)
				mPrevNode->mItem[i]->sumFactor();
			sum +=
				mPrevNode->mItem[i]->mValue *
				mPrevWeight->mItem[i]->mValue;
		}
		mValue = sigmoid(sum);
	}
}

void Node::sumError()
{
	int i;
	float sum;

	if (mVisited) return;
	mVisited = true;
	if (mNextNode->mCount != 0)
	{
		sum = 0;
		for (i = 0; i < mNextNode->mCount; i++)
		{
			/* continue recursive chain reaction */
			mNextNode->mItem[i]->sumError();
			if (!mNextNode->mItem[i]->mIsBias)
			{
				sum +=
					mNextNode->mItem[i]->mError *
					mNextWeight->mItem[i]->mValue;
				mNextWeight->mItem[i]->mDelta =
					mValue * mNextNode->mItem[i]->mError;
			}
		}
	}
	else
		sum = mTarget - mValue;
	mError = sigmoidPri(mValue) * sum;
}

void Node::print(char *string, int &byte)
{
	if (mIsBias)
		byte += sprintf(&string[byte], "*");
	byte += sprintf(&string[byte], "n%d", mIndex);
	byte += sprintf(&string[byte], "[%.2f", mValue);
	if (mIsOutput)
		byte += sprintf(&string[byte], "::%.2f", mTarget);
	byte += sprintf(&string[byte], "]; (");
	byte += sprintf(&string[byte], "%.2f", mX);
	byte += sprintf(&string[byte], ",");
	byte += sprintf(&string[byte], "%.2f", mY);
	byte += sprintf(&string[byte], ")");
}
