.686
.model flat

public _nowy_exp

.data
    dzielnik dd 1
    jeden dd 1

.code
_nowy_exp PROC

    push ebp
    mov ebp, esp
    push esi
    push edi

    mov ebx, [ebp+8] ; ecx is the num - argument of the function
    ;mov eax, OFFSET dzielnik
    mov eax, 1
    mov edi, 1

    fldz                ; ST(0) = 0, initialize sum of reciprocals
    fld DWORD PTR [ebp + 8]
    fld1
    mov ecx, 19 ; powtorz 3 razy

sum_loop:
    fmul st(0), st(1)

    fild dzielnik

    fld st(1)


    fdiv st(0), st(1)

    fadd st(4), st(0)

    fstp st(0)
    fstp st(0)

    inc edi
    mul edi

    mov [dzielnik], eax

loop sum_loop

    fstp st(0)
    fstp st(0)

    fild jeden
    fadd st(1), st(0)

    fstp st(0)

    pop edi
    pop esi
    pop ebp
    ret

_nowy_exp ENDP
END