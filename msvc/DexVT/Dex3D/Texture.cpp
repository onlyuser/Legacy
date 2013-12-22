#include "Texture.h"

Texture::Texture()
{
	mNumID = 0;
	//=====================================
	mGlow = false;
	//=====================================
	this->setAttrib(rgb(60, 60, 60), rgb(120, 120, 120), rgb(0, 0, 0));
}

Texture::~Texture()
{
}

void Texture::lock(std::string filename, std::string maskFile, long maskColor, bool mipmap, DEXGL_TEXGEN funcTexGen)
{
	if (filename != "")
	{
		int width, height;
		long *data = FileBmp::loadBmp(filename, width, height);
		for (int i = 1; i < width; i *= 2);
		for (int j = 1; j < height; j *= 2);
		int newWidth = i;
		int newHeight = j;
		long *newData = FileBmp::resizeBmp(
			data, width, height, newWidth, newHeight
			);
		if (newData)
			delete []data;
		else
			newData = data;
		if (maskFile == "")
			for (long k = 0; k < (long) newWidth * newHeight; k++)
				newData[k] = newData[k] | 0xFF000000;
		else
		{
			long *mask = FileBmp::loadBmp(maskFile, width, height);
			long *newMask = FileBmp::resizeBmp(
				mask, width, height, newWidth, newHeight
				);
			if (newMask)
				delete []mask;
			else
				newMask = mask;
			float r = (float) 1 / (255 * 3);
			for (long k = 0; k < (long) newWidth * newHeight; k++)
				if (maskColor == -1)
				{
					float alpha = (float) (
						getR(newData[k]) +
						getG(newData[k]) +
						getB(newData[k])
						) * r;
					newData[k] = newData[k] | (((long) (alpha * 255)) << 24);
				}
				else
					newData[k] = (newMask[k] == maskColor) ?
						(newData[k] | 0xFF000000) : newData[k];
			delete []newMask;
		}
		mNumID = funcTexGen(newData, newWidth, newHeight, mipmap);
		delete []newData;
		mGlow = (maskColor < 0);
	}
}

void Texture::unlock(DEXGL_TEXKILL funcTexKill)
{
	if (mNumID)
	{
		funcTexKill(mNumID);
		mNumID = 0;
	}
}

void Texture::setHgtMap(IMesh *mesh, std::string filename, float height)
{
	int mapWidth, mapHeight;
	long *data = FileBmp::loadBmp(filename, mapWidth, mapHeight);
	float r = (float) 1 / 255;
	Vector *v = mesh->getVertices();
	for (int i = 0; i < mesh->mVertCnt; i++)
	{
		int x = map_linear(v[i].x, mesh->mMin.x, mesh->mMax.x, mapWidth - 1, 0);
		int y = map_linear(v[i].z, mesh->mMin.z, mesh->mMax.z, 0, mapHeight - 1);
		long c = data[y * mapWidth + x];
		v[i].y = getR(c) * r * height;
		mesh->setVertex(i, v[i].x, v[i].y, v[i].z);
	}
	delete []data;
}

void Texture::project(IMesh *mesh, DIR::DIR dir)
{
	int i;
	Vector *v = mesh->getVertices();
	switch (dir)
	{
		case DIR::LEFT:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					1 - (v[i].z - mesh->mMin.z) / mesh->mDim.z,
					(v[i].y - mesh->mMin.y) / mesh->mDim.y
					);
			break;
		case DIR::RIGHT:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					(v[i].z - mesh->mMin.z) / mesh->mDim.z,
					(v[i].y - mesh->mMin.y) / mesh->mDim.y
					);
			break;
		case DIR::TOP:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					1 - (v[i].x - mesh->mMin.x) / mesh->mDim.x,
					(v[i].z - mesh->mMin.z) / mesh->mDim.z
					);
			break;
		case DIR::BOTTOM:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					(v[i].x - mesh->mMin.x) / mesh->mDim.x,
					(v[i].z - mesh->mMin.z) / mesh->mDim.z
					);
			break;
		case DIR::FRONT:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					(v[i].x - mesh->mMin.x) / mesh->mDim.x,
					(v[i].y - mesh->mMin.y) / mesh->mDim.y
					);
			break;
		case DIR::BACK:
			for (i = 0; i < mesh->mVertCnt; i++)
				mesh->setAnchor(
					i,
					1 - (v[i].x - mesh->mMin.x) / mesh->mDim.x,
					(v[i].y - mesh->mMin.y) / mesh->mDim.y
					);
			break;
		case DIR::WRAP_SPHERE:
			for (i = 0; i < mesh->mVertCnt; i++)
			{
				Vector angle = v[i].toAngle();
				mesh->setAnchor(
					i,
					angle.yaw / toRad(360),
					(angle.pitch - 0.5f) / toRad(180)
					);
			}
			break;
		case DIR::WRAP_CYLNDR:
			for (i = 0; i < mesh->mVertCnt; i++)
			{
				Vector angle = v[i].toAngle();
				mesh->setAnchor(
					i,
					angle.yaw / toRad(360),
					(v[i].y - mesh->mMin.y) / mesh->mDim.y
					);
			}
			break;
		case DIR::RADIAL_SPHERE:
			for (i = 0; i < mesh->mVertCnt; i++)
			{
				Vector angle = v[i].toAngle();
				mesh->setAnchor(
					i,
					angle.yaw / toRad(360),
					v[i].mod() / mesh->mRadius
					);
			}
			break;
		case DIR::RADIAL_CYLNDR:
			for (i = 0; i < mesh->mVertCnt; i++)
			{
				Vector angle = v[i].toAngle();
				mesh->setAnchor(
					i,
					angle.yaw / toRad(360),
					Vector(v[i].x, 0, v[i].z).mod() / mesh->mRadius
					);
			}
	}
}

void Texture::apply(DEXGL_BRUSH funcBrush, DEXGL_TEXBIND funcTexBind)
{
	funcBrush((long) mAttrib, mShininess);
	funcTexBind(mNumID);
}