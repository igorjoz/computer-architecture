.686
.model flat

extern	_ExitProcess@4			: PROC

public _main

.data


.code
_main PROC

	MOV EAX, 12345678h
	MOV AX, 0
	MOV AL, 3
	MOV AH, 7

	ADD AL, 1
	ADD AH, 1
	ADD AX, 1
	ADD EAX, 1

	SUB AL, 1
	SUB AH, 1
	SUB AX, 1
	SUB EAX, 1

	MOV EDX, 12345678h
	MOV DX, 3
	MOV DL, 4
	MOV DH, 2

	MUL DL

	DIV DH

	MOV AX, 9321h

	MUL DX

	MOV EAX, 91111111h

	MOV EDX, 2h

	MUL EDX

	ADD ESP , 12 ; usuniecie parametrów ze stosu
	PUSH 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	CALL _ExitProcess@4 ; zakończenie programu

_main ENDP
END