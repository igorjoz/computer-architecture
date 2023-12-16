.686
.XMM
.model flat

public _szybki_max

.code
_szybki_max PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov esi, [ebp+8] ; tablica 1
	mov ebx, [ebp+12] ; tablica 2
	mov edi, [ebp+16] ; tablica wynikowa
	mov ecx, [ebp+20] ; licznik petli

	xor eax, eax ; iterator input-output

	petla:
		movups xmm0, [esi+8*eax]
		movups xmm1, [ebx+8*eax]
		pmaxsd xmm0, xmm1
		movups [edi+8*eax], xmm0
		add eax, 2
	loop petla

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_szybki_max ENDP
END
