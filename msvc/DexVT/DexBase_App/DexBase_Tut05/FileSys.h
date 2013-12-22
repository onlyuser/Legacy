#ifndef H_FILESYS
#define H_FILESYS

#include <windows.h> // BYTE
#include <stdio.h> // fgetc()

class FileSys
{
protected:
	static void readString(FILE *stream, char *buf);
};

#endif