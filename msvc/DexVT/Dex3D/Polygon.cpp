#include "Polygon.h"

void Polygon::makeBox(IMesh *mesh)
{
	mesh->resize(8, 12);
	mesh->setVertex(0, 0, 0, 0);
	mesh->setVertex(1, 1, 0, 0);
	mesh->setVertex(2, 1, 0, 1);
	mesh->setVertex(3, 0, 0, 1);
	mesh->setVertex(4, 0, 1, 0);
	mesh->setVertex(5, 1, 1, 0);
	mesh->setVertex(6, 1, 1, 1);
	mesh->setVertex(7, 0, 1, 1);
	mesh->setFace(0, 0, 4, 5);
	mesh->setFace(1, 5, 1, 0);
	mesh->setFace(2, 1, 5, 6);
	mesh->setFace(3, 6, 2, 1);
	mesh->setFace(4, 2, 6, 7);
	mesh->setFace(5, 7, 3, 2);
	mesh->setFace(6, 3, 7, 4);
	mesh->setFace(7, 4, 0, 3);
	mesh->setFace(8, 0, 1, 2);
	mesh->setFace(9, 2, 3, 0);
	mesh->setFace(10, 5, 4, 7);
	mesh->setFace(11, 7, 6, 5);
}

void Polygon::makeGrid(IMesh *mesh, int gridX, int gridZ)
{
	mesh->resize(gridX * gridZ, (gridX - 1) * (gridZ - 1) * 2);
	int vertCnt = 0;
	int faceCnt = 0;
	for (int x = 0; x < gridX; x++)
		for (int z = 0; z < gridZ; z++)
		{
			mesh->setVertex(
				vertCnt, 1 - (float) x / (gridX - 1), 0, 1 - (float) z / (gridZ - 1)
				);
			if (x < gridX - 1 && z < gridZ - 1)
			{
				mesh->setFace(
					faceCnt++, vertCnt + 0, vertCnt + 1, vertCnt + 1 + gridZ
					);
				mesh->setFace(
					faceCnt++, vertCnt + 1 + gridZ, vertCnt + gridZ, vertCnt + 0
					);
			}
			vertCnt++;
		}
}

void Polygon::makeCylinder(IMesh *mesh, int step)
{
	makeGrid(mesh, step + 1, 4);
	float unit = toRad(360) / step;
	int vertCnt = 0;
	for (int i = 0; i < step + 1; i++)
	{
		mesh->setVertex(vertCnt++, 0, 1, 0);
		Vector v =
			Vector(0, 0, 1) *
			RotateTrans(AXIS::Y, i * unit);
		mesh->setVertex(vertCnt++, v.x, v.y + 1, v.z);
		mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		mesh->setVertex(vertCnt++, 0, 0, 0);
	}
}

void Polygon::makeCone(IMesh *mesh, int step)
{
	makeGrid(mesh, step + 1, 3);
	float unit = toRad(360) / step;
	int vertCnt = 0;
	for (int i = 0; i < step + 1; i++)
	{
		mesh->setVertex(vertCnt++, 0, 1, 0);
		Vector v =
			Vector(0, 0, 1) *
			RotateTrans(AXIS::Y, i * unit);
		mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		mesh->setVertex(vertCnt++, 0, 0, 0);
	}
}

void Polygon::makeSphere(IMesh *mesh, int stepLng, int stepLat)
{
	makeGrid(mesh, stepLng + 1, stepLat * 0.5f + 1);
	float unitLng = toRad(360) / stepLng;
	float unitLat = toRad(180) / (stepLat * 0.5f);
	int vertCnt = 0;
	for (int i = 0; i < stepLng + 1; i++)
		for (int j = 0; j < stepLat * 0.5f + 1; j++)
		{
			Vector v =
				Vector(0, 1, 0) *
				RotateTrans(AXIS::X, j * unitLat) *
				RotateTrans(AXIS::Y, i * unitLng);
			mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		}
}

