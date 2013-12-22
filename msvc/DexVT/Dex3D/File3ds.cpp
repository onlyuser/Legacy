#include "File3ds.h"

void File3ds::load3ds(std::string filename, int index, IMesh *mesh)
{
	if (FILE *stream = fopen(filename.c_str(), "rb"))
	{
		fseek(stream, 0, SEEK_END);
		long size = ftell(stream);
		rewind(stream);
		long mainEnd = enterChunk(stream, MAIN3DS, size);
		long editEnd = enterChunk(stream, EDIT3DS, mainEnd);
		int count = 0;
		while (ftell(stream) < editEnd)
		{
			long objEnd = enterChunk(stream, EDIT_OBJECT, editEnd);
			char buf[80];
			readString(stream, buf); // read object name
			int objType = readShort(stream);
			fseek(stream, -1 * sizeof(short), SEEK_CUR); // rewind
			if (objType == OBJ_TRIMESH)
			{
				if (count == index || index == -1)
				{
					long meshEnd = enterChunk(stream, OBJ_TRIMESH, objEnd);
					if (meshEnd)
					{
						long meshBase = ftell(stream);
						//=========================================================
						enterChunk(stream, TRI_VERTEXL, meshEnd);
						int vertCnt = readShort(stream);
						fseek(stream, meshBase, SEEK_SET);
						//=========================================================
						enterChunk(stream, TRI_FACEL, meshEnd);
						int faceCnt = readShort(stream);
						fseek(stream, meshBase, SEEK_SET);
						//=========================================================
						mesh->resize(vertCnt, faceCnt);
						//=========================================================
						enterChunk(stream, TRI_VERTEXL, meshEnd);
						readVertList(stream, mesh);
						fseek(stream, meshBase, SEEK_SET);
						//=========================================================
						enterChunk(stream, TRI_FACEL, meshEnd);
						readFaceList(stream, mesh);
						fseek(stream, meshBase, SEEK_SET);
						//=========================================================
					}
					fseek(stream, meshEnd, SEEK_SET);
				}
				else
					break;
				count++;
			}
			fseek(stream, objEnd, SEEK_SET);
		}
		fclose(stream);
	}
}

long File3ds::enterChunk(FILE *stream, long chunkID, long chunkEnd)
{
	long offset = 0;
	while (ftell(stream) < chunkEnd)
	{
		long pChunkID = readShort(stream);
		long chunkSize = readLong(stream);
		if (pChunkID == chunkID)
		{
			offset = -1 * (sizeof(short) + sizeof(long)) + chunkSize;
			break;
		}
		else
		{
			fseek(stream, -1 * (sizeof(short) + sizeof(long)), SEEK_CUR); // rewind
			fseek(stream, chunkSize, SEEK_CUR); // skip this chunk
		}
	}
	return ftell(stream) + offset;
}

void File3ds::readVertList(FILE *stream, IMesh *mesh)
{
	float *vertex = new float[3];
	fseek(stream, sizeof(short), SEEK_CUR); // skip list size
	for (int i = 0; i < mesh->mVertCnt; i++)
	{
		fread(vertex, sizeof(float), 3, stream);
		mesh->setVertex(i, vertex[0], vertex[2], vertex[1]);
	}
	delete []vertex;
}

void File3ds::readFaceList(FILE *stream, IMesh *mesh)
{
	short *pFace = new short[3];
	fseek(stream, sizeof(short), SEEK_CUR); // skip list size
	for (int i = 0; i < mesh->mFaceCnt; i++)
	{
		fread(pFace, sizeof(short), 3, stream);
		mesh->setFace(i, pFace[0], pFace[2], pFace[1]);
		fseek(stream, sizeof(short), SEEK_CUR); // skip face info
	}
	delete []pFace;
}

short File3ds::readShort(FILE *stream)
{
	BYTE loByte;
	BYTE hiByte;
	fread(&loByte, sizeof(BYTE), 1, stream);
	fread(&hiByte, sizeof(BYTE), 1, stream);
	return MAKEWORD(loByte, hiByte);
}

long File3ds::readLong(FILE *stream)
{
	short loWord = readShort(stream);
	short hiWord = readShort(stream);
	return MAKELONG(loWord, hiWord);
}