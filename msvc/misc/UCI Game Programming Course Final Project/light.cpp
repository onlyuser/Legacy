#include "light.h"

light::light(long handle)
{
	/* data */
	mAttrib = matrixAlloc(4, 4);

	/* attributes */
	mHandle = handle;
	setParams(0x808080, 0xC0C0C0, 0xFFFFFF);
	setEnable(true);
}

light::~light()
{
	/* data */
	matrixFree(mAttrib, 4);

	/* attributes */
	if (mEnabled)
		setEnable(false);
}

void light::setEnable(bool value)
{
	if (mHandle != -1)
	{
		mEnabled = value;
		if (value)
			glEnable(mHandle);
		else
			glDisable(mHandle);
	}
}

void light::setParams(long ambient, long diffuse, long specular)
{
	if (mHandle != -1)
	{
		mAttrib[0][0] = (float) colorElem(ambient, 'r') / 255;
		mAttrib[0][1] = (float) colorElem(ambient, 'g') / 255;
		mAttrib[0][2] = (float) colorElem(ambient, 'b') / 255;
		mAttrib[0][3] = 1;
		mAttrib[1][0] = (float) colorElem(diffuse, 'r') / 255;
		mAttrib[1][1] = (float) colorElem(diffuse, 'g') / 255;
		mAttrib[1][2] = (float) colorElem(diffuse, 'b') / 255;
		mAttrib[1][3] = 1;
		mAttrib[2][0] = (float) colorElem(specular, 'r') / 255;
		mAttrib[2][1] = (float) colorElem(specular, 'g') / 255;
		mAttrib[2][2] = (float) colorElem(specular, 'b') / 255;
		mAttrib[2][3] = 1;
		glLightfv(mHandle, GL_AMBIENT, mAttrib[0]);
		glLightfv(mHandle, GL_DIFFUSE, mAttrib[1]);
		glLightfv(mHandle, GL_SPECULAR, mAttrib[2]);
	}
}

void light::move(long opCode, float *vector)
{
	object::move(opCode, vector);
	if (mHandle != -1)
	{
		vectorCopy(mAttrib[3], mOrigin);
		mAttrib[3][3] = 0;
		glLightfv(mHandle, GL_POSITION, mAttrib[3]);
	}
}