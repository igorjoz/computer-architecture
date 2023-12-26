#include<stdio.h>
#include<Windows.h>

extern int env_rozmiar(wchar_t* nazwa);

int main() {
	const int max_rozmiar = 256;
	wchar_t* nazwa = (wchar_t*) malloc(256*sizeof(wchar_t));
	if (nazwa == NULL)
		return 1;
	fgetws(nazwa, max_rozmiar, stdin);
	printf("rozmiar $%ws = %d", nazwa, env_rozmiar(nazwa));
	free(nazwa);
}