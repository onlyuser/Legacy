#ifndef H_FILEBMP
#define H_FILEBMP

#include <windows.h> // BYTE
#include <stdio.h> // fopen(), fclose()
#include <math.h> // pow()
#include "FileSys.h"
#include "String.h"
#include "Util.h" // rgb()

#define SIZE_LONG (sizeof(long) * 8)
#define SIZE_BYTE (sizeof(BYTE) * 8)
#define BF_TYPE ('B' | (((WORD) 'M') << 8))

class FileBmp : public FileSys
{
private:
	static int calcPadding(int width, int bitCount);
public:
	static long *loadBmp(std::string filename, int &width, int &height);
	static void saveBmp(std::string filename, long *data, int width, int height);
	static long *resizeBmp(long *data, int width, int height, int newWidth, int newHeight);
};

#endif