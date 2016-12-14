#ifndef H_TDEXKNN
#define H_TDEXKNN

typedef void (WINAPI *DexKNN_build)(double *vecArr, int vecCnt);
typedef int (WINAPI *DexKNN_find)(double *v);
typedef void (WINAPI *DexKNN_genMesh2D)(
	int *r_edgeArr, int &r_edgeCnt,
	double *r_vVecArr, int &r_vVecCnt, int *r_vEdgeArr, int &r_vEdgeCnt,
	double *vecArr, int vecCnt
	);
typedef void (WINAPI *DexKNN_genRoadmap)(
	double *r_vecArr, int &r_vecCnt,
	double *vVecArr, int vVecCnt, int *vEdgeArr, int vEdgeCnt,
	int sampFreq, int rndCnt, double minLen,
	int centCnt, int iters, double minDist
	);
typedef bool (WINAPI *DexKNN_genPath)(
	int *r_pathIdxArr, int &r_pathIdxCnt, int *r_freeIdxArr, int &r_freeIdxCnt,
	int *edgeArr, int edgeCnt, double *vecArr, int vecCnt,
	int srcIdx, int destIdx, int stepCnt
	);
typedef void (WINAPI *DexKNN_cluster)(
	double *r_centArr, int &r_centCnt,
	double *vecArr, int vecCnt, int iters, double minDist
	);

#endif