#include "IAttrib.h"

IAttrib::IAttrib()
{
	mAttrib = buildArray(4, 4);
	this->setAttrib(NULL_VECTOR);
}

IAttrib::~IAttrib()
{
	killArray(mAttrib, 4);
}

void IAttrib::setAttrib(long ambient, long diffuse, long specular, long emission, float shininess)
{
	float r = (float) 1 / 255;
	(Color::toVector(ambient) * r).toArray(mAttrib[0]);
	(Color::toVector(diffuse) * r).toArray(mAttrib[1]);
	(Color::toVector(specular) * r).toArray(mAttrib[2]);
	(Color::toVector(emission) * r).toArray(mAttrib[3]);
	mShininess = shininess;
}

void IAttrib::setAttrib(long ambient, long diffuse, long specular)
{
	this->setAttrib(ambient, diffuse, specular, 0, 0);
}

void IAttrib::setAttrib(Vector &v)
{
	mAttrib[3][0] = v.x;
	mAttrib[3][1] = v.y;
	mAttrib[3][2] = v.z;
	mAttrib[3][3] = 1;
}