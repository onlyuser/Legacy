#include "scene.h"

#define MAIN3DS 0x4D4D
#define EDIT3DS 0x3D3D
#define EDIT_OBJECT 0x4000
#define OBJ_TRIMESH 0x4100
#define TRI_VERTEXL 0x4110
#define TRI_FACEL 0x4120

long scene::load3ds(char *filename, long meshIndex)
{
	long result;
	FILE *stream;
	long fileEnd;
	long mainEnd;
	long editEnd;
	long objEnd;
	long meshEnd;
	long objType;
	long meshBase;
	long vertCount;
	long faceCount;
	long count;

	stream = fopen(filename, "rb");
	if (stream != NULL)
	{
		fseek(stream, 0, SEEK_END);
		fileEnd = ftell(stream);
		fseek(stream, 0, SEEK_SET);
		mainEnd = enterChunk(stream, MAIN3DS, fileEnd);
		editEnd = enterChunk(stream, EDIT3DS, mainEnd);
		count = 0;
		while (ftell(stream) < editEnd && (count <= meshIndex || meshIndex == -1))
		{
			objEnd = enterChunk(stream, EDIT_OBJECT, editEnd);
			delete []readString(stream); /* skip object name */
			objType = ((long) readShort(stream)) & 0x0000FFFF;
			fseek(stream, -1 * ((long) sizeof(short)), SEEK_CUR); /* rewind */
			if (objType == OBJ_TRIMESH)
			{
				if (count == meshIndex || meshIndex == -1)
				{
					meshEnd = enterChunk(stream, OBJ_TRIMESH, objEnd);
					meshBase = ftell(stream);
					if (meshEnd != 0)
					{
						enterChunk(stream, TRI_VERTEXL, meshEnd);
						vertCount = ((long) readShort(stream)) & 0x0000FFFF;
						fseek(stream, meshBase, SEEK_SET);
						enterChunk(stream, TRI_FACEL, meshEnd);
						faceCount = ((long) readShort(stream)) & 0x0000FFFF;
						fseek(stream, meshBase, SEEK_SET);
					}
					result = addMesh(vertCount, faceCount);
					if (meshEnd != 0)
					{
						enterChunk(stream, TRI_VERTEXL, meshEnd);
						readVertList(stream, result);
						fseek(stream, meshBase, SEEK_SET);
						enterChunk(stream, TRI_FACEL, meshEnd);
						readFaceList(stream, result);
						fseek(stream, meshBase, SEEK_SET);
					}
					setColor(result, -1, 0xFFFFFF, 3);
					fseek(stream, meshEnd, SEEK_SET);
				}
				count++;
			}
			fseek(stream, objEnd, SEEK_SET);
		}
		fclose(stream);
	}
	if (meshIndex == -1)
		result = count;
	return result;
}

void scene::readVertList(FILE *stream, long meshIndex)
{
	int i;
	mesh *pMesh;
	float *vertex;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	vertex = new float[3];
	fseek(stream, sizeof(short), SEEK_CUR);
	for (i = 0; i < pMesh->mVertCount; i++)
	{
		fread(vertex, sizeof(float), 3, stream);
		setVertex(meshIndex, i, vertex[0], vertex[2], vertex[1]);
	}
	delete []vertex;
}

void scene::readFaceList(FILE *stream, long meshIndex)
{
	int i;
	mesh *pMesh;
	long *pFace;

	mMeshList.toIndex(meshIndex);
	pMesh = mMeshList.getData();
	pFace = new long[3];
	fseek(stream, sizeof(short), SEEK_CUR);
	for (i = 0; i < pMesh->mFaceCount; i++)
	{
		pFace[0] = ((long) readShort(stream)) & 0x0000FFFF;
		pFace[1] = ((long) readShort(stream)) & 0x0000FFFF;
		pFace[2] = ((long) readShort(stream)) & 0x0000FFFF;
		setFace(meshIndex, i, pFace[0], pFace[2], pFace[1]);
		fseek(stream, sizeof(short), SEEK_CUR); /* skip face info */
	}
	delete []pFace;
}

short scene::readShort(FILE *stream)
{
	short result;
	BYTE loByte;
	BYTE hiByte;

	fread(&loByte, sizeof(BYTE), 1, stream);
	fread(&hiByte, sizeof(BYTE), 1, stream);
	result = (((short) hiByte) << 8) | (((short) loByte) & 0x00FF);
	return result;
}

long scene::readLong(FILE *stream)
{
	long result;
	short loWord;
	short hiWord;

	loWord = readShort(stream);
	hiWord = readShort(stream);
	result = (((long) hiWord) << 16) | (((long) loWord) & 0x0000FFFF);
	return result;
}

char *scene::readString(FILE *stream)
{
	long i;
	char *result;
	long strBase;
	BYTE curByte;

	strBase = ftell(stream);
	curByte = -1;
	for (i = 0; curByte != 0; i++)
		fread(&curByte, sizeof(BYTE), 1, stream);
	result = new char[i];
	fseek(stream, strBase, SEEK_SET);
	fread(result, sizeof(BYTE), i, stream);
	return result;
}

long scene::enterChunk(FILE *stream, long chunkID, long chunkEnd)
{
	long result;
	long pChunkID;

	result = 0;
	while (ftell(stream) < chunkEnd || chunkEnd == -1)
	{
		pChunkID = ((long) readShort(stream)) & 0x0000FFFF;
		result = readLong(stream);
		result = ftell(stream) - (sizeof(short) + sizeof(long)) + result;
		if (pChunkID == chunkID)
			break;
		else
			fseek(stream, result, SEEK_SET);
	}
	return result;
}
