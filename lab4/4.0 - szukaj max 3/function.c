#include <stdio.h>

int szukaj_max(int a, int b, int c);

int main()
{
	int x, y, z, wynik;

	printf("\nProszę podać trzy liczby całkowite ze znakiem: ");
	scanf_s("%d %d %d", &x, &y, &z, 32);

	wynik = szukaj_max(x, y, z);
	printf("\nSpośród podanych liczb %d, %d, %d, liczba %d jest największa\n", x, y, z, wynik);

	return 0;
}
