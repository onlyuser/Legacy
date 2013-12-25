#include "N_Net.h"

void N_Net::regEventFunc(VB_FUNC eventFunc)
{
	mEventFunc = eventFunc;
}

int N_Net::getWeightCount()
{
	return mWeightList->mCount;
}

void N_Net::setWeight(int index, float value)
{
	mWeightList->mItem[index]->mValue = value;
}

float N_Net::getWeight(int index)
{
	return mWeightList->mItem[index]->mValue;
}

/* associates input output pairs */
float N_Net::applyMatrix(float *matrix, int col, bool train, int iter)
{
	int i;
	int j;
	int n;
	int input;
	int output;
	int row;
	float *vector;
	int start;
	int end;
	float sumError;

	input = mInputList->mCount - 1;
	output = mOutputList->mCount;
	row = input + output;
	vector = new float[row];
	for (i = 0; i < row; i++)
	{
		start = i * col;
		end = (i + 1) * col - 1;
		normVector(matrix, start, end, mMinVector[i], mMaxVector[i], true);
	}
	for (n = 0; n < iter; n++)
	{
		sumError = 0;
		for (i = 0; i < col; i++)
		{
			/* capture col-data from matrix */
			for (j = 0; j < row; j++)
				vector[j] = matrix[j * col + i];
			/* apply */
			setVector(vector);
			sumError += run(train);
			if (!train)
			{
				getVector(vector);
				/* write-back network output */
				for (j = input; j < row; j++)
					matrix[j * col + i] = vector[j];
			}
		}
		sumError /= col;
		if (mEventFunc != NULL)
			mEventFunc();
	}
	for (i = 0; i < row; i++)
	{
		start = i * col;
		end = (i + 1) * col - 1;
		denormVector(matrix, start, end, mMinVector[i], mMaxVector[i]);
	}
	delete []vector;
	return sumError;
}

/* extrapolates an array */
/* via moving window */
float N_Net::extrapArray(float *array, int length, int shift, bool train, int iter)
{
	int i;
	int j;
	int input;
	int output;
	int row;
	int col;
	float *matrix;
	float *window;
	float error;

	input = mInputList->mCount - 1;
	output = mOutputList->mCount;
	row = input + output;
	/* retain last step */
	col = length - row + 1;
	if (train)
	{
		matrix = new float[row * col];
		for (i = 0; i < col; i++)
			for (j = 0; j < row; j++)
				/* cascade data */
				matrix[j * col + i] = array[i + j];
		/* train */
		error = applyMatrix(matrix, col, true, iter);
		delete []matrix;
	}
	else
	{
		error = -1;
		/* left-shift data */
		for (i = 0; i < length - shift; i++)
			array[i] = array[i + shift];
		for (i = length - shift; i < length; i++)
			array[i] = 0;
		window = new float[row];
		/* slide window through data */
		for (i = length - shift - input; i < col; i += output)
		{
			/* capture window contents */
			for (j = 0; j < input; j++)
			{
				window[j] = array[i + j];
				/* use bounds acquired during training phase */
				normVector(&window[j], 0, 0, mMinVector[j], mMaxVector[j], false);
			}
			/* apply */
			setVector(window);
			run(false);
			getVector(window);
			/* write-back network output */
			for (j = input; j < row; j++)
			{
				denormVector(&window[j], 0, 0, mMinVector[j], mMaxVector[j]);
				array[i + j] = window[j];
			}
			if (mEventFunc != NULL)
				mEventFunc();
		}
		delete []window;
	}
	return error;
}

/* associates two adjacent arrays */
float N_Net::applyImage(float *image, bool train, int iter)
{
	int i;
	int input;
	int output;
	float minA;
	float maxA;
	float minB;
	float maxB;
	int startA;
	int endA;
	int startB;
	int endB;
	float error;

	input = mInputList->mCount - 1;
	output = mOutputList->mCount;
	startA = 0;
	endA = startA + input - 1;
	/* output image immediately follows input image */
	startB = endA + 1;
	endB = startB + output - 1;
	normVector(image, startA, endA, minA, maxA, true);
	normVector(image, startB, endB, minB, maxB, true);
	for (i = 0; i < iter; i++)
	{
		setVector(image);
		error = run(train);
		if (mEventFunc != NULL)
			mEventFunc();
	}
	if (!train)
		getVector(image);
	denormVector(image, startA, endA, minA, maxA);
	denormVector(image, startB, endB, minB, maxB);
	return error;
}

