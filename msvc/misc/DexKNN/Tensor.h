#ifndef H_TENSOR
#define H_TENSOR

#include <assert.h> // assert
#include <memory.h> // memset
#include <vector> // std::vector
#include <windows.h> // HINSTANCE
#include "TBlasProxy.h"
#include "String.h"
#include "Util.h" // TBinOp

//=============================================================================
// LOGIC FUNCTOR

template<class T> class TSum : public TBinOp<T, T>
	{public: T operator()(T a, T b) const {return a + b;}};
template<class T> class TProd : public TBinOp<T, T>
	{public: T operator()(T a, T b) const {return a * b;}};

//=============================================================================
// BLAS RESOURCE

template<class T = double>
class BlasRes
{
protected:
	static int       gsl_refCnt;
	static HINSTANCE gsl_hLib;
	static GSL_MULT  gsl_mult;
	static GSL_INV   gsl_inv;
	static GSL_EIGEN gsl_eigen;
	static GSL_FIT   gsl_fit;
	static GSL_MFIT  gsl_mfit;
public:
	BlasRes();
	~BlasRes();
};

template<class T> int       BlasRes<T>::gsl_refCnt = 0;
template<class T> HINSTANCE BlasRes<T>::gsl_hLib   = NULL;
template<class T> GSL_MULT  BlasRes<T>::gsl_mult   = NULL;
template<class T> GSL_INV   BlasRes<T>::gsl_inv    = NULL;
template<class T> GSL_EIGEN BlasRes<T>::gsl_eigen  = NULL;
template<class T> GSL_FIT   BlasRes<T>::gsl_fit    = NULL;
template<class T> GSL_MFIT  BlasRes<T>::gsl_mfit   = NULL;

template<class T>
BlasRes<T>::BlasRes()
{
	if (!gsl_refCnt)
		if (gsl_hLib = LoadLibrary("BlasProxy.dll"))
		{
			gsl_mult  = (GSL_MULT)  GetProcAddress(gsl_hLib, "gsl_mult");
			gsl_inv   = (GSL_INV)   GetProcAddress(gsl_hLib, "gsl_inv");
			gsl_eigen = (GSL_EIGEN) GetProcAddress(gsl_hLib, "gsl_eigen");
			gsl_fit   = (GSL_FIT)   GetProcAddress(gsl_hLib, "gsl_fit");
			gsl_mfit  = (GSL_MFIT)  GetProcAddress(gsl_hLib, "gsl_mfit");
		}
	gsl_refCnt++;
}
template<class T>
BlasRes<T>::~BlasRes()
{
	gsl_refCnt--;
	if (!gsl_refCnt)
		if (gsl_hLib)
		{
			FreeLibrary(gsl_hLib);
			gsl_hLib = NULL;
		}
}

//=============================================================================
// INVERSE MACRO

