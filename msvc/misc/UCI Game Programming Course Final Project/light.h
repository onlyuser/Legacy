#ifndef H_LIGHT
#define H_LIGHT

#include "GL/glut.h"
#include "misc.h"

class light : public object
{
public:
	/* data */
	float **mAttrib;

	/* attributes */
	long mHandle;
	bool mEnabled;

	light(long handle);
	~light();
	void setEnable(bool value);
	void setParams(long ambient, long diffuse, long specular);
	void move(long opCode, float *vector);
};

#endif