#include "Matrix.h"

Matrix::Matrix()  {}
Matrix::~Matrix() {}

//=============================================================================
// CONSTRUCTOR

Matrix::Matrix(Matrix &m) {*this = m;}
Matrix::Matrix(float s)
{
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			mItem[i][j] = (i == j) ? s : 0;
}
Matrix::Matrix(float **m) {this->set(m);}

//=============================================================================
// EXPORT

void Matrix::toArray(float *m)
{
	for (int i = 0; i < 4; i++)
		memcpy(&m[i * 4], mItem[i], sizeof(float) * 4);
}

//=============================================================================
// HELPER FUNCTION

// reflexive
inline Matrix &Matrix::mult(Matrix &m)
{
	Matrix t;
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			t[i][j] =
				mItem[i][0] * m[0][j] +
				mItem[i][1] * m[1][j] +
				mItem[i][2] * m[2][j] +
				mItem[i][3] * m[3][j];
	return *this = t;
}
inline Matrix &Matrix::scale(float s)
{
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			mItem[i][j] *= s;
	return *this;
}

// transitive
inline Matrix Matrix::mult(Matrix &m1, Matrix &m2)
{
	Matrix r;
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			r[i][j] =
				m1[i][0] * m2[0][j] +
				m1[i][1] * m2[1][j] +
				m1[i][2] * m2[2][j] +
				m1[i][3] * m2[3][j];
	return r;
}
inline Matrix Matrix::scale(Matrix &m, float s)
{
	Matrix r;
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			r[i][j] = m[i][j] * s;
	return r;
}

//=============================================================================
// OPERATOR OVERLOAD

// assign
Matrix &Matrix::operator=(Matrix &m)
{
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			mItem[i][j] = m[i][j];
	return *this;
}

// reflexive
Matrix &Matrix::operator*=(Matrix &m) {return this->mult(m);}
Matrix &Matrix::operator/=(Matrix &m) {return this->mult(m.inverse());}
Matrix &Matrix::operator*=(float s)   {return this->scale(s);}
Matrix &Matrix::operator/=(float s)   {return this->scale(1 / s);}

// transitive
Matrix Matrix::operator*(Matrix &m)   {return this->mult(*this, m);}
Matrix Matrix::operator/(Matrix &m)   {return this->mult(*this, m.inverse());}
Matrix Matrix::operator*(float s)     {return this->scale(*this, s);}
Matrix Matrix::operator/(float s)     {return this->scale(*this, 1 / s);}

// logic
float  *Matrix::operator[](int row) {return mItem[row];}
Matrix Matrix::operator!()          {return this->inverse();}
Matrix Matrix::operator~()
{
	Matrix r;
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			r[i][j] = mItem[j][i];
	return r;
}

//=============================================================================
// INVERSE

inline void Matrix::get(float **m)
{
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			m[i][j] = mItem[i][j];
}

inline Matrix &Matrix::set(float **m)
{
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			mItem[i][j] = m[i][j];
	return *this;
}

inline void Matrix::minor(float **r, float **m, int rowCnt, int colCnt, int row, int col)
{
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

inline float Matrix::cofact(float **t, float **m, int size, int row, int col)
{
	minor(t, m, size, size, row, col);
	return (float) pow(-1, row + col) * det(t, size - 1);
}

inline float Matrix::det(float **m, int size)
{
	float result = 0;
	if (size == 1)
		result = m[0][0];
	else
	{
		float **t = buildArray(size - 1, size - 1);
		for (int i = 0; i < size; i++)
			result += m[0][i] * cofact(t, m, size, 0, i);
		killArray(t, size - 1);
	}
	return result;
}

Matrix &Matrix::invert()
{
	float **m = buildArray(4, 4);
	float **t = buildArray(3, 3);
	float **r = buildArray(4, 4);
	this->get(m);
	for (int i = 0; i < 4; i++)
		for (int j = 0; j < 4; j++)
			r[i][j] = cofact(t, m, 4, i, j);
	float d = det(m, 4);
	this->set(r);
	killArray(m, 4);
	killArray(t, 3);
	killArray(r, 4);
	return *this = d ? ~(*this) / d : ZERO_MATRIX;
}

Matrix Matrix::inverse()
{
	return Matrix(*this).invert();
}