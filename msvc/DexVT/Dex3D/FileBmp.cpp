#include "FileBmp.h"

int FileBmp::calcPadding(int width, int bitCount)
{
	long padding = (width * bitCount) % SIZE_LONG;
	if (padding)
		padding = (SIZE_LONG - padding) / SIZE_BYTE;
	return padding;
}

long *FileBmp::loadBmp(std::string filename, int &width, int &height)
{
	if (FILE *stream = fopen(filename.c_str(), "rb"))
	{
		long *result = NULL;
		//=========================================================
		BITMAPFILEHEADER bmfHeader;
		fread(&bmfHeader, sizeof(BITMAPFILEHEADER), 1, stream);
		//=========================================================
		if (bmfHeader.bfType == BF_TYPE)
		{
			//=========================================================
			BITMAPINFOHEADER bmiHeader;
			fread(&bmiHeader, sizeof(BITMAPINFOHEADER), 1, stream);
			//=========================================================
			width = bmiHeader.biWidth;
			height = bmiHeader.biHeight;
			long pixelCnt = width * height;
			int bitCount = bmiHeader.biBitCount;
			long padding = calcPadding(width, bitCount);
			//=========================================================
			if (
				(bitCount == 1 || bitCount == 4 || bitCount == 8) ||
				bitCount == 24
				)
			{
				result = new long[pixelCnt];
				if (bitCount != 24)
				{
					long colorCnt = (long) pow(2, bitCount);
					RGBQUAD *palette = new RGBQUAD[colorCnt];
					fread(palette, sizeof(RGBQUAD), colorCnt, stream);
					for (int i = 0; i < height; i++)
					{
						for (int j = 0; j < width; j++)
						{
							long chunkIndex = j % (SIZE_BYTE / bitCount);
							BYTE chunk = 0;
							if (!chunkIndex)
								chunk = fgetc(stream); // get new chunk
							// isolate sub-chunk
							//=====================================
							chunk = chunk << (chunkIndex * bitCount);
							chunk = chunk >> (SIZE_BYTE - bitCount);
							//=====================================
							result[i * width + j] = rgb(
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
					RGBTRIPLE *pixel = new RGBTRIPLE[pixelCnt];
					for (int i = 0; i < height; i++)
					{
						fread(
							&(pixel[i * width]), sizeof(RGBTRIPLE), width, stream
							);
						fseek(stream, padding, SEEK_CUR);
					}
					for (int j = 0; j < pixelCnt; j++)
						result[j] = rgb(
							pixel[j].rgbtRed,
							pixel[j].rgbtGreen,
							pixel[j].rgbtBlue
							);
					delete []pixel;
				}
			}
		}
		fclose(stream);
		if (result)
			return result;
	}
	width = 0;
	height = 0;
	return NULL;
}

void FileBmp::saveBmp(std::string filename, long *data, int width, int height)
{
	if (FILE *stream = fopen(filename.c_str(), "wb"))
	{
		//=========================================================
		long headerSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
		long pixelCnt = width * height;
		long dataSize = pixelCnt * sizeof(RGBTRIPLE);
		int bitCount = 24;
		long padding = calcPadding(width, bitCount);
		//=========================================================
		BITMAPFILEHEADER bmfHeader;
		memset(&bmfHeader, 0, sizeof(BITMAPFILEHEADER));
		bmfHeader.bfSize = headerSize + dataSize;
		bmfHeader.bfType = BF_TYPE;
		bmfHeader.bfOffBits = headerSize;
		fwrite(&bmfHeader, sizeof(BITMAPFILEHEADER), 1, stream);
		//=========================================================
		BITMAPINFOHEADER bmiHeader;
		memset(&bmiHeader, 0, sizeof(BITMAPINFOHEADER));
		bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
		bmiHeader.biWidth = width;
		bmiHeader.biHeight = height;
		bmiHeader.biPlanes = 1;
		bmiHeader.biBitCount = bitCount;
		bmiHeader.biCompression = BI_RGB;
		bmiHeader.biSizeImage = dataSize;
		fwrite(&bmiHeader, sizeof(BITMAPINFOHEADER), 1, stream);
		//=========================================================
		RGBTRIPLE *pixel = new RGBTRIPLE[pixelCnt];
		for (int i = 0; i < pixelCnt; i++)
		{
			long c = data[i];
			pixel[i].rgbtRed = getR(c);
			pixel[i].rgbtGreen = getG(c);
			pixel[i].rgbtBlue = getB(c);
		}
		for (int j = 0; j < height; j++)
		{
			fwrite(&(pixel[j * width]), sizeof(RGBTRIPLE), width, stream);
			fseek(stream, padding, SEEK_CUR);
		}
		fclose(stream);
	}
}

long *FileBmp::resizeBmp(
	long *data, int width, int height, int newWidth, int newHeight
	)
{
	if (newWidth != width || newHeight != height)
	{
		long *result = new long[newWidth * newHeight];
		for (int y = 0; y < newHeight; y++)
			for (int x = 0; x < newWidth; x++)
			{
				int srcX = map_linear(x, 0, newWidth, 0, width);
				int srcY = map_linear(y, 0, newHeight, 0, height);
				result[y * newWidth + x] = data[srcY * width + srcX];
			}
		return result;
	}
	return NULL;
}