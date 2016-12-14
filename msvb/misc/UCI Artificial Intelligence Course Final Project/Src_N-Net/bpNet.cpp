#include <iostream.h>
#include <math.h>
#include <stdlib.h>

float sigmoid(float x)
{
	return 1 / (1 + (float) exp(-x));
}

float sigmoidPri(float y)
{
	return y * (1 - y);
}

void main()
{
	int i;
	int j;
	int k;
	int n;
	float weight[3][3];
	float vector[3];
	//float sum[3];
	float out[3];
	float error[3];

	/* randomize weights */
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			weight[i][j] = -1 + 2 * ((float) rand() / RAND_MAX);

	/* train */
	for (n = 0; n < 1000; n++)
	{
		for (k = 0; k < 4; k++)
		{
			/* fill training set */
			switch (k)
			{
				case 0: vector[0] = 0; vector[1] = 0; vector[2] = 0; break;
				case 1:	vector[0] = 0; vector[1] = 1; vector[2] = 1; break;
				case 2:	vector[0] = 1; vector[1] = 0; vector[2] = 1; break;
				case 3:	vector[0] = 1; vector[1] = 1; vector[2] = 0; break;
			}

			/* propagate forward */
			out[0] =
				vector[0] * weight[0][0] +
				vector[1] * weight[0][1] +
				1         * weight[0][2];
			out[0] = sigmoid(out[0]);
			out[1] =
				vector[0] * weight[1][0] +
				vector[1] * weight[1][1] +
				1         * weight[1][2];
			out[1] = sigmoid(out[1]);
			out[2] =
				out[0] * weight[2][0] +
				out[1] * weight[2][1] +
				1      * weight[2][2];
			out[2] = sigmoid(out[2]);

			/* propagate backward */
			error[2] = sigmoidPri(out[2]) * (vector[2] - out[2]);
			error[0] = sigmoidPri(out[0]) * (weight[2][0] * error[2]);
			error[1] = sigmoidPri(out[1]) * (weight[2][1] * error[2]);

			/* adjust weights */
			weight[0][0] += vector[0] * error[0];
			weight[0][1] += vector[1] * error[0];
			weight[0][2] += 1         * error[0];
			weight[1][0] += vector[0] * error[1];
			weight[1][1] += vector[1] * error[1];
			weight[1][2] += 1         * error[1];
			weight[2][0] += out[0] * error[2];
			weight[2][1] += out[1] * error[2];
			weight[2][2] += 1      * error[2];
		}
	}

	/* apply */
	for (k = 0; k < 4; k++)
	{
		/* fill testing set */
		switch (k)
		{
			case 0: vector[0] = 0; vector[1] = 0; vector[2] = -1; break;
			case 1:	vector[0] = 0; vector[1] = 1; vector[2] = -1; break;
			case 2:	vector[0] = 1; vector[1] = 0; vector[2] = -1; break;
			case 3:	vector[0] = 1; vector[1] = 1; vector[2] = -1; break;
		}

		/* propagate forward */
		out[0] =
			vector[0] * weight[0][0] +
			vector[1] * weight[0][1] +
			1         * weight[0][2];
		out[0] = sigmoid(out[0]);
		out[1] =
			vector[0] * weight[1][0] +
			vector[1] * weight[1][1] +
			1         * weight[1][2];
		out[1] = sigmoid(out[1]);
		out[2] =
			out[0] * weight[2][0] +
			out[1] * weight[2][1] +
			1      * weight[2][2];
		out[2] = sigmoid(out[2]);

		/* copy solution */
		vector[2] = out[2];
		cout << vector[0] << ", " << vector[1] << ", " << vector[2] << '\n';
	}
}
