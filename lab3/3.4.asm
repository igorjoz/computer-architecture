.686
.model flat

extern	__read			: PROC
extern	__write			: PROC
extern _ExitProcess@4	: PROC

.data
	znaki db 12 dup (?)
	multiplier			dd	10
	converted_number	dd	0
	dekoder db '0123456789ABCDEF'

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

; wyświetlanie zawartości rejestru EAX w postaci liczby szesnastkowej
wyswietl_EAX_hex PROC
	pusha ; przechowanie rejestrów

	; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie rejestru ESP) przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych wyświetlanej liczby
	sub esp, 12
	mov edi, esp ; adres zarezerwowanego obszaru pamięci

	; przygotowanie konwersji
	mov ecx, 8 ; liczba obiegów pętli konwersji
	mov esi, 1 ; indeks początkowy używany przy zapisie cyfr

	; pętla konwersji
	ptl3hex:
	; przesunięcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
	; w szczególności, w pierwszym obiegu pętli bity nr 31 - 28
	; rejestru EAX zostaną przesunięte na pozycje 3 - 0
	rol eax, 4
	; wyodrębnienie 4 najmłodszych bitów i odczytanie z tablicy
	; 'dekoder' odpowiadającej im cyfry w zapisie szesnastkowym
	mov ebx, eax ; kopiowanie EAX do EBX
	and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
	mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
	; przesłanie cyfry do obszaru roboczego
	mov [edi][esi], dl
	inc esi ; inkrementacja modyfikatora
	loop ptl3hex ; sterowanie pętlą

	; wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi][0], 10
	mov byte PTR [edi][9], 10

	; wyświetlenie przygotowanych cyfr
	push 10 ; 8 cyfr + 2 znaki nowego wiersza
	push edi ; adres obszaru roboczego
	push 1 ; nr urządzenia (tu: ekran)
	call __write ; wyświetlenie
	; usunięcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych przez 3 rozkazy push przed rozkazem call i 12 bajtów zarezerwowanych na początku podprogramu
	add esp, 24

	popa ; odtworzenie rejestrów
	ret ; powrót z podprogramu
wyswietl_EAX_hex ENDP

_main PROC
	push DWORD PTR 12
	push DWORD PTR OFFSET znaki
	push DWORD PTR 0
	call __read
	add esp, 12

	call wczytaj_do_EAX
	call wyswietl_EAX_hex

	push 0
	call _ExitProcess@4
_main ENDP
END