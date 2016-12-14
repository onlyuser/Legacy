#ifndef H_MATERIAL
#define H_MATERIAL

#include "misc.h"

class material
{
public:
	/* data */
	char *mName;

	/* attributes */
	long mAmbient;
	long mDiffuse;
	long mSpecular;
	long mEmission;
	float mShininess;

	material();
	~material();
};

#endif