/* associates input row data with output row data */
/* via moving window */
float N_Net::applyMatrixEx(float *matrix, int length, int row, bool train, int iter)
{
	int i;
	int j;
	int n;
	int b;
	int col;
	int base;
	int steps;
	float *minVector;
	float *maxVector;
	float *window;
	float *tally;
	int start;
	int end;
	float sumError;

	col = ((mInputList->mCount - 1) + mOutputList->mCount) / row;
	base = (mInputList->mCount - 1) / col;
	/* retain last step */
	steps = length - col + 1;
	minVector = new float[row];
	maxVector = new float[row];
	window = new float[row * col];
	tally = new float[length];
	for (i = 0; i < row; i++)
	{
		start = i * length;
		end = (i + 1) * length - 1;
		normVector(matrix, start, end, minVector[i], maxVector[i], true);
	}
	for (n = 0; n < iter; n++)
	{
		if (!train)
		{
			for (i = base; i < row; i++)
				for (j = 0; j < length; j++)
					matrix[i * length + j] = 0;
			for (i = 0; i < length; i++)
				tally[i] = 0;
		}
		/* slide window through data */
		sumError = 0;
		for (b = 0; b < steps; b++)
		{
			/* capture window contents */
			for (i = 0; i < row; i++)
				for (j = 0; j < col; j++)
					window[i * col + j] = matrix[i * length + b + j];
			/* apply */
			setVector(window);
			sumError += run(train);
			if (!train)
			{
				getVector(window);
				/* tally cascading network output */
				for (i = base; i < row; i++)
					for (j = 0; j < col; j++)
						matrix[i * length + b + j] += window[i * col + j];
				for (i = 0; i < col; i++)
					tally[b + i]++;
			}
		}
		sumError /= steps;
		/* normalize tallied network output */
		if (!train)
			for (i = base; i < row; i++)
				for (j = 0; j < length; j++)
					matrix[i * length + j] /= tally[j];
	}
	for (i = 0; i < row; i++)
	{
		start = i * length;
		end = (i + 1) * length - 1;
		denormVector(matrix, start, end, minVector[i], maxVector[i]);
	}
	delete []minVector;
	delete []maxVector;
	delete []window;
	delete []tally;
	return sumError;
}

/* extrapolates a matrix */
float N_Net::extrapMatrix(float *matrix, int length, int shift, int row, int iter)
{
	int i;
	int j;
	int col;
	int base;
	int input;
	int output;
	int hidden;
	int layer;
	float error;
	N_Net *pN_Net;
	float *array;

	col = ((mInputList->mCount - 1) + mOutputList->mCount) / row;
	base = (mInputList->mCount - 1) / col;
	input = col - 1;
	output = 1;
	hidden = input;
	layer = 1;
	pN_Net = new N_Net(input, output, hidden, layer);
	pN_Net->regEventFunc(mEventFunc);
	array = new float[length];
	/* learn relation between input row-data and output row-data */
	error = applyMatrixEx(matrix, length, row, true, iter);
	for (i = 0; i < base; i++)
	{
		pN_Net->randomize();
		/* capture row-data from matrix */
		for (j = 0; j < length; j++)
			array[j] = matrix[i * length + j];
		/* learn row-data pattern */
		pN_Net->extrapArray(array, length, shift, true, iter);
		/* left-shift row-data */
		for (j = 0; j < length - shift; j++)
			array[j] = array[j + shift];
		for (i = length - shift; i < length; i++)
			array[i] = 0;
		/* complete row-data */
		pN_Net->extrapArray(array, length, shift, false, 1);
		/* restore row-data to matrix */
		for (j = 0; j < length; j++)
			matrix[i * length + j] = array[j];
	}
	/* derive output row-data from input row-data */
	applyMatrixEx(matrix, length, row, false, 1);
	delete pN_Net;
	delete []array;
	return error;
}
