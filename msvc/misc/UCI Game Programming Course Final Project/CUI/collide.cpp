#include "collide.h"

int bTri[12][3];

void initTriDef()
{
	//================================================
	bTri[0][0] = 0; bTri[0][1] = 6; bTri[0][2] = 4;
	bTri[1][0] = 0; bTri[1][1] = 4; bTri[1][2] = 5;
	bTri[2][0] = 5; bTri[2][1] = 4; bTri[2][2] = 1;
	bTri[3][0] = 5; bTri[3][1] = 1; bTri[3][2] = 3;
	bTri[4][0] = 3; bTri[4][1] = 1; bTri[4][2] = 2;
	bTri[5][0] = 3; bTri[5][1] = 2; bTri[5][2] = 7;
	bTri[6][0] = 7; bTri[6][1] = 2; bTri[6][2] = 6;
	bTri[7][0] = 7; bTri[7][1] = 6; bTri[7][2] = 0;
	//================================================
	bTri[8][0] = 7; bTri[8][1] = 0; bTri[8][2] = 5;
	bTri[9][0] = 7; bTri[9][1] = 5; bTri[9][2] = 3;
	bTri[10][0] = 6; bTri[10][1] = 2; bTri[10][2] = 1;
	bTri[11][0] = 6; bTri[11][1] = 1; bTri[11][2] = 4;
	//================================================
}

bool collide(float **boxA, float **boxB)
{
	long i;
	long j;
	bool result;

	result = false;
	for(i = 0; i < 12; i++)
	{
		for( j = 0; j < 12; j++ )
		{
			if
				(
					triSect(
						boxA[bTri[i][0]], boxA[bTri[i][1]], boxA[bTri[i][2]],
						boxB[bTri[j][0]], boxB[bTri[j][1]], boxB[bTri[j][2]]
					) == 1
				)
					result = true;
		}
	}
	return result;
}