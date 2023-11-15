.686
.model flat

public _main
extern _ExitProcess@4 : PROC

; obszar danych programu
.data
	digit db 5
	num dw 12
	num2 dd 30
	num3 dq 35

	tablica dw 3, 5, 7

; obszar instrukcji (rozkazów) programu
.code

_main PROC

	;mov eax, 5
	;mov edi, 3
	;sub eax, edi

	mov ebx, offset tablica ; pobierz adres tablicy
	mov ax, tablica ; wstaw do ax pierwszy element tablicy
	mov word ptr [ebx], 0 ; wstaw do pierwszego elementu tablicy 0 (było 3)

	mov eax, 10
	mov bl, digit
	movzx eax, bl ; rozszerzenie znaku do 32 bitów

	mov eax, 15
	sub eax, dword ptr num

	mov eax, 40
	sub eax, num2

	mov eax, 50
	sub eax, dword PTR num3
	
	; zakończenie programu
	push 0
	call _ExitProcess@4

_main ENDP
END
