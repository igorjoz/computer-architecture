#include <stdio.h>

extern float harmonic_mean(float *tablica, unsigned int n);

int main()
{
	float nums[3] = { 0.5, 0.2, 1.2 };

	float average = harmonic_mean(nums, 3);

	printf("Harmonic average: %f\n", average);

	return 0;
}