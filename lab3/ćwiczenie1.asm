.686;
.model flat

public _main
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC

.data

	text	db 'Alicja szanowna ma kota'
	text2	db 3Ch, 0D8h, 7Bh, 0DFh, 0, 0

	nums dw 0AAh, 0BBh, 0CCh, 0DDh, 0EEh, 0FFh
	numsQuantity dw 6

.code
_main PROC

	;mov ebx, 0h
	;mov ebx, offset nums
	;mov ebx, 123h
	;mov ebx, 012abcdefh

	;xchg bl, bh
	;bswap ebx
	;xchg bl, bh

	;mov eax,  0abcdh

	;mov eax, 0
	;mov ecx, 0

	mov ebx, offset nums
	;mov ax, [ebx]
	;mov ax, [ebx+2]
	;mov ax, [ebx+4]
	;mov ah, [ebx+8]

	mov eax, 0
	mov ecx, 0

	powtarzaj:
		add ax, [ebx+ecx]
		add ecx, 2
		cmp ecx, 6*2
		jne powtarzaj

	;add ax, [ebx+ecx]
	;add ecx, 2
	;add ax, [ebx+ecx]
	;add ecx, 2
	;add ax, [ebx+ecx]
	;add ecx, 2
	;add ax, [ebx+ecx]
	;add ecx, 2
	;add ax, [ebx+ecx]
	;add ecx, 2

	mov ebx, 0

	; load 4 arguments & display message box
	PUSH 0
	PUSH OFFSET text2
	PUSH OFFSET text2
	PUSH 0
	CALL _MessageBoxW@16

	; return 0
	PUSH 0
	CALL _ExitProcess@4

_main ENDP
END
