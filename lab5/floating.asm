.686
.model flat

extern	_ExitProcess@4			: PROC

public _main

.data
	num dd 0.125
	num2 dd 0.25
	num3 dd 0.5

.code
_main PROC
	add esp, 12 ; usuniecie parametrów ze stosu

	mov esi, OFFSET num3

	fld num2
	fld num
	fadd ST(0), ST(1)

	fld num
	fsub st(2) , st(0)
	fsub dword PTR [esi]


	;fmul st(1), st(0)
	;fstp st(0)

	;fmulp st(1), st(0)

	fmul




	push 0 ; kod wyjścia z programu - 0 - OK, brak błędów
	call _ExitProcess@4 ; zakończenie programu

_main ENDP
END
