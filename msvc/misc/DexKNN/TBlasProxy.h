#ifndef H_TBLASPROXY
#define H_TBLASPROXY

namespace GSL
{
	enum SORT
	{
		SORT_ASC,
		SORT_DESC,
		SORT_ABS_ASC,
		SORT_ABS_DESC
	};
};

typedef void (*GSL_MULT)(
	double *r, double *m1, double *m2,
	int m1_rowCnt, int m1_colCnt, int m2_rowCnt, int m2_colCnt
	);
typedef double (*GSL_INV)(double *r, double *m, int dimCnt);
typedef void (*GSL_EIGEN)(
	double *evec, double *eval, double *m, int dimCnt, GSL::SORT order
	);
typedef double (*GSL_FIT)(double &c0, double &c1, double *m, int colCnt);
typedef double (*GSL_MFIT)(
	double *c, double *y, double *m, int rowCnt, int colCnt
	);

#endif