void Polygon::makeHemis(IMesh *mesh, int stepLng, int stepLat)
{
	makeGrid(mesh, stepLng + 1, stepLat * 0.25f + 2);
	float unitLng = toRad(360) / stepLng;
	float unitLat = toRad(180) / (stepLat * 0.5f);
	int vertCnt = 0;
	for (int i = 0; i < stepLng + 1; i++)
	{
		for (int j = 0; j < stepLat * 0.25f + 1; j++)
		{
			Vector v =
				Vector(0, 1, 0) *
				RotateTrans(AXIS::X, j * unitLat) *
				RotateTrans(AXIS::Y, i * unitLng);
			mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		}
		mesh->setVertex(vertCnt++, 0, 0, 0);
	}
}

void Polygon::makeCapsule(
	IMesh *mesh, float radius, float height, int stepLng, int stepLat
	)
{
	makeGrid(mesh, stepLng + 1, stepLat * 0.5f + 2);
	float unitLng = toRad(360) / stepLng;
	float unitLat = toRad(180) / (stepLat * 0.5f);
	Vector offset = Vector(0, height, 0);
	int vertCnt = 0;
	for (int i = 0; i < stepLng + 1; i++)
	{
		for (int j = 0; j < stepLat * 0.25f + 1; j++)
		{
			Vector v =
				Vector(0, radius, 0) *
				RotateTrans(AXIS::X, j * unitLat) *
				RotateTrans(AXIS::Y, i * unitLng) *
				TranslateTrans(offset);
			mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		}
		for (int k = stepLat * 0.25f; k < stepLat * 0.5f + 1; k++)
		{
			Vector v =
				Vector(0, radius, 0) *
				RotateTrans(AXIS::X, k * unitLat) *
				RotateTrans(AXIS::Y, i * unitLng);
			mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		}
	}
}

void Polygon::makeTorus(
	IMesh *mesh, float radMajor, float radMinor, int stepMajor, int stepMinor
	)
{
	makeGrid(mesh, stepMajor + 1, stepMinor + 1);
	float unitMajor = toRad(360) / stepMajor;
	float unitMinor = toRad(360) / stepMinor;
	int vertCnt = 0;
	for (int i = 0; i < stepMajor + 1; i++)
		for (int j = 0; j < stepMinor + 1; j++)
		{
			Vector v =
				Vector(0, radMinor, 0) *
				RotateTrans(AXIS::X, j * unitMinor) *
				TranslateTrans(Vector(0, 0, radMajor)) *
				RotateTrans(AXIS::Y, i * unitMajor);
			mesh->setVertex(vertCnt++, v.x, v.y, v.z);
		}
}

void Polygon::makeOcta(IMesh *mesh)
{
	mesh->resize(6, 8);
	mesh->setVertex(0, 0, 0, 0);
	mesh->setVertex(1, 1, 0, 0);
	mesh->setVertex(2, 1, 0, 1);
	mesh->setVertex(3, 0, 0, 1);
	mesh->setVertex(4, 0.5f, -1, 0.5f);
	mesh->setVertex(5, 0.5f, 1, 0.5f);
	mesh->setFace(0, 0, 1, 4);
	mesh->setFace(1, 1, 2, 4);
	mesh->setFace(2, 2, 3, 4);
	mesh->setFace(3, 3, 0, 4);
	mesh->setFace(4, 0, 5, 1);
	mesh->setFace(5, 1, 5, 2);
	mesh->setFace(6, 2, 5, 3);
	mesh->setFace(7, 3, 5, 0);
}

void Polygon::makeTetra(IMesh *mesh)
{
	mesh->resize(4, 4);
	mesh->setVertex(0, 0, 0, 0);
	mesh->setVertex(1, 1, 1, 0);
	mesh->setVertex(2, 0, 1, 1);
	mesh->setVertex(3, 1, 0, 1);
	mesh->setFace(0, 0, 1, 3);
	mesh->setFace(1, 0, 2, 1);
	mesh->setFace(2, 0, 3, 2);
	mesh->setFace(3, 1, 2, 3);
}