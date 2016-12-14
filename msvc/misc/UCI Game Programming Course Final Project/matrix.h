#ifndef H_MATRIX
#define H_MATRIX

#include "misc.h"

void matrixCopy(float **result, float **matrix);
float **matrixAlloc();
void matrixFree(float **matrix);
float **matrixAlloc(long row, long col);
void matrixFree(float **matrix, long row);
void matrixMult(float **result, float **matrixA, float **matrixB);
void matrixScale(float **result, float **vector, float scale);
void matrixTranspose(float **result, float **matrix);
void matrixMinor(float **result, float **matrix, long row, long col, long pRow, long pCol);
float matrixCofact(float **minor, float **matrix, long size, long pRow, long pCol);
float matrixDet(float **matrix, long size);
void matrixInv(float **result, float **matrix);
void matrixScaling(float **result, float *vector);
void matrixTrans(float **result, float *vector);
void matrixRotate(float **result, char axis, float angle);
void matrixTransEx(float **result, float *trans, float *rot, float *scale);
void matrixProj(float **result, long sw, long sh, float aspect, float fov, float n, float f, bool perspect, float zoom);
void matrixNull(float **result);
void matrixIdent(float **result);

#endif