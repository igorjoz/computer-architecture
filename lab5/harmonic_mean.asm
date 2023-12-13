.686
.model flat

public _harmonic_mean

.code
_harmonic_mean PROC

    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp+8]  ; esi points to the array
    mov ecx, [ebp+12] ; ecx is the count 'n'

    ; Check for valid input
    test ecx, ecx
    jz invalid_input

    fldz                ; ST(0) = 0, initialize sum of reciprocals
    xor edi, edi        ; Zero the counter

sum_loop:
    fld1                ; Load constant 1.0 into ST(0)
    fld DWORD PTR [esi + edi*4] ; Load array element into ST(0)
    fdiv               ; Divide 1.0 by the array element
    faddp st(1), st(0) ; Add the result to the sum and pop the stack
    inc edi
    cmp edi, ecx
    jl sum_loop

    ; Calculate harmonic mean
    fild DWORD PTR [ebp+12] ; Load 'n' into ST(0)
    fdiv st(0), st(1)
    jmp done

invalid_input:
    fldz ; Return 0 in case of invalid input

done:
    pop edi
    pop esi
    pop ebp
    ret

_harmonic_mean ENDP
END