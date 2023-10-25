; Hello world program - MASM, x86 (32 bit) version

.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC ; dwa znaki podkreślenia przed nazwą funkcji z C

public _main

.data
	; deklaracja zmiennej text
	text db 'Hello world!', 10 ; 10 - znak nowej linii
	db 10, 'Nazywam sie Igor Jozefowicz' , 10
	db 'Moj pierwszy 32-bitowy program '
	db 'asemblerowy dziala juz poprawnie!', 10

.code
	_main PROC ; rozpoczęcie wykonywania funkcji main

	mov ecx, 107 ; liczba znaków wyświetlanego tekstu

	; 3 instrukcje push poniżej - podanie argumentów funkcji write
	push ecx ; liczba znaków wyświetlanego tekstu
	push dword PTR OFFSET text ; położenie obszaru ze znakami
	push dword PTR 1 ; uchwyt urządzenia wyjściowego
	call __write ; wywołanie funkcji write, wyświetlenie znaków, dwa znaki podkreślenia

	add esp, 12 ; usunięcie parametrów ze stosu

	; zakończenie wykonywania programu
	push dword PTR 0 ; 0 - kod powrotu programu; rozkaz push - podanie argumentu funkcji _ExitProcess@4
	call _ExitProcess@4 ; wyjście z procesu

	_main ENDP ; zakończenie wykonywania funkcji main
END