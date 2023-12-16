#include <stdio.h>

#define CONST 8

void szybki_max(int t_1[], int t_2[], int t_wynik[], int n);

int main() {
	int tab1[CONST] = { 1, 2, 3, 4, 5, -6, 7, 8 };
	int tab2[CONST] = { -2, 1, 4, -3, 6, 5, 8, 9 };
	int tab_wynik[CONST];

	for (int i = 0; i < CONST; i++) {
		printf("%d :", tab1[i]);
	}
	printf("\n");

	for (int i = 0; i < CONST; i++) {
		printf("%d :", tab2[i]);
	}
	printf("\n");

	szybki_max(tab1, tab2, tab_wynik, CONST / 4);

	for (int i = 0; i < CONST; i++) {
		printf("%d :", tab_wynik[i]);
	}

	return 0;
}
