#include <stdio.h>

extern float arithmetic_mean(float *tablica, unsigned int n);

int main()
{
	float nums[4] = { 1.5, 2.5, 3.7, 4.555 };

	float average = arithmetic_mean(nums, 4);

	printf("Arithmetic average: %f\n", average);

	return 0;
}