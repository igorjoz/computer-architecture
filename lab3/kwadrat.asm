.686
.model flat

public _main
extern _ExitProcess@4 : PROC

; obszar danych programu
.data

; obszar instrukcji (rozkazów) programu
.code

; y - x^2 + 1
kwadrat PROC
	push eax
	push edx

	mov eax, esi
	mul esi
	mov edi, eax
	add edi, 1

	pop edx
	pop eax

	ret
kwadrat ENDP

_main PROC

	; wywołanie funkcji
	mov esi, 8
	call kwadrat
	
	; zakończenie programu
	push 0
	call _ExitProcess@4

_main ENDP
END
