#include "triangle.h"

long pMax(long a, long b, long c)
{
	if (b > a) a = b;
	if (c > a) a = c;
	return a;
}

long pMin(long a, long b, long c)
{
	if (b < a) a = b;
	if (c < a) a = c;
	return a;
}

void scanline(surface *pSurface, long y, long x1, long x2, long color)
{
	long x;
	long incre;

	incre = ((x2 - x1) >= 0 ? 1 : -1);
	for (x = x1; x != x2; x += incre)
		pSurface->drawPixel(x, y, color);
	pSurface->drawPixel(x2, y, color);
}

void drawTriangleEx(surface *pSurface, long x1, long y1, long x2, long y2, long x3, long y3, long color)
{
	long y;
	long max_x, max_y, min_x, min_y, mid_x, mid_y;
	float x_long, x_short, dx_long, dx_short;

	// locate top vertex
	max_y = pMax(y1, y2, y3);
	if (max_y == y1) max_x = x1;
	if (max_y == y2) max_x = x2;
	if (max_y == y3) max_x = x3;

	// locate bottom vertex
	min_y = pMin(y1, y2, y3);
	if (min_y == y1) min_x = x1;
	if (min_y == y2) min_x = x2;
	if (min_y == y3) min_x = x3;

	// if horizontal line
	if (max_y == min_y)
	{
		// draw line between end-points
		max_x = pMax(x1, x2, x3);
		min_x = pMin(x1, x2, x3);
		scanline(pSurface, max_y, min_x, max_x, color);
	}
	// if triangle
	else
	{
		// locate middle vertex
		if (y1 != max_y && y1 != min_y)
		{
			mid_x = x1;
			mid_y = y1;
		}
		else if (y2 != max_y && y2 != min_y)
		{
			mid_x = x2;
			mid_y = y2;
		}
		else if (y3 != max_y && y3 != min_y)
		{
			mid_x = x3;
			mid_y = y3;
		}
		// if no middle vertex
		else
		{
			// locate stray vertex (neither max nor min)
			if (y1 == y2)
			{
				mid_y = y1;
				if ((max_x == x1 && max_y == y1) || (min_x == x1 && min_y == y1))
					mid_x = x2;
				else
					mid_x = x1;
			}
			else if (y2 == y3)
			{
				mid_y = y2;
				if ((max_x == x2 && max_y == y2) || (min_x == x2 && min_y == y2))
					mid_x = x3;
				else
					mid_x = x2;
			}
			else
			{
				mid_y = y3;
				if ((max_x == x3 && max_y == y3) || (min_x == x3 && min_y == y3))
					mid_x = x1;
				else
					mid_x = x3;
			}
		}

		// draw top sub-triangle (from top to bottom)
		if (max_y > mid_y)
		{
			// calculate edge slopes
			dx_long = (float) (min_x - max_x) / (max_y - min_y);
			dx_short = (float) (mid_x - max_x) / (max_y - mid_y);

			// draw region between edges
			x_long = (float) max_x;
			x_short = (float) max_x;
			for (y = max_y; y > mid_y; y--)
			{
				scanline(pSurface, y, (long) x_long, (long) x_short, color);
				x_long += dx_long;
				x_short += dx_short;
			}
		}

		// draw bottom sub-triangle (from the bottom up)
		if (mid_y > min_y)
		{
			// calculate edge slopes
			dx_long = (float) (max_x - min_x) / (max_y - min_y);
			dx_short = (float) (mid_x - min_x) / (mid_y - min_y);

			// draw region between edges
			x_long = (float) min_x;
			x_short = (float) min_x;
			for (y = min_y; y < mid_y; y++)
			{
				scanline(pSurface, y, (long) x_long, (long) x_short, color);
				x_long += dx_long;
				x_short += dx_short;
			}
		}

		// draw triangle split-line (needs at least one sub-triangle)
		scanline(pSurface, y, (long) x_long, (long) x_short, color);
	}
}
