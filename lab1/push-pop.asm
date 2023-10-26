.686
.model flat

extern	_ExitProcess@4			: PROC

public _main

.data


.code
_main PROC

	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 0
	MOV EDX, 0

	MOV EAX, 12345678h
	MOV EBX, 87654321h

	PUSH AX
	PUSH EBX
	PUSH EAX

	POP EDX
	POP ECX
	POP BX

	ADD ESP , 12 ; usuniecie parametrów ze stosu
	PUSH 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	CALL _ExitProcess@4 ; zakończenie programu

_main ENDP
END