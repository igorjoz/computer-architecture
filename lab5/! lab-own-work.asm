.686
.model flat

extern _malloc : PROC

.code
_diagonal PROC
	push ebp
	mov ebp, esp
	sub esp, 4
	push ebx
	push esi
	push edi

	; [ebp + 8]		; adres tablicy A
	; [ebp + 12]	; adres tablicy V
	; na macierz n x n potrzeba n * n * 4
	mov eax, [ebp + 16] ; n
	mov ebx, [ebp + 16] ; n
	mul ebx

	; przechowanie wyniku n * n w rejestrze ebx
	mov ebx, eax
	lea eax, [eax * 4]
	

	; teraz w eax jest ilość potrzebnych bajtów do zarezerowania
	push eax
	call _malloc				; rezerwuję n * n * 4 bajtów na wynikową tablicę floatów (*4)
	add esp, 4

	; edi	-> adres wynikowej tablicy
	mov edi, eax				
								; [ebp+8]	-> adres tablicy A
								; [ebp+12]	-> adres tablicy B
	; esi	-> indeks w wynikowej tablicy
	xor esi, esi		; wyzerowanie esi


	;mov ecx, [ebp+16]	
	;mov eax, [ebp+24]
	;mul ecx				
	;mov	[ebp - 4], eax			; ebp-4	-> liczba okrazen 2 petli = k*m
	;mov ecx, [ebp + 24]			; ecx = m	-> liczba okrazen wewnetrznej petli



	; przpisz do tablicy wynikowej wartości z tablicy A
	;push esi
	;push edi
	;push eax

	;mov esi, [ebp + 8] ; adres tablicy A
	;mov edi, [ebp + 12] ; adres tablicy B
	;mov eax, 0
	;mov ecx, ebx ; liczba okrążeń; dla 3 x 3 to 9
	;petla1:
	;	mov edx, [esi + 8*eax] ; ładuję do edx wartość z tablicy A
	;	mov [edi + 4*eax], edx ; zapisanie wartości z tablicy A do tablicy wynikowej
	;	inc eax
	;loop petla1

	;pop esi
	;pop edi
	;pop eax


	;mov ecx, ebx ; całkowita liczba okrążeń; dla 3 x 3 to 9
	mov ecx, [ebp + 16] ; liczba iteracji ; dla 3 x 3 to 3 -> zawsze n



	; PĘTLE

	mov ebx, 0
	mov esi, [ebp + 16] ; n

	mov eax, 0

	petla2:
		push ecx
		mov ecx, 0

		mov esi, [ebp + 16] ; n
		mov eax, 0
		add eax, ebx
		mul esi
		add eax, ebx

		mov ecx, eax

		; pierwsza tablica A
		mov esi, [ebp + 8] ; adres tablicy A
		;mov edx, [ebp+8]
		lea edx, [esi + 8*eax]

		fld qword ptr [edx] ; ładuję do st0 wartość z tablicy A

		; druga tablica B
		mov esi, [ebp + 12] ; adres drugiej tablicy V
		lea edx, [esi + 8*ebx]

		fld qword ptr [edx] ; ładuję do st1 wartość z tablicy V

		fadd st(0), st(1) ; dodanie odpowiedniego z A i V

		; wynik do tablicy
		;mov esi, [ebp + 8] ; adres tablicy A
		;lea edx, [esi + 8*eax]
		;fstp qword ptr [edi + 4*eax] ; zapisanie wyniku do tablicy wynikowej

		; zapis wyniku do tablicy A
		mov esi, [ebp + 8] ; adres tablicy A
		lea edx, [esi + 8*eax]
		fstp qword ptr [edx] ; zapisanie wyniku do tablicy wynikowej

		; zapisanie wyniku do tablicy wynikowej
		;fstp qword ptr [edi + 4*eax] ; zapisanie wyniku do tablicy wynikowej

		inc ebx

		pop ecx

	loop petla2

	mov eax, edi	; adres wynikowej tablicy do eax (wartość zwracana przez funkcję)
	;mov eax, [ebp + 8]

	pop edi
	pop esi
	pop ebx
	add esp, 4
	pop ebp
	ret
_diagonal ENDP
END