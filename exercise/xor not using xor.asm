.686
.model flat

extern _ExitProcess@4: PROC

public _main

.code
_main PROC
    ;mov edi, 11111111b
    ;mov esi, 00000000b

    mov edi, 00110011b
    mov esi, 01010101b

    ; Zakładając, że mamy rejestry edi i esi, które chcemy poddać operacji XOR

    ; Użyjemy dodatkowych rejestrów do przechowywania pośrednich wyników
    mov eax, edi   ; Skopiuj wartość z edi do eax
    mov ebx, esi   ; Skopiuj wartość z esi do ebx

    not eax        ; Zaneguj wszystkie bity w eax
    and eax, ebx   ; AND zanegowanego eax z ebx, wynik w eax

    not ebx        ; Zaneguj wszystkie bity w ebx
    and ebx, edi   ; AND zanegowanego ebx z edi, wynik w ebx

    or eax, ebx    ; OR wyników powyższych AND, wynik w eax
    mov edi, eax   ; Wynik końcowy kopiujemy z powrotem do edi

    push 0 ; kod wyjścia z konsoli - 0 - OK
    call _ExitProcess@4

_main ENDP
END