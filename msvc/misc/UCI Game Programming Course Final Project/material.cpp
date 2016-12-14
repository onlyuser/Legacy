#include "material.h"

material::material()
{
	/* data */
	mName = NULL;
}

material::~material()
{
	/* data */
	if (mName != NULL)
		delete []mName;
}