#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h> // WINAPI
#include <comdef.h> // _bstr_t()
#include <tchar.h> // _T()
#include <algorithm> // std::copy()
#include "DexKNN.h"
#include "Exception.h"

typedef void (WINAPI *FUNC_EVENT)();
typedef void (WINAPI *FUNC_MSG)(const char *text);
typedef bool (WINAPI *FUNC_CLIP)(double x, double y);

static FUNC_EVENT mFuncEvent = NULL;
static FUNC_MSG mFuncMsg = NULL;
static FUNC_CLIP mFuncClip = NULL;
static DexKNN<double> mDexKNN;

bool WINAPI DllMain(HINSTANCE hInstDLL, DWORD fdwReason, LPVOID lpReserved);
void dll_init();
void dll_destroy();
void WINAPI DexKNN_regFuncUser(FUNC_EVENT funcEvent, FUNC_MSG funcMsg);
void WINAPI DexKNN_regFuncClip(FUNC_CLIP funcClip);
long WINAPI DexKNN_sum(long a, long b);
char *WINAPI DexKNN_echo(char *text);
void sendError(Exception<> &e);
void WINAPI DexKNN_reset();
void WINAPI DexKNN_build(double *vecArr, int vecCnt);
int WINAPI DexKNN_find(double *v);
void WINAPI DexKNN_genMesh2D(
	int *r_edgeArr, int &r_edgeCnt,
	double *r_vVecArr, int &r_vVecCnt, int *r_vEdgeArr, int &r_vEdgeCnt,
	double *vecArr, int vecCnt
	);
void WINAPI DexKNN_genRoadmap(
	double *r_vecArr, int &r_vecCnt,
	double *vVecArr, int vVecCnt, int *vEdgeArr, int vEdgeCnt,
	int sampFreq, int rndCnt, double minLen,
	int centCnt, int iters, double minDist
	);
bool WINAPI DexKNN_genPath(
	int *r_pathIdxArr, int &r_pathIdxCnt, int *r_freeIdxArr, int &r_freeIdxCnt,
	int *edgeArr, int edgeCnt, double *vecArr, int vecCnt,
	int srcIdx, int destIdx, int stepCnt
	);
void WINAPI DexKNN_cluster(
	double *r_centArr, int &r_centCnt,
	double *vecArr, int vecCnt, int iters, double minDist
	);
void WINAPI DexKNN_toString(char *buffer);

#endif