#include "misc.h"

float *vectorFromAngles(float *angles)
{
	float *result;
	float **tempA;
	float **tempB;
	float **applyTrans;

	tempA = matrixRotation('x', angles[1]);
	tempB = matrixRotation('y', angles[2]);
	applyTrans = matrixIdent(4);
	applyTrans = matrixUpdate(applyTrans, matrixMult(applyTrans, tempA, 4), 4);
	applyTrans = matrixUpdate(applyTrans, matrixMult(applyTrans, tempB, 4), 4);
	result = vectorNull(4);
	result[2] = 1;
	result[3] = 1;
	result = vectorUpdate(result, vectorMatrixMult(result, applyTrans, 4));
	matrixFree(tempA, 4);
	matrixFree(tempB, 4);
	matrixFree(applyTrans, 4);
	return result;
}

float *faceCenter(float *vectA, float *vectB, float *vectC)
{
	float *result;

	result = vectorAdd(vectA, vectB, 3);
	result = vectorUpdate(result, vectorAdd(result, vectC, 3));
	result = vectorUpdate(result, vectorScale(result, 3, (float) 1 / 3));
	return result;
}

float *faceNormal(float *vectA, float *vectB, float *vectC)
{
	float *result;
	float *vectD;
	float *vectE;

	vectD = vectorSubtract(vectB, vectA, 3);
	vectE = vectorSubtract(vectC, vectA, 3);
	result = vectorCrossProduct(vectD, vectE);
	delete []vectD;
	delete []vectE;
	return result;
}

long rgb(long r, long g, long b)
{
	long result;

	result = 0;
	result = (result | b) << 8;
	result = (result | g) << 8;
	result = (result | r);
	return result;
}

long colorElem(long color, char name)
{
	long result;

	switch (name)
	{
	case 'r': result = (color & 0xff); break;
	case 'g': result = (color & 0xff00) >> 8; break;
	case 'b': result = (color & 0xff0000) >> 16;
	}
	return result;
}

long colorIntensity(long color)
{
	long result;

	result =
		(
			colorElem(color, 'r') +
			colorElem(color, 'g') +
			colorElem(color, 'b')
		);
	return result;
}

float *vectorFromColor(long color)
{
	float *vector;

	vector = new float[3];
	vector[0] = (float) colorElem(color, 'r');
	vector[1] = (float) colorElem(color, 'g');
	vector[2] = (float) colorElem(color, 'b');
	return vector;
}

long colorAdd(long colorA, long colorB)
{
	long result;
	float *vectA;
	float *vectB;
	float *vectC;

	vectA = vectorFromColor(colorA);
	vectB = vectorFromColor(colorB);
	vectC = vectorAdd(vectA, vectB, 3);
	result = rgb((long) vectC[0], (long) vectC[1], (long) vectC[2]);
	delete []vectA;
	delete []vectB;
	delete []vectC;
	return result;
}

long colorScale(long color, float scale)
{
	long result;
	float *vectA;
	float *vectB;

	vectA = vectorFromColor(color);
	vectB = vectorScale(vectA, 3, scale);
	result = rgb((long) vectB[0], (long) vectB[1], (long) vectB[2]);
	delete []vectA;
	delete []vectB;
	return result;
}

long colorInterp(long colorA, long colorB, float alpha)
{
	long result;
	float *vectA;
	float *vectB;
	float *vectC;

	vectA = vectorFromColor(colorA);
	vectB = vectorFromColor(colorB);
	vectC = vectorInterp(vectA, vectB, 3, alpha);
	result = rgb((long) vectC[0], (long) vectC[1], (long) vectC[2]);
	delete []vectA;
	delete []vectB;
	delete []vectC;
	return result;
}

long colorSect(long colorA, long colorB)
{
	int i;
	long result;
	float *vectA;
	float *vectB;
	float *vectC;

	vectA = vectorFromColor(colorA);
	vectB = vectorFromColor(colorB);
	vectC = new float[3];
	for (i = 0; i < 3; i++)
	{
		if (vectA[i] < vectB[i])
			vectC[i] = vectA[i];
		else
			vectC[i] = vectB[i];
	}
	result = rgb((long) vectC[0], (long) vectC[1], (long) vectC[2]);
	delete []vectA;
	delete []vectB;
	delete []vectC;
	return result;
}

long colorNull()
{
	return 0;
}

long colorRandom()
{
	long result;
	float *vectA;
	float *vectB;

	vectA = vectorRandom(3);
	vectB = vectorScale(vectA, 3, 255);
	result = rgb((long) vectB[0], (long) vectB[1], (long) vectB[2]);
	delete []vectA;
	delete []vectB;
	return result;
}
