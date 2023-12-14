.686
.model flat

extern _ExitProcess@4: PROC

public _main

.data
stale DW 2,1
napis DW 10 dup (3),2
tekst DB 7
DQ 1

.code
_main PROC
    mov eax, 0
    mov edx, 0
    
    mov ax, 1
    mov dx, -1
    cmp ax, dx

    ja koniec ; ja działa tylko dla liczb bez znaku, unsigned; skok się nie wykona
    ; jg - zadziała zgodnie z zamiarem - poprawnie porówna (1) i (-1) - przeskoczy na koniec

    mov ax, 0abch
    mov dx, 0defh

    koniec:


    push 0 ; kod wyjścia z konsoli - 0 - OK
    call _ExitProcess@4

_main ENDP
END