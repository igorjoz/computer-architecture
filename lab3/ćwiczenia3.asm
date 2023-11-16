.686
.model flat

extern	_ExitProcess@4 : PROC
extern __write : PROC


.data
	text db "test", 10

.code
_main PROC

	mov eax, 1234h
	shl eax, 2

	mov eax, 1234h
	mov cl, 2
	shl eax, cl

	mov eax, 1234h
	mov bl, 2
	shl eax, bl


	mov eax, 1234h
	xor eax, eax

	MOV AL, 92h     ; AL = 1001 0010
	CLC             ; Clear CF (CF = 0)
	;RCL AL, 1       ; Rotate left by 1 bit
	ROL AL, 1       ; Rotate left by 1 bit

	MOV AL, 92h     ; AL = 1001 0010
	STC             ; Set CF (CF = 1)
	;RCR AL, 1       ; Rotate right by 1 bit
	ROR AL, 1       ; Rotate right by 1 bit

	push 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	call _ExitProcess@4 ; zakończenie programu

_main ENDP

END