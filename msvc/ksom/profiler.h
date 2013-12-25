#ifndef H_PROFILER
#define H_PROFILER

#include "kmapex.h"

class Profiler
{
private:
	KMapEx *mMap;
	vector<float *> mTally;
	float *mData;
	int mRowSize;
	int mColSize;

	void normAtten(float *data, int rowSize, int colSize);
	void deriveEx(float *data, int rowSize, int colSize);
	void clear();

public:
	Profiler(KMapEx *map, float *data, int rowSize, int colSize);
	~Profiler();
	void load(int windowSize);
	void exec(int tallySize);
	int classify(float *data);
	float verify(int windowSize, int tallySize);
	void getGroupTally(int groupIndex, float *data, int tallySize);
};

#endif