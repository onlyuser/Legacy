#ifndef H_KNODE
#define H_KNODE

#include <vector>
#include <set>
#include "string.h"
#include "util.h"

using namespace std;

class KNode
{
private:
	float *mWeights;
	int mDimCnt;
	vector<int> mMembers;
	float mRadius;
	float mError;

	void updateWeights(float *data);

public:
	KNode(int dimCnt, float radius);
	~KNode();
	void merge(KNode *node, vector<float *> &input);
	void initWeights(set<int> &extrema, vector<float *> &input);
	void initWeights(float min, float max);
	void initWeights(float *weights);
	void setRadius(float radius);
	void addMember(int index, vector<float *> &input);
	void resetMembership();
	void focus(vector<float *> &input);
	float distance(float *data);
	float distance(KNode *node);
	float distance(int memberIndex, vector<float *> &input);
	float getMaxError(vector<float *> &input);
	int size();
	vector<int> getMembers();
	float *getKernel();
	string print();
};

#endif