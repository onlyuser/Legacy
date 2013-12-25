#include "Exports.h"

void VB_CALL Net_Load(int input, int output, int hidden, int layer)
{
	mN_Net = new N_Net(input, output, hidden, layer);
}

void VB_CALL Net_Unload()
{
	delete mN_Net;
}

void VB_CALL Net_Config(float offset, float scale, float rate, float alpha)
{
	mN_Net->config(offset, scale, rate, alpha);
}

void VB_CALL Net_Randomize()
{
	mN_Net->randomize();
}

float VB_CALL Net_Run(bool train)
{
	return mN_Net->run(train);
}

void VB_CALL Net_SetVector(float *vector)
{
	mN_Net->setVector(vector);
}

void VB_CALL Net_GetVector(float *vector)
{
	mN_Net->getVector(vector);
}

void VB_CALL Net_Print(char *string)
{
	mN_Net->print(string);
}

void VB_CALL Net_RegEventFunc(VB_FUNC eventFunc)
{
	mN_Net->regEventFunc(eventFunc);
}

int VB_CALL Net_GetWeightCount()
{
	return mN_Net->getWeightCount();
}

void VB_CALL Net_SetWeight(int index, float value)
{
	mN_Net->setWeight(index, value);
}

float VB_CALL Net_GetWeight(int index)
{
	return mN_Net->getWeight(index);
}

float VB_CALL Net_ApplyMatrix(float *matrix, int row, bool train, int iter)
{
	return mN_Net->applyMatrix(matrix, row, train, iter);
}

float VB_CALL Net_ExtrapArray(float *array, int length, int shift, bool train, int iter)
{
	return mN_Net->extrapArray(array, length, shift, train, iter);
}

float VB_CALL Net_ApplyImage(float *image, bool train, int iter)
{
	return mN_Net->applyImage(image, train, iter);
}

float VB_CALL Net_ExtrapMatrix(float *matrix, int length, int shift, int row, int iter)
{
	return mN_Net->extrapMatrix(matrix, length, shift, row, iter);
}
