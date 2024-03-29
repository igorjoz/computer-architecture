#include <stdio.h>

float *diagonal(double *A, int *V, int n);

int main()
{
	/*int n = 3;
	double A[] = {
		1.0, 2.0, 3.0,
		4.0, 5.0, 6.0,
		7.0, 8.0, 9.0,
	};*/

	/*int n = 4;
	double A[] = {
		1.0, 2.0, 3.0, 4.0,
		5.0, 6.0, 7.0, 8.0,
		9.0, 10.0, 11.0, 12.0,
		13.0, 14.0, 15.0, 16.0,
	};*/

	int n = 5;
	double A[] = {
		1.0, 2.0, 3.0, 4.0, 5.0,
		6.0, 7.0, 8.0, 9.0, 10.0,
		11.0, 12.0, 13.0, 14.0, 15.0,
		16.0, 17.0, 18.0, 19.0, 20.0,
		21.0, 22.0, 22.0, 23.0, 24.0
	};

	double V[] = { 1.0, 2.0, 3.0 };
	//double V[] = { 1.0, 2.0, 3.0, 4.0 };
	//double V[] = { 1.0, 2.0, 3.0, 4.0, 5.0 };

	float* wynik = diagonal(A, V, n);

	for (int i = 0; i < n * n; i++)
	{
		printf("%f\t", A[i]);

		if ((i + 1) % n == 0) {
			printf("\n");
		}
	}

	return 0;
}