#include "scene.h"

long *scene::loadBmp(char *filename, long &width, long &height)
{
	long i;
	long j;
	long *result;
	FILE *stream;
	BITMAPFILEHEADER bmfHeader;
	BITMAPINFOHEADER bmiHeader;
	long padding;
	long pixelCnt;
	long colorCnt;
	RGBQUAD *palette;
	long chunkIndex;
	BYTE chunk;
	RGBTRIPLE *pixel;

	result = NULL;
	if (filename != NULL)
		stream = fopen(filename, "rb");
	else
		stream = NULL;
	if (stream != NULL)
	{
		fread(&bmfHeader, sizeof(BITMAPFILEHEADER), 1, stream);
		if (bmfHeader.bfType == ('B' | (((WORD) 'M') << 8)))
		{
			fread(&bmiHeader, sizeof(BITMAPINFOHEADER), 1, stream);
			if
				(
					bmiHeader.biBitCount == 1 ||
					bmiHeader.biBitCount == 4 ||
					bmiHeader.biBitCount == 8 ||
					bmiHeader.biBitCount == 24
				)
			{
				padding = (bmiHeader.biWidth * bmiHeader.biBitCount) % 32;
				if (padding != 0)
					padding = (32 - padding) / 8;
				pixelCnt = bmiHeader.biWidth * bmiHeader.biHeight;
				result = new long[pixelCnt];
				if (bmiHeader.biBitCount != 24)
				{
					colorCnt = (long) pow(2, bmiHeader.biBitCount);
					palette = new RGBQUAD[colorCnt];
					fread(palette, sizeof(RGBQUAD), colorCnt, stream);
					for (i = 0; i < bmiHeader.biHeight; i++)
					{
						for (j = 0; j < bmiHeader.biWidth; j++)
						{
							chunkIndex = j % (8 / bmiHeader.biBitCount);
							if (chunkIndex == 0)
								chunk = fgetc(stream);
							chunk = chunk << (chunkIndex * bmiHeader.biBitCount);
							chunk = chunk >> (8 - bmiHeader.biBitCount);
							result[i * bmiHeader.biWidth + j] =
								rgb(
									palette[chunk].rgbRed,
									palette[chunk].rgbGreen,
									palette[chunk].rgbBlue
								);
						}
						fseek(stream, padding, SEEK_CUR);
					}
					delete []palette;
				}
				else
				{
					pixel = new RGBTRIPLE[pixelCnt];
					for (i = 0; i < bmiHeader.biHeight; i++)
					{
						fread(
							&(pixel[i * bmiHeader.biWidth]),
							sizeof(RGBTRIPLE),
							bmiHeader.biWidth,
							stream
						);
						fseek(stream, padding, SEEK_CUR);
					}
					for (i = 0; i < pixelCnt; i++)
						result[i] =
							rgb(
								pixel[i].rgbtRed,
								pixel[i].rgbtGreen,
								pixel[i].rgbtBlue
							);
					delete []pixel;
				}
			}
			width = bmiHeader.biWidth;
			height = bmiHeader.biHeight;
		}
		fclose(stream);
	}
	if (result == NULL)
	{
		width = 0;
		height = 0;
	}
	return result;
}