template<class T>
static inline T **_buildArray2D(int rowCnt, int colCnt)
{
	T **r = new T *[rowCnt];
	for (int i = 0; i < rowCnt; i++)
		r[i] = new T[colCnt];
	return r;
}
template<class T>
static inline void _killArray2D(T **m, int rowCnt)
{
	for (int i = 0; i < rowCnt; i++)
		delete []m[i];
	delete []m;
}
template<class T>
static inline void _minor(T **r, T **m, int rowCnt, int colCnt, int row, int col)
{
	if (rowCnt == 2 && colCnt == 2)
	{
		r[0][0] = m[1 - row][1 - col];
		return;
	}
	int row2 = 0;
	for (int i = 0; i < rowCnt; i++)
		if (i != row)
		{
			int col2 = 0;
			for (int j = 0; j < colCnt; j++)
				if (j != col)
				{
					r[row2][col2] = m[i][j];
					col2++;
				}
			row2++;
		}
}
template<class T> static inline T _det(T **m, int dimCnt);
template<class T>
static inline T _cofact(T **m, T **tmp, int dimCnt, int row, int col)
{
	if (dimCnt == 2)
		return (1 - 2 * (row ^ col)) * m[1 - row][1 - col];
	if (dimCnt == 1)
		return m[0][0];
	_minor<T>(tmp, m, dimCnt, dimCnt, row, col);
	return (T) pow(-1, row + col) * _det<T>(tmp, dimCnt - 1);
}
template<class T>
static inline T _det(T **m, int dimCnt)
{
	switch (dimCnt)
	{
		case 3:
		{
			T a = m[0][0], b = m[0][1], c = m[0][2];
			T d = m[1][0], e = m[1][1], f = m[1][2];
			T g = m[2][0], h = m[2][1], i = m[2][2];
			return
				a * (e * i - f * h) - b * (d * i - f * g) +
				c * (d * h - e * g);
		}
		case 2: return m[0][0] * m[1][1] - m[0][1] * m[1][0];
		case 1: return m[0][0];
	}
	T r = 0;
	T **tmp = _buildArray2D<T>(dimCnt - 1, dimCnt - 1);
	for (int i = 0; i < dimCnt; i++)
		r += m[0][i] * _cofact<T>(m, tmp, dimCnt, 0, i);
	_killArray2D<T>(tmp, dimCnt - 1);
	return r;
}
template<class T>
static inline void _inv(T **r, T **m, int dimCnt)
{
	T **tmp = _buildArray2D<T>(dimCnt - 1, dimCnt - 1);
	T d = _det<T>(m, dimCnt);
	d = (d > EPSILON) ? 1 / d : 0;
	for (int i = 0; i < dimCnt; i++)
		for (int j = 0; j < dimCnt; j++)
			r[i][j] = _cofact<T>(m, tmp, dimCnt, j, i) * d;
	_killArray2D<T>(tmp, dimCnt - 1);
}

//=============================================================================
// CLASS DEF

