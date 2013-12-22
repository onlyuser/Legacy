#ifndef H_POLYGON
#define H_POLYGON

#include "IMesh.h"

class Polygon
{
public:
	static void makeBox(IMesh *mesh);
	static void makeGrid(IMesh *mesh, int gridX, int gridZ);
	static void makeCylinder(IMesh *mesh, int step);
	static void makeCone(IMesh *mesh, int step);
	static void makeSphere(IMesh *mesh, int stepLng, int stepLat);
	static void makeHemis(IMesh *mesh, int stepLng, int stepLat);
	static void makeCapsule(
		IMesh *mesh, float radius, float height, int stepLng, int stepLat
		);
	static void makeTorus(
		IMesh *mesh, float radMajor, float radMinor, int stepMajor, int stepMinor
		);
	static void makeOcta(IMesh *mesh);
	static void makeTetra(IMesh *mesh);
};

#endif