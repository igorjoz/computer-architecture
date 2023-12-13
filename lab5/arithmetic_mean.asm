.686
.model flat

public _arithmetic_mean

.code
_arithmetic_mean PROC

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
    fld DWORD PTR [esi + edi*4] ; Load array element into ST(0)
    faddp st(1), st(0) ; Add the result to the sum and pop the stack
    inc edi
    cmp edi, ecx
    jl sum_loop

    ; Calculate harmonic mean
    fidiv DWORD PTR [ebp+12] ; Divide 'n' by the sum
    jmp done

invalid_input:
    fldz ; Return 0 in case of invalid input

done:
    pop edi
    pop esi
    pop ebp
    ret

_arithmetic_mean ENDP
END