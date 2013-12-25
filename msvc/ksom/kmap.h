#ifndef H_KMAP
#define H_KMAP

#include <vector>
#include <set>
#include "util.h"
#include "knode.h"
#include "vbcall.h"

using namespace std;

class KMap
{
private:
	vector<float *> mInput;
	vector<float *> mKernel;
	vector<KNode *> mGroups;
	int mGroupCnt;
	int mDimCnt;
	float mMin;
	float mMax;
	float mMaxRadius;

	void initGroups();
	void initGroups(float min, float max);
	void initGroups(vector<float *> &kernel);
	void setLocalRadius(float radius);
	void focus();

public:
	KMap(int groupCnt, int dimCnt, float min, float max);
	~KMap();
	void setInput(vector<float *> &input);
	void setKernel(vector<float *> &kernel);
	void reset();
	int findNearestGroup(float *data);
	void simplify(float nearThresh);
	void exec();
	float exec(bool init, bool train, bool eval);
	void exec(int iters, int maxEpochs, float maxEntropy);
	float getMaxError(vector<float *> &input);
	int getDimCnt();
	int getGroupCnt();
	int getGroupSize(int index);
	int getGroupMember(int groupIndex, int index);
	void getGroupKernel(int groupIndex, float *data);
	string getGroupInfo(int groupIndex);
	float getGroupError(int groupIndex);
	float getGroupMemberError(int groupIndex, int index);
	void clear();
	int size();
	string print();
};

#endif