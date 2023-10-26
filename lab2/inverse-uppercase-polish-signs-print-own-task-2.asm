.686
.model flat
extern _ExitProcess@4: PROC
extern __write: PROC
extern __read:PROC
extern _MessageBoxA@16: PROC
extern _MessageBoxW@16: PROC
public _main

.data
	magazyn db 80 dup(?)
	imie db 40 dup(0)
	nazwisko db 40 dup(0)
	imie_big db 40 dup(0)
	nazwisko_big db 40 dup(0)
	liczba_znakow dd ?
	latin2 db 0A5H,086H,0A9H,088H,0E4H,0A2H,098H,0ABH,0BEH, 0A4H,08FH,0A8H,09DH,0E3H,0E0H,097H,08DH,0BDH
	unicode dw 0105H,0107H,0119H,0142H,0144H,00F3H,015BH,017AH,017CH, 0104H,0106H,0118H,0141H,0143H,00D3H,015AH,0179H,017BH
	magazyn_unicode db 80 dup(0)

.code
_main PROC
	push 80
	push OFFSET magazyn
	push 0
	call __read
	add esp,12
	mov liczba_znakow,eax
	mov ecx,liczba_znakow
	dec ecx
	mov esi, OFFSET magazyn
	mov edi, OFFSET imie
	ptl:	mov dl,[esi]
			cmp dl,20h
			je wpisuj_nazwisko
			mov [edi],dl
			inc edi
			jmp continue
	wpisuj_nazwisko:
			mov [edi],BYTE PTR 0Ah
			mov edi, OFFSET nazwisko
	continue:
			inc esi
			loop ptl
	mov [edi],BYTE PTR 20h
	mov ecx, (OFFSET imie_big - OFFSET nazwisko)
	push ecx
	push OFFSET nazwisko
	push 1
	call __write
	add esp,12

	mov ecx, (OFFSET nazwisko - OFFSET imie)
	push ecx
	push OFFSET imie
	push 1
	call __write
	add esp,12

	mov esi,0

	ptl_nazw_big:	mov dl,nazwisko[esi]
					mov nazwisko_big[esi],dl
					mov eax,0
		nazw_polskie:cmp dl,latin2[eax]
					jne nazw_next
					mov dl,latin2[9+eax]
					mov nazwisko_big[esi],dl
					jmp nazw_dalej
		nazw_next:	inc eax
					cmp eax, 9
					jne nazw_polskie
					cmp dl,'a'
					jb nazw_dalej
					cmp dl,'z'
					ja nazw_dalej
					sub dl,20h
					mov nazwisko_big[esi],dl
		nazw_dalej:	inc esi
					cmp nazwisko[esi],0
					jne ptl_nazw_big

	mov esi,0

	ptl_imie_big:	mov dl,imie[esi]
					mov imie_big[esi],dl
					mov eax,0
			imie_polskie:cmp dl,latin2[eax]
					jne imie_next
					mov dl,latin2[9+eax]
					mov imie_big[esi],dl
					jmp imie_dalej
			imie_next:	inc eax
					cmp eax, 9
					jne imie_polskie
					cmp dl,'a'
					jb imie_dalej
					cmp dl,'z'
					ja imie_dalej
					sub dl,20h
					mov imie_big[esi],dl
			imie_dalej:	inc esi
					cmp imie[esi],0
					jne ptl_imie_big

	mov ecx, (OFFSET liczba_znakow - OFFSET nazwisko_big)
	push ecx
	push OFFSET nazwisko_big
	push 1
	call __write
	add esp,12

	mov ecx, (OFFSET nazwisko_big - OFFSET imie_big)
	push ecx
	push OFFSET imie_big
	push 1
	call __write
	add esp,12



	mov esi, OFFSET nazwisko_big
	mov edi, 0

	ptl2:	mov dl,[esi]
			mov eax,0
	polskie2:	cmp dl,latin2[eax]
				jne next2
				mov dx, unicode[eax*2]
				mov magazyn_unicode[edi*2],dl
				mov magazyn_unicode[edi*2+1],dh
				jmp dalej2
	next2:		inc eax
				cmp eax,18
				jne polskie2
	dalej2:	mov magazyn_unicode[edi*2],dl
			inc edi
	cont2:
			inc esi
			cmp [esi],BYTE PTR 0
			jne ptl2

	mov esi, OFFSET imie_big

	ptl3:	mov dl,[esi]
			mov eax,0
	polskie3:	cmp dl,latin2[eax]
				jne next3
				mov dx, unicode[eax*2]
				mov magazyn_unicode[edi*2],dl
				mov magazyn_unicode[edi*2+1],dh
				jmp dalej3
	next3:		inc eax
				cmp eax,18
				jne polskie3
	dalej3:	mov magazyn_unicode[edi*2],dl
			inc edi
	cont3:
			inc esi
			cmp [esi],BYTE PTR 0
			jne ptl3

	push 0
	push OFFSET 0
	push OFFSET magazyn_unicode
	push 0
	call _MessageBoxW@16

	push 0
	call _ExitProcess@4
_main ENDP
END