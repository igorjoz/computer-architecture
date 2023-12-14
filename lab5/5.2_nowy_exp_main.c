#include <stdio.h>

extern float nowy_exp(float num);

int main()
{
	float num = 1;
	float result = nowy_exp(num);

	printf("Result: %f\n", result);

	return 0;
}