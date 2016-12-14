#include "Exports.h"

bool WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason) 
	{ 
		case DLL_PROCESS_ATTACH: dll_init(); break;
		case DLL_PROCESS_DETACH: dll_destroy();
	}
	return true;
}
void dll_init() {}
void dll_destroy() {}
void WINAPI DexKNN_regFuncUser(FUNC_EVENT funcEvent, FUNC_MSG funcMsg)
	{mFuncEvent = funcEvent; mFuncMsg = funcMsg;}
void WINAPI DexKNN_regFuncClip(FUNC_CLIP funcClip)
	{mFuncClip = funcClip;}
long WINAPI DexKNN_sum(long a, long b) {return a + b;}
char *WINAPI DexKNN_echo(char *text) {return text;}
void sendError(Exception<> &e)
{
	if (mFuncMsg)
		mFuncMsg((const char *) _bstr_t(_T(e.getData())).copy());
}
void WINAPI DexKNN_reset() {mDexKNN.reset();}
void WINAPI DexKNN_build(double *vecArr, int vecCnt)
{
	//=========================================================
	// bail conditions
	if (!vecArr || !vecCnt)
		return;
	//=========================================================
	// init input, run
	std::vector<Vector<> *> vecList;
	for (int i = 0; i < vecCnt; i++)
		vecList.push_back(new Vector<>(DIM_CNT, &vecArr[i * DIM_CNT]));
	mDexKNN.build(vecList);
	//=========================================================
	// clean up
	std::for_each(vecList.begin(), vecList.end(), std::kill());
	//=========================================================
}
int WINAPI DexKNN_find(double *v)
	{return mDexKNN.find(Vector<>(DIM_CNT, v));}