template<class T = double>
class Tensor : public BlasRes<T>
{
private:
	//=========================================================
	// operator overload (mutate)
	Tensor<T> mult(const Tensor<T> &m) const;
	Tensor<T> scale(T s) const;
	Tensor<T> bind(const TBinOp<T, T> &binOp, const Tensor<T> &m) const;
	Tensor<T> bind(const TBinOp<T, T> &binOp, const T s) const;
	//=========================================================
protected:
	int mRowCnt;
	int mColCnt;
	int mMaxDim;
	int mSize;
	std::vector<std::vector<T> > mData;
public:
	Tensor();
	~Tensor();
	//=========================================================
	// constructor
	Tensor(const Tensor<T> &m);
	Tensor(int rowCnt, int colCnt);
	Tensor(int rowCnt, int colCnt, T s);
	Tensor(int rowCnt, int colCnt, T **m);
	Tensor(int rowCnt, int colCnt, T *m);
	Tensor(int dimCnt);
	Tensor(int dimCnt, T s);
	//=========================================================
	// size
	int rowCnt() const;
	int colCnt() const;
	int maxDim() const;
	int size() const;
	bool isSquare() const;
	Tensor<T> &resize(int rowCnt, int colCnt);
	Tensor<T> &resize(int dimCnt);
	//=========================================================
	// array
	void toArray1D(T *m) const;
	Tensor<T> &fromArray1D(T *m);
	void toArray2D(T **m) const;
	Tensor<T> &fromArray2D(T **m);
	//=========================================================
	// row ops
	Tensor<T> getRow(int row) const;
	Tensor<T> getCol(int col) const;
	Tensor<T> &setRow(int row, const Tensor<T> &rowData);
	Tensor<T> &setCol(int col, const Tensor<T> &colData);
	Tensor<T> &insertRow(int row, const Tensor<T> &rowData);
	Tensor<T> &insertCol(int col, const Tensor<T> &colData);
	Tensor<T> &killRow(int row);
	Tensor<T> &killCol(int col);
	Tensor<T> &swapRows(int row1, int row2);
	Tensor<T> &swapCols(int col1, int col2);
	Tensor<T> &scaleRow(int row, T s);
	Tensor<T> &applyRow(int row1, int row2, T s);
	//=========================================================
	// assign
	std::vector<T> &operator[](int row);
	const std::vector<T> &operator[](int row) const;
	Tensor<T> &operator=(const Tensor<T> &m);
	Tensor<T> &operator=(T s);
	//=========================================================
	// operator overload (transitive)
	Tensor<T> operator*(const Tensor<T> &m) const;
	Tensor<T> operator/(const Tensor<T> &m) const;
	Tensor<T> operator*(T s) const;
	Tensor<T> operator/(T s) const;
	Tensor<T> operator+(const Tensor<T> &m) const;
	Tensor<T> operator-(const Tensor<T> &m) const;
	Tensor<T> operator+(T s) const;
	Tensor<T> operator-(T s) const;
	Tensor<T> operator&(const Tensor<T> &m) const;
	//=========================================================
	// operator overload (reflexive)
	Tensor<T> &operator*=(const Tensor<T> &m);
	Tensor<T> &operator/=(const Tensor<T> &m);
	Tensor<T> &operator*=(T s);
	Tensor<T> &operator/=(T s);
	Tensor<T> &operator+=(const Tensor<T> &m);
	Tensor<T> &operator-=(const Tensor<T> &m);
	Tensor<T> &operator+=(T s);
	Tensor<T> &operator-=(T s);
	Tensor<T> &operator&=(const Tensor<T> &m);
	//=========================================================
	// operator overload (misc)
	Tensor<T> operator-() const;
	Tensor<T> operator~() const;
	bool operator==(const Tensor<T> &m) const;
	bool operator!=(const Tensor<T> &m) const;
	//=========================================================
	// basic
	T modV() const;
	T mod() const;
	Tensor<T> norm() const;
	Tensor<T> &normalize();
	Tensor<T> ident() const;
	Tensor<T> random(T min, T max) const;
	Tensor<T> random() const;
	Tensor<T> &randomize();
	Tensor<T> minor(int row, int col) const;
	T cofactor(int row, int col) const;
	Tensor<T> embed(const Tensor<T> &m, int row, int col) const;
	Tensor<T> subset(int row, int col, int rowCnt, int colCnt) const;
	T trace() const;
	T det() const;
	//=========================================================
	// inverse
	Tensor<T> operator!() const;
	Tensor<T> &invert();
	//=========================================================
	// eigensolve
	Tensor<T> calcNystrom() const;
	void decompEigen(Tensor<T> &p, Tensor<T> &d, GSL::SORT order) const;
	//=========================================================
	// regression
	T fit(T &m, T &b) const;
	T mfit(Tensor<T> &c, const Tensor<T> &v) const;
	//=========================================================
	// output
	std::string toString() const;
	//=========================================================
};

template<class T> Tensor<T>::Tensor() {this->resize(4, 4);}
template<class T> Tensor<T>::~Tensor() {}

//=============================================================================
// CONSTRUCTOR

template<class T> Tensor<T>::Tensor(const Tensor<T> &m) {*this = m;}
template<class T> Tensor<T>::Tensor(int rowCnt, int colCnt)
	{this->resize(rowCnt, colCnt);}
template<class T> Tensor<T>::Tensor(int rowCnt, int colCnt, T s)
	{this->resize(rowCnt, colCnt); *this = s;}
template<class T> Tensor<T>::Tensor(int rowCnt, int colCnt, T **m)
	{this->resize(rowCnt, colCnt); this->fromArray2D(m);}
template<class T> Tensor<T>::Tensor(int rowCnt, int colCnt, T *m)
	{this->resize(rowCnt, colCnt); this->fromArray1D(m);}
template<class T> Tensor<T>::Tensor(int dimCnt) {this->resize(dimCnt, dimCnt);}
template<class T> Tensor<T>::Tensor(int dimCnt, T s)
	{this->resize(dimCnt, dimCnt); *this = this->ident() * s;}

//=============================================================================
// SIZE

