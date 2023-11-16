.686
.model flat

extern	__read			: PROC
extern _ExitProcess@4	: PROC

.data
	buffer				db	12 dup (?)
	multiplier			dd	10
	converted_number	dd	0

public _main

.code
wczytaj_do_EAX PROC
	push ebx
	push ecx

	mov eax, 0
	mov ebx, OFFSET buffer

pobieraj_znaki:
	mov cl, [ebx]
	inc ebx
	cmp cl, 10
	je byl_enter
	sub cl, 30H
	movzx ecx, cl

	mul DWORD PTR multiplier
	add eax, ecx
	jmp pobieraj_znaki

byl_enter:
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

_main PROC
	push DWORD PTR 12
	push DWORD PTR OFFSET buffer
	push DWORD PTR 0
	call __read
	add esp, 12

	call wczytaj_do_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END