#ifndef H_N_NET
#define H_N_NET

#include <stdio.h> // sprintf()
#include "List.h"
#include "Node.h"
#include "Weight.h"
#include "Shared.h" // VB_FUNC

const int MAX_NODE = 1024;
const int MAX_WEIGHT = 65536;
const int MAX_INPUT = 256;
const int MAX_OUTPUT = 256;

const float NET_OFFSET = 0;
const float NET_SCALE = 1;
const float NET_RATE = 1;
const float NET_ALPHA = 0;

class N_Net
{
private:
	VB_FUNC mEventFunc;

	List<Node *> *mNodeList;
	List<Weight *> *mWeightList;

	List<Node *> *mInputList;
	List<Node *> *mOutputList;

	float *mMinVector;
	float *mMaxVector;

	float mRate;
	float mAlpha;

	void calcCoords(int, int, int, int);
	void build(int, int, int, int);
	void alloc(int, int, int, int);
	void weave(int, int, int &, int &, bool);
	void connect(int, int, int);

	void propForward();
	void propBackward();
	void reset(bool);
	void applyDelta(float);
	float sumError();

	void normVector(float *, int, int, float &, float &, bool);
	void denormVector(float *, int, int, float, float);

	/* advanced */
	float applyMatrixEx(float *, int, int, bool, int);

public:
	N_Net(int, int, int, int);
	~N_Net();
	void config(float, float, float, float);
	void randomize();
	float run(bool);
	void setVector(float *);
	void getVector(float *);
	void print(char *);

	/* extra */
	void regEventFunc(VB_FUNC);
	int getWeightCount();
	void setWeight(int, float);
	float getWeight(int);

	/* basic */
	float applyMatrix(float *, int, bool, int);
	float extrapArray(float *, int, int, bool, int);
	float applyImage(float *, bool, int);

	/* advanced */
	float extrapMatrix(float *, int, int, int, int);
};

#endif
