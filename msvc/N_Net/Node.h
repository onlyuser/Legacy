#ifndef H_NODE
#define H_NODE

#include <math.h> // exp()
#include <stdio.h> // sprintf()
#include "List.h"
#include "Weight.h"

const int MAX_PREV = 256;
const int MAX_NEXT = 256;

class Node
{
private:
	float mOffset;
	float mScale;
	bool mVisited;

	float sigmoid(float);
	float sigmoidPri(float);

public:
	int mIndex;
	bool mIsBias; // false
	bool mIsInput; // false
	bool mIsOutput; // false

	float mValue;
	float mTarget;
	float mError;

	float mX;
	float mY;

	List<Node *> *mPrevNode;
	List<Weight *> *mPrevWeight;
	List<Node *> *mNextNode;
	List<Weight *> *mNextWeight;

	Node();
	~Node();
	void config(float, float);
	void reset();
	void sumFactor();
	void sumError();
	void print(char *, int &);
};

#endif
