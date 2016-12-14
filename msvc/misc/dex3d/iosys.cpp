#include "scene.h"

long scene::load(char *filename, long meshIndex)
{
	int i;
	int j;
	long result;
	FILE *stream;
	long meshCount;
	long vertCount;
	long faceCount;
	mesh *pMesh;

	stream = fopen(filename, "rb");
	if (stream != NULL)
	{
		fread(&meshCount, sizeof(long), 1, stream);
		for (i = 0; i < meshCount; i++)
		{
			fread(&vertCount, sizeof(long), 1, stream);
			fread(&faceCount, sizeof(long), 1, stream);
			result = addMesh(vertCount, faceCount);
			mMeshList.toIndex(result);
			pMesh = mMeshList.getData();
			fread(pMesh->mOrigin, sizeof(float), 3, stream);
			fread(pMesh->mAngle, sizeof(float), 3, stream);
			fread(pMesh->mScale, sizeof(float), 3, stream);
			pMesh->buildTrans();
			for (j = 0; j < vertCount; j++)
				fread(pMesh->mVertex[j], sizeof(float), 3, stream);
			for (j = 0; j < faceCount; j++)
				fread(&(pMesh->mFace[j]), sizeof(face), 1, stream);
			setColor(result, -1, rgb(255, 255, 255), 1);
			if (!(meshCount - 1 - i == meshIndex || meshIndex == -1))
				remMesh(result);
		}
		fclose(stream);
	}
	if (meshIndex == -1)
		result = meshCount;
	return result;
}

void scene::save(char *filename, long meshIndex)
{
	int i;
	FILE *stream;
	long meshCount;
	long count;
	mesh *pMesh;

	stream = fopen(filename, "wb");
	if (stream != NULL)
	{
		if (meshIndex == -1)
			meshCount = mMeshList.count();
		else
			meshCount = 1;
		fwrite(&meshCount, sizeof(long), 1, stream);
		count = 0;
		for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
		{
			if (count == (mMeshList.count() - 1 - meshIndex) || meshIndex == -1)
			{
				pMesh = mMeshList.getData();
				fwrite(&(pMesh->mVertCount), sizeof(long), 1, stream);
				fwrite(&pMesh->mFaceCount, sizeof(long), 1, stream);
				fwrite(pMesh->mOrigin, sizeof(float), 3, stream);
				fwrite(pMesh->mAngle, sizeof(float), 3, stream);
				fwrite(pMesh->mScale, sizeof(float), 3, stream);
				for (i = 0; i < pMesh->mVertCount; i++)
					fwrite(pMesh->mVertex[i], sizeof(float), 3, stream);
				for (i = 0; i < pMesh->mFaceCount; i++)
					fwrite(&(pMesh->mFace[i]), sizeof(face), 1, stream);
			}
			count++;
		}
		fclose(stream);
	}
}
