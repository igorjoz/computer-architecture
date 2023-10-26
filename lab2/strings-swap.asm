.686
.model flat

extern _ExitProcess@4: PROC
extern __write: PROC
extern __read:PROC
extern _MessageBoxA@16: PROC
extern _MessageBoxW@16: PROC

public _main

.data
	magazyn db 80 dup(?)
	imie db 40 dup(0)
	nazwisko db 40 dup(0)
	imie_big db 40 dup(0)
	liczba_znakow dd ?

.code
_main PROC
	push 80
	push OFFSET magazyn
	push 0
	call __read
	add esp, 12
	mov liczba_znakow, eax
	mov ecx,liczba_znakow
	dec ecx
	mov esi, OFFSET magazyn
	mov edi, OFFSET imie

	ptl:	mov dl,[esi]
			cmp dl,20h
			je wpisuj_nazwisko
			mov [edi],dl
			inc edi
			jmp continue

	wpisuj_nazwisko:
			mov [edi],BYTE PTR 0Ah
			mov edi, OFFSET nazwisko

	continue:
			inc esi
			loop ptl

	mov [edi],BYTE PTR 20h
	mov ecx, (OFFSET imie_big - OFFSET nazwisko)
	push ecx
	push OFFSET nazwisko
	push 1
	call __write
	add esp,12

	mov ecx, (OFFSET nazwisko - OFFSET imie)
	push ecx
	push OFFSET imie
	push 1
	call __write
	add esp,12

	mov esi,0

	push 0
	call _ExitProcess@4
_main ENDP
END