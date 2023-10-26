.686
.model flat

extern _ExitProcess@4: PROC
extern __write: PROC
extern __read:PROC
extern _MessageBoxA@16: PROC
extern _MessageBoxW@16: PROC

public _main

.data
	storage db 100 dup(?)
	first_name db 50 dup(0) ; zmienna na imię
	surname db 50 dup(0) ; zmienna na naziwsko
	first_name2 db 50 dup(0)
	characters_quantitty dd ?

	latin2 db 0A5H,086H,0A9H,088H,0E4H,0A2H,098H,0ABH,0BEH, 0A4H,08FH,0A8H,09DH,0E3H,0E0H,097H,08DH,0BDH ; db - byte
	unicode dw 0105H,0107H,0119H,0142H,0144H,00F3H,015BH,017AH,017CH, 0104H,0106H,0118H,0141H,0143H,00D3H,015AH,0179H,017BH ; dw - double word
	
	window_title dw 'T','e','k','s','t',' ','w',' '
	dw 'f','o','r','m','a','c','i','e',' '
	dw 'U','T','F','-','1','6',  0
	unicode_storage db 80 dup(0)
	;magazyn_Unicode dw 'K','a', 017CH, 'd','y',' ','z','n','a','k',' '
	;dw 'z','a','j','m','u','j','e',' '
	;dw '1','6',' ','b','i','t', 00F3H, 'w', 0

.code
_main PROC
	; podanie 3 argumentów funkcji read
	push 80
	push OFFSET storage
	push 0
	; wywołanie funkcji read (bierze ze stosu 3 argumenty)
	call __read

	add esp, 12
	mov characters_quantitty,eax
	mov ecx, characters_quantitty
	dec ecx
	mov esi, OFFSET storage
	mov edi, OFFSET first_name

	lp:
		mov dl, [esi]
		cmp dl, 20h ; 20h - znak spacji; sprawdzenie, czy znalazłem znak spacji
		je read_surname ; jeśli spacja znaleziona, to najpierw wypisuję nazwisko
		mov [edi], dl
		inc edi ; zwiększ licznik
		jmp continue ; kontynuuj pętle, jeśli jeszcze nie znaleziono nazwiska

	read_surname:
			mov [edi], BYTE PTR 0Ah ; 0Ah -> LF, Line Feed
			mov edi, OFFSET surname

	; pętla kontynuująca wczytywanie znaku; zwiększa licznik
	continue:
			inc esi
			loop lp

	; wypisanie w konsoli nazwiska
	mov [edi], BYTE PTR 20h ; 20 - znak spacji
	mov ecx, (OFFSET first_name2 - OFFSET surname)

	; podanie 3 argumentów do funkcji __write
	push ecx
	push OFFSET surname
	push 1
	call __write ; wywołanie funkcji z C
	add esp, 12 ; wyzerowanie stosu

	; wypisanie na ekranie imienia
	mov ecx, (OFFSET surname - OFFSET first_name)

	; podanie 3 argumentów do funkcji __write
	push ecx
	push OFFSET first_name
	push 1
	call __write ; wywołanie funkcji z C
	add esp, 12 ; wyzerowanie stosu

	mov esi,0

	; =====================

	; przygotowanie unicode_storage do wypisania nazwiska
	; zamiana z latin2 na utf-16: nazwisko
	mov esi, OFFSET surname
	mov edi, 0

	lp2:
		mov dl, [esi]
		mov eax, 0

	polish_characters_2:
		cmp dl, latin2[eax]
		jne next2
		mov dx, unicode[eax*2]
		mov unicode_storage[edi*2], dl
		mov unicode_storage[edi*2+1], dh
		jmp jump2

	next2:
		inc eax
		cmp eax, 18
		jne polish_characters_2

	jump2:
		mov unicode_storage[edi*2], dl
		inc edi

	continue2:
			inc esi
			cmp [esi], BYTE PTR 0
			jne lp2

	; przygotowanie unicode_storage do wypisania imienia
	; zamiana z latin2 na utf-16: imie
	mov esi, OFFSET first_name

	lp3:
		mov dl, [esi]
		mov eax, 0

	polish_characters_3:
		cmp dl, latin2[eax]
		jne next3
		mov dx, unicode[eax*2]
		mov unicode_storage[edi*2],dl
		mov unicode_storage[edi*2+1],dh
		jmp jump3

	next3:
		inc eax
		cmp eax, 18
		jne polish_characters_3

	jump3:
		mov unicode_storage[edi*2], dl
		inc edi

	continue3:
		inc esi
		cmp [esi], BYTE PTR 0
		jne lp3

	; ==========================

	; wypisanie tekstu na ekranie w formie MessageBoxW@16
	push 0
	push OFFSET window_title ; tytuł okna
	push OFFSET unicode_storage ; zawartość okna
	push 0
	; wywołanie funkcji MessageBoxW@16 - W, czyli wersja Wide Character, UTF-16
	call _MessageBoxW@16

	; zakończenie programu
	push 0 ; kod wyjścia z konsoli - 0 - OK
	call _ExitProcess@4
_main ENDP
END