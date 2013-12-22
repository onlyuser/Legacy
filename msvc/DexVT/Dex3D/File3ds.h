#ifndef H_FILE3DS
#define H_FILE3DS

#include <windows.h> // BYTE
#include <stdio.h> // fopen(), fclose()
#include <math.h> // pow()
#include "FileSys.h"
#include "IMesh.h"
#include "String.h"

#define MAIN3DS 0x4D4D
#define EDIT3DS 0x3D3D
#define EDIT_OBJECT 0x4000
#define OBJ_TRIMESH 0x4100
#define TRI_VERTEXL 0x4110
#define TRI_FACEL 0x4120

class File3ds : public FileSys
{
private:
	static long enterChunk(FILE *stream, long chunkID, long chunkEnd);
	static void readVertList(FILE *stream, IMesh *mesh);
	static void readFaceList(FILE *stream, IMesh *mesh);
	static short readShort(FILE *stream);
	static long readLong(FILE *stream);
public:
	static void load3ds(std::string filename, int index, IMesh *mesh);
};

#endif