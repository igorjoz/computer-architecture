.686
.model flat
.xmm

.code
_uint48_float PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	finit

	mov eax, [ebp+8]
	mov edx, [ebp+12]
	and edx, 0000ffffh

	xor ebx, ebx
	xor ecx, ecx

ptl:
	clc
	rcr edx, 1
	rcr eax, 1
	rcr ecx, 1
	inc ebx
	cmp eax, 1
	jne ptl
	cmp edx, 0
	jne ptl				; w ebx mamy liczbe przesuniec, w ecx mantyse
	add ebx, 127-16		; dodaje bias uwzgledniajac format stalo przecinkowy (stad - 16)
	shl ebx, 23			; przesuwam wykladnik o 23 miejsca w lewo zeby byl zgodnie z formatem float
	xor eax, eax		; w eax bede mial wynik
	shr ecx, 32-23		; przesuwam mantyse o 9 miejsc w prawo zeby byl zgodnie z formatem float
	or eax, ebx			
	or eax, ecx			; nakladam wykladnik z mantysa
	push eax
	fld dword ptr [esp]
	add esp, 4			; wrzucam wynika na koprocesor
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_uint48_float ENDP

END