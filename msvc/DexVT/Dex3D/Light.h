#ifndef H_LIGHT
#define H_LIGHT

#include "PhysObj.h"
#include "IAttrib.h"
#include "TDexGL.h" // DEXGL_LIGHT

class Light : public PhysObj, public IAttrib
{
public:
	Light(long id);
	~Light();
	void apply(DEXGL_LIGHT funcLight);
};

#endif