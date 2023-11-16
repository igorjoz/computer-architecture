.686
.model flat

extern	__read			: PROC
extern	__write			: PROC
extern _ExitProcess@4	: PROC

.data
	znaki db 12 dup (?)
	multiplier			dd	10
	converted_number	dd	0

public _main

.code
wczytaj_do_EAX PROC
	push ebx
	push ecx

	mov eax, 0
	mov ebx, OFFSET znaki

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

wyswietl_EAX PROC
	pusha

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10

	konwersja:
	mov edx, 0 ; zerowanie starszej części dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy

	; wypełnienie pozostałych bajtów spacjami i wpisanie znaków nowego wiersza
	wypeln:
	or esi, esi
	jz wyswietl ; skok, gdy ESI = 0
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln

	wyswietl:
	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza
	; wyświetlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyświetlanych znaków
	push dword PTR OFFSET znaki ; adres wyśw. obszaru
	push dword PTR 1; numer urządzenia (ekran ma numer 1)
	call __write ; wyświetlenie liczby na ekranie
	add esp, 12 ; usunięcie parametrów ze stosu

	popa
	ret
wyswietl_EAX ENDP

_main PROC
	push DWORD PTR 12
	push DWORD PTR OFFSET znaki
	push DWORD PTR 0
	call __read
	add esp, 12

	call wczytaj_do_EAX
	mul eax
	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END