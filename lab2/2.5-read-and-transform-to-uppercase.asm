; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern	_SetConsoleOutputCP@4	: PROC
extern	_ExitProcess@4			: PROC
extern	__write					: PROC	; (dwa znaki podkreślenia)
extern	__read					: PROC	; (dwa znaki podkreślenia)

public _main



.data
tekst_pocz	db 10, 'Prosz',169,' napisa',134,' jaki',152,' tekst '
			db 'i nacisna',134,' Enter', 10

koniec_t	db ?

magazyn		db 80 dup (?)

nowa_linia	db 10

liczba_znakow dd ?

tablica_znakow	db 0A5H, 0A4H
				db 086H, 08FH
				db 0A9H, 0A8H
				db 088H, 09DH
				db 0E4H, 0E3H
				db 0A2H, 0E0H
				db 098H, 097H
				db 0ABH, 08DH
				db 0BEH, 0BDH

.code
_main PROC
	push 852
	call _SetConsoleOutputCP@4
	add esp, 4

	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)	; liczba znaków tekstu
	push ecx
	push OFFSET tekst_pocz							; adres tekstu
	push 1											; nr urządzenia (tu: ekran - nr 1)
	call __write									; wyświetlenie tekstu początkowego
	add esp, 12										; usuniecie parametrów ze stosu

													; czytanie wiersza z klawiatury
	push 80											; maksymalna liczba znaków
	push OFFSET magazyn
	push 0											; nr urządzenia (tu: klawiatura - nr 0)
	call __read										; czytanie znaków z klawiatury
	add esp, 12										; usuniecie parametrów ze stosu
													; kody ASCII napisanego tekstu zostały wprowadzone
													; do obszaru 'magazyn'
													; funkcja read wpisuje do rejestru EAX liczbę
													; wprowadzonych znaków
	
	mov liczba_znakow, eax							; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0										; indeks początkowy

ptl: 
	mov dl, magazyn[ebx]							; pobranie kolejnego znaku
	cmp dl, 'a'
	jb dalej										; skok, gdy znak nie wymaga zamiany
	cmp dl, 'z'
	ja polskie_znaki							    ; skok, gdy znak nie wymaga zamiany
	sub dl, 20H										; zamiana na wielkie litery
	mov magazyn[ebx], dl							; odesłanie znaku do pamięci
	jmp dalej


polskie_znaki:
	push eax
	mov eax,ebx
	push ebx
	push ecx
	
	mov ebx,0
	mov ecx,9

polskieZnaki_petla:
	cmp dl,tablica_znakow[ebx]
	je polskie_znaki_znaleziono
	add ebx,2
	dec ecx
	jnz polskieZnaki_petla
	jmp polskie_znaki_nie_znaleziono

polskie_znaki_znaleziono:
	inc ebx
	mov cl,tablica_znakow[ebx]
	mov magazyn[eax],cl

polskie_znaki_nie_znaleziono:
	pop ecx
	pop ebx
	pop eax


dalej: 
	inc ebx											; inkrementacja indeksu
	dec ecx											; sterowanie pętlą
	jnz ptl
			
	push liczba_znakow								
	push OFFSET magazyn
	push 1
	call __write									; wyświetlenie przekształconego tekstu
	add esp, 12										; usuniecie parametrów ze stosu
	push 0
	call _ExitProcess@4								; zakończenie programu
_main ENDP
END