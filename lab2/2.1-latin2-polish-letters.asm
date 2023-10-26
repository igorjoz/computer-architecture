.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)

public _main

.data

; zmiany, aby wyświetlały się polskie znaki
tekst db 'Nazywam sie Igor J', 162, 'zefowicz' , 10
db 'M', 162, 'j pierwszy 32-bitowy program '
db 'asemblerowy dzia', 136, 'a ju', 190, ' poprawnie!', 10
db 'za', 190, 162, 136, 134, ' g', 169, 152, 'l', 165, ' ja', 171, 228, 10

.code
_main PROC
	mov ecx, 112 ; liczba znaków wyświetlanego tekstu

	; wywołanie funkcji ”write” z biblioteki języka C
	push ecx ; liczba znaków wyświetlanego tekstu
	push dword PTR OFFSET tekst ; położenie obszaru
	; ze znakami
	push dword PTR 1 ; uchwyt urządzenia wyjściowego
	call __write ; wyświetlenie znaków
	; (dwa znaki podkreślenia _ )

	add esp, 12 ; usunięcie parametrów ze stosu
	; zakończenie wykonywania programu
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END