.686
.model flat

extern	_ExitProcess@4			: PROC
extern	__write					: PROC	; (dwa znaki podkreślenia)

public _main

.data
	text db "Hello world!", 10
	; 10 - znak nowej linii

.code
_main PROC
	mov ecx, 13 ; ilość znaków do wyświetlenia

	push ecx ; wrzucenie na stos ilości znaków do wyświetlenia
	push offset text ; adres obszaru z tekstem
	push dword PTR 1 ; uchwyt do standardowego wyjścia

	call __write ; wywołanie funkcji __write
	; funkcja __write bierze 3 parametry ze stosu
	; odwrotna kolejność do wrzucania na stos
	; __write(uchwyt: 1, string: text, length: 13);

	add esp, 12 ; usuniecie parametrów ze stosu
	push 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	call _ExitProcess@4 ; zakończenie programu

_main ENDP
END
