.686
.model flat

extern	_ExitProcess@4			: PROC

public _main

.data

.code
_main PROC
	mov ecx, 13 ; ilość znaków do wyświetlenia

	mov eax, 0 ; początkowa wartość sumy
	mov ebx, 3 ; pierwszy element ciągu
	mov ecx, 5 ; liczba obiegów pętli

	ptl: add eax, ebx ; dodanie kolejnego elementu
		add ebx, 2 ; obliczenie następnego elementu
		sub ecx, 1 ; zmniejszenie licznka obiegów pętli
		jnz ptl ; skok, gdy licznik obiegów różny od 0


	add esp, 12 ; usuniecie parametrów ze stosu
	push 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	call _ExitProcess@4 ; zakończenie programu

_main ENDP
END