void WINAPI DexKNN_genMesh2D(
	int *r_edgeArr, int &r_edgeCnt,
	double *r_vVecArr, int &r_vVecCnt, int *r_vEdgeArr, int &r_vEdgeCnt,
	double *vecArr, int vecCnt
	)
{
	//=========================================================
	// bail conditions
	if (!vecArr || !vecCnt)
		return;
	//=========================================================
	// init input, run
	std::vector<std::pair<int, int> *> edgeList;
	std::vector<Vector<> *> vVecList;
	std::vector<std::pair<int, int> *> vEdgeList;
	std::vector<Vector<> *> vecList;
	for (int i = 0; i < vecCnt; i++)
		vecList.push_back(new Vector<>(DIM_CNT, &vecArr[i * DIM_CNT]));
	mDexKNN.genMesh2D(edgeList, vVecList, vEdgeList, vecList);
	//=========================================================
	// extract output
	if (r_edgeArr)
	{
		r_edgeCnt = edgeList.size();
		for (int j = 0; j < r_edgeCnt; j++)
		{
			r_edgeArr[j * 2 + 0] = edgeList[j]->first;
			r_edgeArr[j * 2 + 1] = edgeList[j]->second;
		}
	}
	if (r_vVecArr)
	{
		r_vVecCnt = vVecList.size();
		for (int k = 0; k < r_vVecCnt; k++)
			vVecList[k]->toArray(&r_vVecArr[k * DIM_CNT]);
	}
	if (r_vEdgeArr)
	{
		r_vEdgeCnt = vEdgeList.size();
		for (int n = 0; n < r_vEdgeCnt; n++)
		{
			r_vEdgeArr[n * 2 + 0] = vEdgeList[n]->first;
			r_vEdgeArr[n * 2 + 1] = vEdgeList[n]->second;
		}
	}
	//=========================================================
	// clean up
	std::for_each(edgeList.begin(), edgeList.end(), std::kill());
	std::for_each(vVecList.begin(), vVecList.end(), std::kill());
	std::for_each(vEdgeList.begin(), vEdgeList.end(), std::kill());
	std::for_each(vecList.begin(), vecList.end(), std::kill());
	//=========================================================
}
void WINAPI DexKNN_genRoadmap(
	double *r_vecArr, int &r_vecCnt,
	double *vVecArr, int vVecCnt, int *vEdgeArr, int vEdgeCnt,
	int sampFreq, int rndCnt, double minLen,
	int centCnt, int iters, double minDist
	)
{
	//=========================================================
	// bail conditions
	if (!r_vecArr || !r_vecCnt)
		return;
	//=========================================================
	// init input, run
	std::vector<Vector<> *> vecList;
	std::vector<Vector<> *> vVecList;
	std::vector<std::pair<int, int> *> vEdgeList;
	for (int i = 0; i < r_vecCnt; i++)
		vecList.push_back(new Vector<>(DIM_CNT, &r_vecArr[i * DIM_CNT]));
	for (int j = 0; j < vVecCnt; j++)
		vVecList.push_back(new Vector<>(DIM_CNT, &vVecArr[j * DIM_CNT]));
	for (int k = 0; k < vEdgeCnt; k++)
		vEdgeList.push_back(new std::pair<int, int>(
			vEdgeArr[k * 2 + 0],
			vEdgeArr[k * 2 + 1]
			));
	mDexKNN.genRoadMap(
		vecList, vVecList, vEdgeList,
		sampFreq, rndCnt, minLen, centCnt, iters, minDist
		);
	//=========================================================
	// extract output
	if (r_vecArr)
	{
		r_vecCnt = vecList.size();
		for (int n = 0; n < r_vecCnt; n++)
			vecList[n]->toArray(&r_vecArr[n * DIM_CNT]);
	}
	//=========================================================
	// clean up
	std::for_each(vecList.begin(), vecList.end(), std::kill());
	std::for_each(vVecList.begin(), vVecList.end(), std::kill());
	std::for_each(vEdgeList.begin(), vEdgeList.end(), std::kill());
	//=========================================================
}
bool WINAPI DexKNN_genPath(
	int *r_pathIdxArr, int &r_pathIdxCnt, int *r_freeIdxArr, int &r_freeIdxCnt,
	int *edgeArr, int edgeCnt, double *vecArr, int vecCnt,
	int srcIdx, int destIdx, int stepCnt
	)
{
	//=========================================================
	// bail conditions
	if (!vecArr || !vecCnt)
		return false;
	//=========================================================
	// init input, run
	std::vector<int> pathIdxList;
	std::vector<int> freeIdxList;
	std::vector<std::pair<int, int> *> edgeList;
	std::vector<Vector<> *> vecList;
	for (int i = 0; i < edgeCnt; i++)
		edgeList.push_back(new std::pair<int, int>(
			edgeArr[i * 2 + 0],
			edgeArr[i * 2 + 1]
			));
	for (int j = 0; j < vecCnt; j++)
		vecList.push_back(new Vector<>(DIM_CNT, &vecArr[j * DIM_CNT]));
	bool r_success = mDexKNN.genPath(
		pathIdxList, freeIdxList, edgeList, vecList, srcIdx, destIdx, stepCnt
		);
	//=========================================================
	// extract output
	if (r_pathIdxArr)
	{
		r_pathIdxCnt = pathIdxList.size();
		std::copy(pathIdxList.begin(), pathIdxList.end(), r_pathIdxArr);
	}
	if (r_freeIdxArr)
	{
		r_freeIdxCnt = freeIdxList.size();
		std::copy(freeIdxList.begin(), freeIdxList.end(), r_freeIdxArr);
	}
	//=========================================================
	// clean up
	std::for_each(edgeList.begin(), edgeList.end(), std::kill());
	std::for_each(vecList.begin(), vecList.end(), std::kill());
	//=========================================================
	return r_success;
}
void WINAPI DexKNN_cluster(
	double *r_centArr, int &r_centCnt,
	double *vecArr, int vecCnt, int iters, double minDist
	)
{
	//=========================================================
	// bail conditions
	if (!vecArr || !vecCnt)
		return;
	//=========================================================
	// init input, run
	std::vector<Vector<> *> centList;
	std::vector<Vector<> *> vecList;
	for (int i = 0; i < vecCnt; i++)
		vecList.push_back(new Vector<>(DIM_CNT, &vecArr[i * DIM_CNT]));
	mDexKNN.cluster(centList, vecList, r_centCnt, iters, minDist);
	//=========================================================
	// extract output
	if (r_centArr)
	{
		r_centCnt = centList.size();
		for (int j = 0; j < r_centCnt; j++)
			centList[j]->toArray(&r_centArr[j * DIM_CNT]);
	}
	//=========================================================
	// clean up
	std::for_each(centList.begin(), centList.end(), std::kill());
	std::for_each(vecList.begin(), vecList.end(), std::kill());
	//=========================================================
}
void WINAPI DexKNN_toString(char *buffer) {mDexKNN.toString(buffer);}