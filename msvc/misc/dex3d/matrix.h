#ifndef H_MATRIX
#define H_MATRIX

#include "misc.h"

float **matrixAlloc(long, long);
void matrixFree(float **, long);
void matrixCopy(float **result, float **matrix);
float **matrixUpdate(float **, float **, long);
float **matrixTranspose(float **, long);
float *matrixRow(float **, long, long);
float **matrixScale(float **, long, long, float);
float **matrixMult(float **, float **, long);
void matrixTranspose(float **result, float **matrix);
void matrixMinor(float **result, float **matrix, long row, long col, long pRow, long pCol);
float matrixCofact(float **minor, float **matrix, long row, long col, long pRow, long pCol);
float matrixDet(float **matrix, long row);
void matrixInv(float **result, float **matrix);
void matrixScale2(float **result, float **vector, float scale);
float **matrixMinor(float **, long, long, long, long);
float matrixCofact(float **, long, long, long, long);
float matrixDet(float **, long);
float **matrixInv(float **matrix, long row);
float **matrixScaling(float *);
float **matrixTranslation(float *);
float **matrixRotation(char, float);
float **matrixProjection(long, long, float, float, float, float, bool, float);
float **matrixTransform(float *, float *, float *);
float **matrixNull(long, long);
float **matrixIdent(long);

#endif
