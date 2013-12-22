#include "FileSys.h"

void FileSys::readString(FILE *stream, char *buf)
{
	int i = 0;
	while (buf[i++] = fgetc(stream));
}