.686
.model flat

extern	_GetEnvironmentVariableW@12	: PROC
extern	_malloc						: PROC
extern	_free						: PROC
extern	__write						: PROC

public	_env_rozmiar

.code
;	int env_rozmiar(wchar_t* nazwa);
_env_rozmiar	PROC
			push	ebp
			mov		ebp, esp

			push	ebx
			push	esi
			push	edi

			; wchar_t* nazwa at [ebp+8]
			mov		esi, [ebp+8]	; input string at ESI
			; remove new lines from string input
			mov		ecx, 0
		remove_new_lines:
			mov		ax, [esi][2*ecx]
			inc		ecx
			cmp		ax, 0Ah
			jne		remove_new_lines
			mov		[esi][2*ecx-2], word ptr 0

			; allocate memory for env variable value
			buffer_size	equ	32768*2	; 32768 words
			push	buffer_size
			call	_malloc
			add		esp, 4
			mov		edi, eax	; reserved memory in EDI

			; call GetEnvironmentVariableW
			push	buffer_size
			push	edi
			push	esi
			call	_GetEnvironmentVariableW@12
			cmp		eax, 0	; if eax = 0 then error
			je		error
			; else return eax

		finish:
			push	eax
			push	edi
			call	_free
			add		esp, 4
			pop		eax

			pop		edi
			pop		esi
			pop		ebx

			pop		ebp
			ret

		error:
			sub		esp, 8
			mov		eax, esp
			mov		[eax+0], byte ptr 'B'
			mov		[eax+1], byte ptr 088h	; '³'
			mov		[eax+2], byte ptr 0A5h	; '¹'
			mov		[eax+3], byte ptr 'd'
			mov		[eax+4], byte ptr 0Ah
			mov		[eax+5], byte ptr 0
			push	6
			push	eax
			push	1
			call	__write
			add		esp, 20
			mov		eax, -1
			jmp		finish
_env_rozmiar	ENDP
END