.686
.model flat

extern  __read          : PROC
extern  __write         : PROC
extern  _ExitProcess@4     : PROC

.data
    inputBuffer db 12 dup(?)  ; Buffer for input
    outputBuffer db 12 dup(?) ; Buffer for output

.code
ReadDuodecimalConvertToDecimal PROC
    push ebp                 ; Save base pointer
    mov ebp, esp             ; Establish stack frame
    sub esp, 4               ; Make room for local variable

    mov esi, OFFSET inputBuffer ; Load address of input buffer
    push esi                ; Push parameters for __read
    push 0                  ; STDIN
    push 12                 ; Max characters
    call __read             ; Call read function
    add esp, 12             ; Clean up stack

    mov esi, OFFSET inputBuffer ; Point ESI to start of buffer
    mov eax, 0              ; Clear EAX (accumulator for result)

convert_loop:
    movzx ebx, byte ptr [esi] ; Load next byte into EBX
    inc esi                 ; Move to next byte
    cmp ebx, 10             ; Check for newline character (Enter key)
    je conversion_done      ; If newline, conversion is done
    cmp ebx, '0'
    jl skip_non_digit       ; Skip non-digit characters
    cmp ebx, '9'
    jle process_digit       ; Process '0' - '9'
    cmp ebx, 'A'
    jl skip_non_digit       ; Skip characters between '9' and 'A'
    cmp ebx, 'B'
    jg skip_non_digit       ; Skip characters after 'B'
    sub ebx, 'A' - 10       ; Convert 'A'-'B' to 10-11
    jmp process_digit

process_digit:
    sub ebx, '0'            ; Convert character to number
    imul eax, eax, 12       ; Multiply current result by 12
    add eax, ebx            ; Add new digit
    jmp convert_loop

skip_non_digit:
    jmp convert_loop

conversion_done:
    ; EAX now contains the converted decimal number

    mov esp, ebp            ; Restore stack pointer
    pop ebp                 ; Restore base pointer
    ret
ReadDuodecimalConvertToDecimal ENDP

; Convert EAX (decimal) to string and output
PrintDecimal PROC
    mov ecx, 10                 ; Divider for decimal conversion
    mov ebx, OFFSET outputBuffer + 11 ; Start at the end of buffer
    mov byte ptr [ebx], 0       ; Null-terminate the string

    print_loop:
        dec ebx                ; Move back in the buffer
        xor edx, edx           ; Clear EDX for DIV
        div ecx                ; Divide EAX by 10, result in EAX, remainder in EDX
        add dl, '0'            ; Convert remainder to ASCII
        mov [ebx], dl          ; Store character
        test eax, eax          ; Check if EAX is zero
        jnz print_loop         ; If not, keep dividing

    push OFFSET outputBuffer   ; Push parameters for __write
    push ebx
    push 1                    ; STDOUT
    call __write
    add esp, 12               ; Clean up stack
    ret
PrintDecimal ENDP

_main PROC
    call ReadDuodecimalConvertToDecimal
    call PrintDecimal

    push 0
    call _ExitProcess@4
_main ENDP
END
