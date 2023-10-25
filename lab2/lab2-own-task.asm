; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern	_SetConsoleOutputCP@4	: PROC
extern	_ExitProcess@4			: PROC
extern	__write					: PROC	; (dwa znaki podkreślenia)
extern	__read					: PROC	; (dwa znaki podkreślenia)
extern	_MessageBoxW@16			: PROC

public _main



.data
tekst_pocz		db 10, 'Prosz',169,' napisa',134,' jaki',152,' tekst '
				db 'i nacisna',134,' Enter', 10

koniec_t		db ?

magazyn			db 80 dup (?)

magazyn_unicode dw 80 dup (?)

nowa_linia		db 10

liczba_znakow	dd ?

naglowek		dw 'N','a','g','l','o','w','e','k',0


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
	mov eax, 0
	;mov esi, 0 ; INDEKS POCZĄTKOWY PĘTLI, KTÓRA MA SIĘ WYKONYWAĆ 4 RAZY; AKTUALNY INDEKS PRZECHOWUJE REJESTR ESI

	; PIERWSZA PACZKA 4 LITER
	; CZĘŚĆ PTL
	mov dl, magazyn[ebx]
	mov dh, magazyn[ebx+3]
	bswap edx
	mov dh, magazyn[ebx+1]
	mov dh, magazyn[ebx+2]
	bswap edx
	
	;mov esi, magazyn[ebx]
	mov magazyn_unicode[eax], dx

	; część DALEJ
	inc ebx											; inkrementacja indeksu
	;inc esi ; INKREMENTACJA REJESTRU ESI - PRZEJŚCIE PĘTLI
	add eax,2 ; kolejny znak (są 2-bajtowe)
	dec ecx

ptl: 
	;mov dl, magazyn[ebx]							; pobranie kolejnego znaku
	mov dl, magazyn[ebx+4]							; przejście 4 znaki dalej i pobranie kolejnego znaku

	;cmp dl, 'a'
	;jb nieznany_znak								; skok, gdy znak nie wymaga zamiany
	;cmp dl, 0A5H
	;je duze_A
	;cmp dl, 086H

	;sub dl, 20H										; zamiana na wielkie litery
	mov magazyn_unicode[eax], dx					; odesłanie znaku do pamięci
	jmp dalej


;duze_A:
;	mov magazyn_unicode[eax], 0104H
;	jmp dalej


dalej: 
	;inc ebx											; inkrementacja indeksu
	add ebx,4											; inkrementacja indeksu
	;inc esi ; INKREMENTACJA REJESTRU ESI - PRZEJŚCIE PĘTLI
	add eax,2 ; kolejny znak (są 2-bajtowe)
	dec ecx											; sterowanie pętlą
	jnz ptl
													; wyświetlenie przekształconego tekstu
	push 0
	push OFFSET naglowek
	push OFFSET magazyn_unicode
	push 0
	call _MessageBoxW@16
	
	add esp, 16										; usuniecie parametrów ze stosu
	push 0
	call _ExitProcess@4								; zakończenie programu
_main ENDP
END