template<class T> int Tensor<T>::rowCnt() const {return mRowCnt;}
template<class T> int Tensor<T>::colCnt() const {return mColCnt;}
template<class T> int Tensor<T>::maxDim() const {return mMaxDim;}
template<class T> int Tensor<T>::size() const {return mSize;}
template<class T> bool Tensor<T>::isSquare() const {return mRowCnt == mColCnt;}
template<class T>
Tensor<T> &Tensor<T>::resize(int rowCnt, int colCnt)
{
	assert(rowCnt > 0 && colCnt > 0);
	mRowCnt = rowCnt;
	mColCnt = colCnt;
	mMaxDim = max(mRowCnt, mColCnt);
	mSize = mRowCnt * mColCnt;
	mData.resize(mRowCnt);
	for (int i = 0; i < mRowCnt; i++)
		mData[i].resize(mColCnt);
	return *this;
}
template<class T> Tensor<T> &Tensor<T>::resize(int dimCnt)
	{return this->resize(dimCnt, dimCnt);}

//=============================================================================
// ARRAY

template<class T>
void Tensor<T>::toArray1D(T *m) const
{
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			m[i * mColCnt + j] = mData[i][j];
}
template<class T>
Tensor<T> &Tensor<T>::fromArray1D(T *m)
{
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			mData[i][j] = m[i * mColCnt + j];
	return *this;
}
template<class T>
void Tensor<T>::toArray2D(T **m) const
{
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			m[i][j] = mData[i][j];
}
template<class T>
Tensor<T> &Tensor<T>::fromArray2D(T **m)
{
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			mData[i][j] = m[i][j];
	return *this;
}

//=============================================================================
// ROW OPS

