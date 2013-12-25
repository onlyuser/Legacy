#ifndef H_KMAPEX
#define H_KMAPEX

#include <vector>
#include "kmap.h"
#include "string.h"

class KMapEx : public KMap
{
private:
	vector<float> mBuffer;
	vector<float *> mCascade;

	void cascade(int windowSize, int stepSize);
	void resetCascade();

public:
	KMapEx(int groupCnt, int dimCnt, float min, float max);
	~KMapEx();
	void load(string data, int windowSize, int stepSize, bool kernel);
	void load(float *data, int length, int windowSize, int stepSize, bool kernel);
};

#endif