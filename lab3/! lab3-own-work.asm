;Napisać podprogram w asemblerze ‘wyswietl_EAX’, 
;który wyświetli na ekranie zawartość rejestru EDX:EAX w postaci liczby dziesiętnej. 
;Zakładamy, że w rejestrach EDX:EAX znajduje się 64-bitowa liczba binarna bez znaku.
;Cyfry uzyskiwane w trakcie kolejnych dzieleń należy zapisywać w 12-bajtowym 
;obszarze pamięci zarezerwowanym na stosie.
;Podprogram jest podobny do opisanego w instrukcji laboratoryjnej do ćw. 3,
;gdzie dane tymczasowe przechowywane są w sekcji danych programu (nie na stosie).
;Opracowany podprogram włączyć do kompletnego programu w asemblerze, 
;w którym podprogram będzie kilkakrotnie wywoływany dla różnych wartości argumentów.

.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

;public _main
public _suma
public _wyswietl_EAX

.data
	; deklaracja tablicy 12-bajtowej do przechowywania tworzonych cyfr
	dzielnik dd 10
	znaki db 12 dup (?)
	w0 dd 0
	w1 dd 0
	w2 dd 0

    temp_eax dd 0
    temp_edx dd 0
    temp_ecx dd 0


.code

; sumowanie
_suma PROC
	push ebp

	mov ebp, esp  
	mov eax, [ebp + 8]
	add eax, [ebp + 12]
	add eax, [ebp + 16]
	
	pop ebp
	ret
_suma ENDP

_wyswietl_EAX PROC
	push ebp
	mov ebp, esp
	;sub esp, 24  ; rezerwacja zmiennej dynamicznej 
	sub esp, 36  ; rezerwacja zmiennej dynamicznej ; MODYFIKACJA
	pushad

	;mov eax,[ebp+8]
	; ECX:EDX:EAX
	mov w2, ecx
	mov w1, edx
	mov w0, eax
	mov edi, esp
	;lea edi,[ebp-12]
		
	;mov esi, 22 ; indeks w tablicy 'znaki' 
	mov esi, 34 ; indeks w tablicy 'znaki' ; MODYFKACJA
	mov ebx, 10 ; dzielnik równy 10