template<class T>
Tensor<T> Tensor<T>::getRow(int row) const
{
	assert(inRange(row, 0, mRowCnt - 1));
	Tensor<T> r(1, mColCnt);
	for (int i = 0; i < mColCnt; i++)
		r[0][i] = mData[row][i];
	return r;
}
template<class T>
Tensor<T> Tensor<T>::getCol(int col) const
{
	assert(inRange(col, 0, mColCnt - 1));
	Tensor<T> r(mRowCnt, 1);
	for (int i = 0; i < mRowCnt; i++)
		r[i][0] = mData[i][col];
	return r;
}
template<class T>
Tensor<T> &Tensor<T>::setRow(int row, const Tensor<T> &rowData)
{
	assert(inRange(row, 0, mRowCnt - 1));
	assert(mColCnt == rowData.colCnt());
	for (int i = 0; i < mColCnt; i++)
		mData[row][i] = rowData[0][i];
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::setCol(int col, const Tensor<T> &colData)
{
	assert(inRange(col, 0, mColCnt - 1));
	assert(mRowCnt == colData.rowCnt());
	for (int i = 0; i < mRowCnt; i++)
		mData[i][col] = colData[i][0];
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::insertRow(int row, const Tensor<T> &rowData)
{
	assert(inRange(row, 0, mRowCnt - 1));
	assert(mColCnt == rowData.colCnt());
	mData.insert(row, rowData);
	this->resize(mRowCnt + 1, mColCnt);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::insertCol(int col, const Tensor<T> &colData)
{
	assert(inRange(col, 0, mColCnt - 1));
	assert(mRowCnt == colData.rowCnt());
	for (int i = 0; i < mRowCnt; i++)
		mData[i].insert(mData[i].begin() + col, colData[i][0]);
	this->resize(mRowCnt, mColCnt + 1);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::killRow(int row)
{
	assert(inRange(row, 0, mRowCnt - 1));
	mData.erase(mData.begin() + row);
	this->resize(mRowCnt - 1, mColCnt);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::killCol(int col)
{
	assert(inRange(col, 0, mColCnt - 1));
	for (int i = 0; i < mRowCnt; i++)
		mData[i].erase(mData[i].begin() + col);
	this->resize(mRowCnt, mColCnt - 1);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::swapRows(int row1, int row2)
{
	assert(inRange(row1, 0, mRowCnt - 1));
	assert(inRange(row2, 0, mRowCnt - 1));
	for (int i = 0; i < mColCnt; i++)
		std::swap(mData[row1][i], mData[row2][i]);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::swapCols(int col1, int col2)
{
	assert(inRange(col1, 0, mColCnt - 1));
	assert(inRange(col2, 0, mColCnt - 1));
	for (int i = 0; i < mRowCnt; i++)
		std::swap(mData[i][col1], mData[i][col2]);
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::scaleRow(int row, T s)
{
	assert(inRange(row, 0, mRowCnt - 1));
	for (int i = 0; i < mColCnt; i++)
		mData[row][i] *= s;
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::applyRow(int row1, int row2, T s)
{
	assert(inRange(row1, 0, mRowCnt - 1));
	assert(inRange(row2, 0, mRowCnt - 1));
	for (int i = 0; i < mColCnt; i++)
		mData[row1][i] += mData[row2][i] * s;
	return *this;
}

//=============================================================================
// ASSIGN

template<class T> std::vector<T> &Tensor<T>::operator[](int row)
	{assert(inRange(row, 0, mRowCnt - 1)); return mData[row];}
template<class T> const std::vector<T> &Tensor<T>::operator[](int row) const
	{assert(inRange(row, 0, mRowCnt - 1)); return mData[row];}
template<class T>
Tensor<T> &Tensor<T>::operator=(const Tensor<T> &m)
{
	this->resize(m.rowCnt(), m.colCnt());
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			mData[i][j] = m[i][j];
	return *this;
}
template<class T>
Tensor<T> &Tensor<T>::operator=(T s)
{
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			mData[i][j] = s;
	return *this;
}

//=============================================================================
// OPERATOR OVERLOAD

// mutate
template<class T>
Tensor<T> Tensor<T>::mult(const Tensor<T> &m) const
{
	assert(mColCnt == m.rowCnt());
	Tensor<T> r(mRowCnt, m.colCnt());
	if (gsl_mult)
	{
		T *arr_m1 = new T[mSize];
		T *arr_m2 = new T[m.size()];
		T *arr_r = new T[r.size()];
		this->toArray1D(arr_m1);
		m.toArray1D(arr_m2);
		gsl_mult(
			arr_r, arr_m1, arr_m2, mRowCnt, mColCnt, m.rowCnt(), m.colCnt()
			);
		r.fromArray1D(arr_r);
		delete []arr_m1;
		delete []arr_m2;
		delete []arr_r;
		return r;
	}
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < m.colCnt(); j++)
			for (int k = 0; k < mColCnt; k++)
				r[i][j] += mData[i][k] * m[k][j];
	return r;
}
template<class T>
Tensor<T> Tensor<T>::scale(T s) const
{
	Tensor<T> r(mRowCnt, mColCnt);
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			r[i][j] = mData[i][j] * s;
	return r;
}
template<class T>
Tensor<T> Tensor<T>::bind(const TBinOp<T, T> &binOp, const Tensor<T> &m) const
{
	assert(mRowCnt == m.rowCnt() && mColCnt == m.colCnt());
	Tensor<T> r(mRowCnt, mColCnt);
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			r[i][j] = binOp(mData[i][j], m[i][j]);
	return r;
}
template<class T>
Tensor<T> Tensor<T>::bind(const TBinOp<T, T> &binOp, const T s) const
{
	Tensor<T> r(mRowCnt, mColCnt);
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			r[i][j] = binOp(mData[i][j], s);
	return r;
}

// transitive
template<class T> Tensor<T> Tensor<T>::operator*(const Tensor<T> &m) const {return this->mult(m);}
template<class T> Tensor<T> Tensor<T>::operator/(const Tensor<T> &m) const {return this->mult(!m);}
template<class T> Tensor<T> Tensor<T>::operator*(T s)                const {return this->scale(s);}
template<class T> Tensor<T> Tensor<T>::operator/(T s)                const {return this->scale(1 / s);}
template<class T> Tensor<T> Tensor<T>::operator+(const Tensor<T> &m) const {return this->bind(TSum<T>(), m);}
template<class T> Tensor<T> Tensor<T>::operator-(const Tensor<T> &m) const {return this->bind(TSum<T>(), -m);}
template<class T> Tensor<T> Tensor<T>::operator+(T s)                const {return this->bind(TSum<T>(), s);}
template<class T> Tensor<T> Tensor<T>::operator-(T s)                const {return this->bind(TSum<T>(), -s);}
template<class T> Tensor<T> Tensor<T>::operator&(const Tensor<T> &m) const {return this->bind(TProd<T>(), m);}

// reflexive
template<class T> Tensor<T> &Tensor<T>::operator*=(const Tensor<T> &m) {return *this = *this * m;}
template<class T> Tensor<T> &Tensor<T>::operator/=(const Tensor<T> &m) {return *this = *this / m;}
template<class T> Tensor<T> &Tensor<T>::operator*=(T s)                {return *this = *this * s;}
template<class T> Tensor<T> &Tensor<T>::operator/=(T s)                {return *this = *this / s;}
template<class T> Tensor<T> &Tensor<T>::operator+=(const Tensor<T> &m) {return *this = *this + m;}
template<class T> Tensor<T> &Tensor<T>::operator-=(const Tensor<T> &m) {return *this = *this - m;}
template<class T> Tensor<T> &Tensor<T>::operator+=(T s)                {return *this = *this + s;}
template<class T> Tensor<T> &Tensor<T>::operator-=(T s)                {return *this = *this - s;}
template<class T> Tensor<T> &Tensor<T>::operator&=(const Tensor<T> &m) {return *this = *this & m;}

// misc
template<class T> Tensor<T> Tensor<T>::operator-() const {return *this * -1;}
template<class T>
Tensor<T> Tensor<T>::operator~() const
{
	Tensor<T> r(mColCnt, mRowCnt);
	for (int i = 0; i < mColCnt; i++)
		for (int j = 0; j < mRowCnt; j++)
			r[i][j] = mData[j][i];
	return r;
}
template<class T>
bool Tensor<T>::operator==(const Tensor<T> &m) const
{
	if (mRowCnt != m.rowCnt() || mColCnt != m.colCnt())
		return false;
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			if (mData[i][j] != m[i][j])
				return false;
	return true;
}
template<class T> bool Tensor<T>::operator!=(const Tensor<T> &m) const
	{return !(*this == m);}

//=============================================================================
// BASIC

template<class T>
T Tensor<T>::modV() const
{
	T r = 0;
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			r += mData[i][j] * mData[i][j];
	return r;
}
template<class T>
T Tensor<T>::mod() const
	{return (T) pow(this->modV(), 0.5f);}
template<class T>
Tensor<T> Tensor<T>::norm() const
{
	T tmp = this->mod();
	return *this * ((tmp > EPSILON) ? 1 / tmp : 1);
}
template<class T> Tensor<T> &Tensor<T>::normalize()
	{return *this = this->norm();}
template<class T>
Tensor<T> Tensor<T>::ident() const
{
	assert(this->isSquare());
	Tensor<T> r(mMaxDim);
	for (int i = 0; i < mMaxDim; i++)
		r[i][i] = 1;
	return r;
}
template<class T>
Tensor<T> Tensor<T>::random(T min, T max) const
{
	assert(max > min);
	Tensor<T> r(mRowCnt, mColCnt);
	for (int i = 0; i < mRowCnt; i++)
		for (int j = 0; j < mColCnt; j++)
			r[i][j] = rndEx(min, max);
	return r;
}
template<class T> Tensor<T> Tensor<T>::random() const
	{return this->random(0, 1);}
template<class T> Tensor<T> &Tensor<T>::randomize()
	{return *this = this->random();}
template<class T>
Tensor<T> Tensor<T>::minor(int row, int col) const
{
	assert(inRange(row, 0, mRowCnt - 1) && inRange(col, 0, mColCnt - 1));
	Tensor<T> r(*this);
	r.killRow(row);
	r.killCol(col);
	return r;
}
template<class T>
T Tensor<T>::cofactor(int row, int col) const
{
	assert(inRange(row, 0, mRowCnt - 1) && inRange(col, 0, mColCnt - 1));
	assert(this->isSquare());
	if (mMaxDim == 2)
		return (1 - 2 * (row ^ col)) * mData[1 - row][1 - col];
	if (mMaxDim == 1)
		return mData[0][0];
	return (T) pow(-1, row + col) * this->minor(row, col).det();
}
template<class T>
Tensor<T> Tensor<T>::embed(const Tensor<T> &m, int row, int col) const
{
	assert(inRange(row, 0, mRowCnt - 1) && inRange(col, 0, mColCnt - 1));
	assert(m.rowCnt() > 0 && m.colCnt() > 0);
	assert(row + m.rowCnt() <= mRowCnt && col + m.colCnt() <= mColCnt);
	Tensor<T> r(*this);
	for (int i = row; i < row + m.rowCnt(); i++)
		for (int j = col; j < col + m.colCnt(); j++)
			r[i][j] = m[i - row][j - col];
	return r;
}
template<class T>
Tensor<T> Tensor<T>::subset(int row, int col, int rowCnt, int colCnt) const
{
	assert(inRange(row, 0, mRowCnt - 1) && inRange(col, 0, mColCnt - 1));
	assert(rowCnt > 0 && colCnt > 0);
	assert(row + rowCnt <= mRowCnt && col + colCnt <= mColCnt);
	Tensor<T> r(rowCnt, colCnt);
	for (int i = 0; i < rowCnt; i++)
		for (int j = 0; j < colCnt; j++)
			r[i][j] = mData[row + i][col + j];
	return r;
}
template<class T>
T Tensor<T>::trace() const
{
	assert(this->isSquare());
	T r = 1;
	for (int i = 0; i < mMaxDim; i++)
		r *= mData[i][i];
	return r;
}
template<class T>
T Tensor<T>::det() const
{
	assert(this->isSquare());
	T r;
	if (gsl_inv)
	{
		T *arr_m = new T[mSize];
		this->toArray1D(arr_m);
		r = gsl_inv(NULL, arr_m, mMaxDim);
		delete []arr_m;
		return r;
	}
	T **m = _buildArray2D<T>(mMaxDim, mMaxDim);
	this->toArray2D(m);
	r = _det<T>(m, mMaxDim);
	_killArray2D<T>(m, mMaxDim);
	return r;
}

//=============================================================================
// INVERSE

template<class T>
Tensor<T> Tensor<T>::operator!() const
{
	assert(this->isSquare());
	Tensor<T> r(mMaxDim);
	if (gsl_inv)
	{
		T *arr_m = new T[mSize * 2];
		this->toArray1D(arr_m);
		gsl_inv(arr_m + mSize, arr_m, mMaxDim);
		r.fromArray1D(arr_m + mSize);
		delete []arr_m;
		return r;
	}
	if (mMaxDim <= 5)
	{
		T **m = _buildArray2D<T>(mMaxDim, mMaxDim);
		T **r2 = _buildArray2D<T>(mMaxDim, mMaxDim);
		this->toArray2D(m);
		_inv(r2, m, mMaxDim);
		r.fromArray2D(r2);
		_killArray2D<T>(m, mMaxDim);
		_killArray2D<T>(r2, mMaxDim);
		return r;
	}
	r.resize(mRowCnt, mColCnt * 2);
	r = r.embed(*this, 0, 0).embed(this->ident(), 0, mColCnt);
	int m = r.rowCnt(), n = r.colCnt();
	int i = 0, j = 0;
	while (i < m && j < mColCnt)
	{
		T max_val = r[i][j], max_idx = i;
		for (int k = i + 1; k < m; k++)
		{
			T val = r[k][j];
			if (fabs(val) > fabs(max_val))
				max_val = val, max_idx = k;
		}
		if (fabs(max_val) > EPSILON)
		{
			r.swapRows(i, max_idx).scaleRow(i, 1 / max_val);
			for (int u = 0; u < m; u++)
				if (u != i)
					r.applyRow(u, i, -r[u][j]);
			i++;
		}
		j++;
	}
	return r.subset(0, mColCnt, mColCnt, mColCnt);
}
template<class T> Tensor<T> &Tensor<T>::invert() {return *this = !(*this);}

//=============================================================================
// EIGENSOLVE

template<class T>
Tensor<T> Tensor<T>::calcNystrom() const
{
	assert(mColCnt > mRowCnt);
	Tensor<T> tmp = this->subset(0, mRowCnt, mRowCnt, mColCnt - mRowCnt);
	return ~tmp * !this->subset(0, 0, mRowCnt, mRowCnt) * tmp;
}
template<class T>
void Tensor<T>::decompEigen(Tensor<T> &p, Tensor<T> &d, GSL::SORT order) const
{
	assert(mColCnt >= mRowCnt);
	if (gsl_eigen)
	{
		Tensor<T> m = this->isSquare() ? *this : this->calcNystrom();
		T *arr_m = new T[mSize];
		T *arr_eval = new T[mMaxDim];
		T *arr_evec = new T[mSize];
		m.toArray1D(arr_m);
		gsl_eigen(arr_evec, arr_eval, arr_m, mMaxDim, order);
		p.resize(mMaxDim);
		d.resize(mMaxDim);
		p.fromArray1D(arr_evec);
		for (int i = 0; i < mMaxDim; i++)
			d[i][i] = arr_eval[i];
		delete []arr_m;
		delete []arr_eval;
		delete []arr_evec;
	}
}

//=============================================================================
// REGRESSION

template<class T>
T Tensor<T>::fit(T &m, T &b) const
{
	// MODEL: y = m*x + b
	//
	// *this = (x1, y1)
	//         (x2, y2)
	//         (x3, y3)
	assert(mRowCnt == 2);
	if (gsl_fit)
	{
		T *arr_m = new T[mSize];
		this->toArray1D(arr_m);
		T chisq = gsl_fit(b, m, arr_m, mColCnt);
		delete []arr_m;
		return chisq;
	}
	return BIG_NUMBER;
}
template<class T>
T Tensor<T>::mfit(Tensor<T> &c, const Tensor<T> &y) const
{
	// MODEL: y = c1*x1 + c2*x2
	//
	// *this = (x11, x12)
	//         (x21, x22)
	//         (x31, x32)
	assert(y.maxDim() == mRowCnt);
	if (gsl_mfit)
	{
		T *arr_m = new T[mMaxDim * mColCnt];
		T *arr_y = new T[mMaxDim];
		T *arr_c = new T[mColCnt];
		memset(arr_m, 0, mMaxDim * mColCnt * sizeof(T));
		memset(arr_y, 0, mMaxDim * sizeof(T));
		this->toArray1D(arr_m);
		y.toArray1D(arr_y);
		T chisq = gsl_mfit(arr_c, arr_y, arr_m, mMaxDim, mColCnt);
		c.resize(1, mColCnt);
		c.fromArray1D(arr_c);
		delete []arr_m;
		delete []arr_y;
		delete []arr_c;
		return chisq;
	}
	return BIG_NUMBER;
}

//=============================================================================
// OUTPUT

template<class T>
std::string Tensor<T>::toString() const
{
	std::string r;
	for (int i = 0; i < mRowCnt; i++)
	{
		for (int j = 0; j < mColCnt; j++)
			r += cstr(mData[i][j]) + (j < mColCnt - 1 ? " " : "");
		r += VBCRLF;
	}
	return r;
}

//=============================================================================
// DEFAULT TYPES

static const Tensor<> IDENT_MATRIX4D(4, 1.0f);
static const Tensor<> ZERO_MATRIX4D(4, 4);

#endif