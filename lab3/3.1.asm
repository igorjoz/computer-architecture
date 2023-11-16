.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	znaki db 12 dup (?)

.code
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

	;mov eax, 1234
	;call wyswietl_EAX


	mov eax, 1
	mov ebx, 0
	mov esi, 50

	numbers:
		add eax, ebx
		inc ebx
		call wyswietl_EAX
		dec esi
		jnz numbers


	push 0
	call _ExitProcess@4
_main ENDP
END