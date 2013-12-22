#include "Light.h"

Light::Light(long id)
{
	mNumID = id;
	this->setAttrib(rgb(60, 60, 60), rgb(120, 120, 120), rgb(0, 0, 0));
}

Light::~Light()
{
}

void Light::apply(DEXGL_LIGHT funcLight)
{
	this->setAttrib(mAbsOrigin);
	funcLight(mNumID, mVisible ? (long) mAttrib : NULL);
}