#ifndef H_IATTRIB
#define H_IATTRIB

#include "Vector.h"
#include "Matrix.h"
#include "Color.h"

class IAttrib
{
protected:
	float **mAttrib;
	float mShininess;
public:
	IAttrib();
	~IAttrib();
	void setAttrib(long ambient, long diffuse, long specular, long emission, float shininess);
	void setAttrib(long ambient, long diffuse, long specular);
	void setAttrib(Vector &v);
};

#endif