konwersjaECX: 
	; MOD - ECX
	mov edx, 0 ; zerowanie starszej części dzielnej 
	mov eax, w2
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX 
	mov  w2, eax
	; MOD - ECX

	; EDX
	;mov edx, 0 ; zerowanie starszej części dzielnej 
	;mov eax, w1
	;div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX 
	;mov  w1, eax
	; EDX

	; EAX
	mov eax, w0
	div ebx
	mov w0, eax
	; EAX

	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	;add cl, 30H ; zamiana reszty z dzielenia na kod ASCII ; MOD
	mov [edi][esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu 
	;cmp eax, 0 ; sprawdzenie czy iloraz = 0 
	or eax, w2
	jne konwersjaECX ; skok, gdy iloraz niezerowy

mov ebx, 10 ; dzielnik równy 10 ; MOD

konwersjaEDX: 
	; EDX
	mov edx, 0 ; zerowanie starszej części dzielnej 
	mov eax, w1
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX 
	mov  w1, eax

	mov eax, w0
	div ebx
	mov w0, eax

	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	mov [edi][esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu 
	;cmp eax, 0 ; sprawdzenie czy iloraz = 0 
	or eax, w1
	jne konwersjaEDX ; skok, gdy iloraz niezerowy

; wypełnienie pozostałych bajtów spacjami i wpisanie  znaków nowego wiersza 
wypeln:
	;or esi, esi	; cmp esi,0
	cmp esi, 12
	je wypelnECX ; skok, gdy ESI = 12 
	mov byte PTR [edi][esi], 20H ; kod spacji 
	dec esi ; zmniejszenie indeksu 
	jmp wypeln

wypelnECX:
	;or esi, esi	; cmp esi,0
	cmp esi, 0
	jz wyswietl ; skok, gdy ESI = 0 
	mov byte PTR [edi][esi], 20H ; kod spacji 
	dec esi ; zmniejszenie indeksu 
	jmp wypelnECX 

	; WYPELN DLA EXC

wyswietl: 
	mov byte PTR [edi+0], 0AH ; kod nowego wiersza 
	;mov byte PTR [edi][23], 0AH ; kod nowego wiersza
	mov byte PTR [edi][35], 0AH ; kod nowego wiersza ;MODYFKACJA

	; wyświetlenie cyfr na ekranie 
	; push dword PTR 24 ; liczba wyświetlanych znaków 
	push dword PTR 36 ; liczba wyświetlanych znaków ; MODYFIKACJA
	; push dword PTR OFFSET znaki ; adres wyśw. obszaru 
	push edi
	push dword PTR 1; numer urządzenia (ekran ma numer 1) 
	call __write ; wyświetlenie liczby na ekranie 
	add esp, 12 ; usunięcie parametrów ze stosu

	popad
	;add esp,24	; usunięcie zmiennej dynamicznej
	add esp, 36	; usunięcie zmiennej dynamicznej
	pop ebp
	ret
_wyswietl_EAX ENDP


wczytaj_do_EAX_hex PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    ; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych wyświetlanej liczby
    sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
    mov esi, esp ; adres zarezerwowanego obszaru pamięci

    push dword PTR 10 ; max ilość znaków wczytyw. liczby
    push esi ; adres obszaru pamięci
    push dword PTR 0; numer urządzenia (0 dla klawiatury)
    call __read ; odczytywanie znaków z klawiatury (dwa znaki podkreślenia przed read)

    add esp, 12 ; usunięcie parametrów ze stosu
    mov eax, 0 ; dotychczas uzyskany wynik

    pocz_konw:
    mov dl, [esi] ; pobranie kolejnego bajtu
    inc esi ; inkrementacja indeksu
    cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
    je gotowe ; skok do końca podprogramu
    ; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
    cmp dl, '0'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0' ; zamiana kodu ASCII na wartość cyfry

    dopisz:
    shl eax, 4 ; przesunięcie logiczne w lewo o 4 bity
    or al, dl ; dopisanie utworzonego kodu 4-bitowego

    ; na 4 ostatnie bity rejestru EAX
    jmp pocz_konw ; skok na początek pętli konwersji
    ; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F

    sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
    jmp dopisz
    ; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f

    sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'f'
    ja pocz_konw ; inny znak jest ignorowany
    sub dl, 'a' - 10
    jmp dopisz

    gotowe:
    add esp, 12 ; zwolnienie zarezerwowanego obszaru pamięci
    mov temp_eax, eax

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
wczytaj_do_EAX_hex ENDP


wczytaj_do_EDX_hex PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    ; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych wyświetlanej liczby
    sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
    mov esi, esp ; adres zarezerwowanego obszaru pamięci

    push dword PTR 10 ; max ilość znaków wczytyw. liczby
    push esi ; adres obszaru pamięci
    push dword PTR 0; numer urządzenia (0 dla klawiatury)
    call __read ; odczytywanie znaków z klawiatury (dwa znaki podkreślenia przed read)

    add esp, 12 ; usunięcie parametrów ze stosu
    mov eax, 0 ; dotychczas uzyskany wynik

    pocz_konw:
    mov dl, [esi] ; pobranie kolejnego bajtu
    inc esi ; inkrementacja indeksu
    cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
    je gotowe ; skok do końca podprogramu
    ; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
    cmp dl, '0'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0' ; zamiana kodu ASCII na wartość cyfry

    dopisz:
    shl eax, 4 ; przesunięcie logiczne w lewo o 4 bity
    or al, dl ; dopisanie utworzonego kodu 4-bitowego

    ; na 4 ostatnie bity rejestru EAX
    jmp pocz_konw ; skok na początek pętli konwersji
    ; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F

    sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
    jmp dopisz
    ; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f

    sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'f'
    ja pocz_konw ; inny znak jest ignorowany
    sub dl, 'a' - 10
    jmp dopisz

    gotowe:
    add esp, 12 ; zwolnienie zarezerwowanego obszaru pamięci
    mov temp_edx, eax

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
wczytaj_do_EDX_hex ENDP


wczytaj_do_ECX_hex PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    ; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych wyświetlanej liczby
    sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
    mov esi, esp ; adres zarezerwowanego obszaru pamięci

    push dword PTR 10 ; max ilość znaków wczytyw. liczby
    push esi ; adres obszaru pamięci
    push dword PTR 0; numer urządzenia (0 dla klawiatury)
    call __read ; odczytywanie znaków z klawiatury (dwa znaki podkreślenia przed read)

    add esp, 12 ; usunięcie parametrów ze stosu
    mov eax, 0 ; dotychczas uzyskany wynik

    pocz_konw:
    mov dl, [esi] ; pobranie kolejnego bajtu
    inc esi ; inkrementacja indeksu
    cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
    je gotowe ; skok do końca podprogramu
    ; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
    cmp dl, '0'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, '9'
    ja sprawdzaj_dalej
    sub dl, '0' ; zamiana kodu ASCII na wartość cyfry

    dopisz:
    shl eax, 4 ; przesunięcie logiczne w lewo o 4 bity
    or al, dl ; dopisanie utworzonego kodu 4-bitowego

    ; na 4 ostatnie bity rejestru EAX
    jmp pocz_konw ; skok na początek pętli konwersji
    ; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F

    sprawdzaj_dalej:
    cmp dl, 'A'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'F'
    ja sprawdzaj_dalej2
    sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
    jmp dopisz
    ; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f

    sprawdzaj_dalej2:
    cmp dl, 'a'
    jb pocz_konw ; inny znak jest ignorowany
    cmp dl, 'f'
    ja pocz_konw ; inny znak jest ignorowany
    sub dl, 'a' - 10
    jmp dopisz

    gotowe:
    add esp, 12 ; zwolnienie zarezerwowanego obszaru pamięci
    mov temp_ecx, eax

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
wczytaj_do_ECX_hex ENDP


_main PROC
	call wczytaj_do_ECX_hex
	call wczytaj_do_EDX_hex
	call wczytaj_do_EAX_hex
	
	;mov ecx, 0h
	mov ecx, temp_ecx ;MOD
	;mov edx, 0h
    mov edx, temp_edx ;MOD
	;mov eax, 1h
	mov eax, temp_eax ;MOD

    ; ECX:EDX:EAX
	call _wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END
