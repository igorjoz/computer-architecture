.686
.model flat

extern _ExitProcess@4 : PROC

public _main

.data
	tablica dw 01h, 02h, 03h, 04h, 05h

.code
_main PROC
	mov eax, 0
	mov ebx, OFFSET tablica
	mov ecx, 5 ; ilość elementów w tablicy
	mov esi, 0 ; index obecnego elementu do dodania

	addLoop:
		add ax, [ebx + 2 * esi]
		add esi, 1
	loop addLoop

	push dword PTR 0
	call _ExitProcess@4
_main ENDP
END