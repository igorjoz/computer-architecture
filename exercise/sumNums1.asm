.686
.model flat

extern _ExitProcess@4 : PROC

public _main

.data
	;tablica dw 0ah, 0bh, 0ch, 0dh, 0fh
	tablica dw 01h, 02h, 03h, 04h, 05h

.code
_main PROC
	mov eax, 0
	mov ebx, OFFSET tablica

	mov ax, [ebx]
	add ax, [ebx + 2]
	add ax, [ebx + 4]
	add ax, [ebx + 6]
	add ax, [ebx + 8]

	push dword PTR 0
	call _ExitProcess@4
_main ENDP
END