.686
.model flat

extern  __read          : PROC
extern  __write         : PROC
extern _ExitProcess@4   : PROC

.data
    znaki db 12 dup (?)
    temp db 'X'
    converted_number dd 0
    dekoder db '0123456789ABCDEF'

.code
wczytaj_do_EAX_duodec PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    sub esp, 12        ; Reserve 12 bytes on stack for the input
    mov esi, esp      ; Address of reserved memory space

    push dword PTR 10 ; Maximum number of characters to read
    push esi         ; Address of memory space
    push dword PTR 0 ; Device number (0 for keyboard)
    call __read      ; Read characters from keyboard

    add esp, 12       ; Remove parameters from stack
    mov eax, 0        ; Result initialized to 0

    convert_loop:
    mov dl, [esi]     ; Get the next byte
    inc esi          ; Increment index
    cmp dl, 10       ; Check for Enter key
    je conversion_done ; Jump to end if Enter
    cmp dl, '0'
    jb convert_loop  ; Ignore other characters
    cmp dl, '9'
    ja check_alpha   ; Check for 'A' or 'B'
    sub dl, '0'      ; Convert ASCII to digit value
    jmp append_digit

    check_alpha:
    cmp dl, 'A'
    jb convert_loop  ; Ignore non-duodecimal characters
    cmp dl, 'B'
    ja convert_loop  ; Ignore non-duodecimal characters
    sub dl, 'A' - 10 ; Convert 'A' or 'B' to 10 or 11
    jmp append_digit

    append_digit:
    shl eax, 4       ; Shift the current number left by 4 bits
    or al, dl        ; Append the new digit
    jmp convert_loop ; Repeat loop

    conversion_done:
    add esp, 12       ; Free the reserved memory space

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
wczytaj_do_EAX_duodec ENDP

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
    ; Read first number
    ;push DWORD PTR 12
    ;push DWORD PTR OFFSET znaki
    ;push DWORD PTR 0
    ;call __read
    ;add esp, 12

    call wczytaj_do_EAX_duodec
    mov [converted_number], eax ; Store first number

    ; Read second number
    ;push DWORD PTR 12
    ;push DWORD PTR OFFSET znaki
    ;push DWORD PTR 0
    ;call __read
    ;add esp, 12

    call wczytaj_do_EAX_duodec
    add eax, [converted_number] ; Add second number

    call wyswietl_EAX ; Display result

    push 0
    call _ExitProcess@4
_main ENDP
END