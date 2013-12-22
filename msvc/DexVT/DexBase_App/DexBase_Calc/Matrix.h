#ifndef H_MATRIX
#define H_MATRIX

#include <windows.h> // memcpy()
#include <math.h> // pow()

#define IDENT_MATRIX mIdentMatrix
#define ZERO_MATRIX mZeroMatrix

inline float **buildArray(int rowCnt, int colCnt)
{
	float **r = new float *[rowCnt];
	for (int i = 0; i < rowCnt; i++)
		r[i] = new float[colCnt];
	return r;
}

inline void killArray(float **m, int rowCnt)
{
	for (int i = 0; i < rowCnt; i++)
		delete []m[i];
	delete []m;
}

class Matrix
{
private:
	float mItem[4][4];

	//=============================================================================
	// helper function (reflexive)
	inline Matrix &mult(Matrix &m);
	inline Matrix &scale(float s);
	//=============================================================================
	// helper function (transitive)
	inline Matrix mult(Matrix &m1, Matrix &m2);
	inline Matrix scale(Matrix &m, float s);
	//=============================================================================
	// inverse
	inline void get(float **m);
	inline Matrix &set(float **m);
	static inline void minor(float **r, float **m, int rowCnt, int colCnt, int row, int col);
	static inline float cofact(float **t, float **m, int size, int row, int col);
	static inline float det(float **m, int size);
	//=============================================================================
public:
	Matrix();
	~Matrix();
	//=============================================================================
	// constructor
	Matrix(Matrix &m);
	Matrix(float **m);
	Matrix(float s);
	//=============================================================================
	// export
	void toArray(float *m);
	//=============================================================================
	// operator overload (assign)
	Matrix &operator=(Matrix &m);
	//=============================================================================
	// operator overload (reflexive)
	Matrix &operator*=(Matrix &m);
	Matrix &operator*=(float s);
	Matrix &operator/=(float s);
	//=============================================================================
	// operator overload (transitive)
	Matrix operator*(Matrix &m);
	Matrix operator*(float s);
	Matrix operator/(float s);
	//=============================================================================
	// operator overload (logic)
	float *operator[](int row);
	Matrix operator!();
	Matrix operator~();
	//=============================================================================
	// inverse
	Matrix &invert();
	Matrix inverse();
	//=============================================================================
};

static Matrix mIdentMatrix(1.0);
static Matrix mZeroMatrix(0.0);

#endif