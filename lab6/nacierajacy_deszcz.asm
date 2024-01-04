; Program linie.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy






linia PROC
; przechowanie rejestrów
push ax
push bx
push cx
push dx
push es
mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
mov es, ax
mov bx, cs:adres_piksela ; adres bieżący piksela
mov dx, cs:adres_piksela_prawy ; adres bieżący piksela
mov al, cs:kolor

mov cx, cs:gora
; mov dx, 319


; mov ax, 0A020H ; adres pamięci ekranu dla trybu 13H
; mov es, ax

petla:
mov es:[bx], al ; wpisanie kodu koloru do pamięci ekranu

add bx, dx



mov es:[bx], al ; wpisanie kodu koloru do pamięci ekranu
; przejście do następnego wiersza na ekranie
; sub bx, dx
; add bx, 320
add bx, 400

loop petla

; sprawdzenie czy cała linia wykreślona
cmp bx, 320*200
jb dalej ; skok, gdy linia jeszcze nie wykreślona
; kreślenie linii zostało zakończone - następna linia będzie
; kreślona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 5
mov bx, 5
mov dx, 5
add bx, cs:przyrost
sub dx, cs:przyrost


; inc cs:kolor ; kolejny kod koloru
; zapisanie adresu bieżącego piksela
dalej:
mov cs:adres_piksela, bx
; mov cs:adres_piksela_prawy, dx

; mov cs:gora, cx 



; odtworzenie rejestrów
 pop es
 pop dx
 pop cx
 pop bx
 pop ax
; skok do oryginalnego podprogramu obsługi przerwania
; zegarowego
 jmp dword PTR cs:wektor8
; zmienne procedury
kolor db 2 ; bieżący numer koloru
; adres_piksela dw 10 ; bieżący adres piksela
adres_piksela dw 0 ; bieżący adres piksela
adres_piksela_prawy dw 319 ; bieżący adres piksela
przyrost dw 0
gora dw 200
wektor8 dd ?
linia ENDP











; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov ah, 0
mov al, 13H ; nr trybu
int 10H
mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamiętanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwań
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwań
czekaj:
mov ah, 1 ; sprawdzenie czy jest jakiś znak
int 16h ; w buforze klawiatury
jz czekaj
mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H
; odtworzenie oryginalnej zawartości wektora nr 8

mov eax, cs:wektor8
mov es:[32], eax
; zakończenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stos SEGMENT stack
db 256 dup (?)
stos ENDS
END zacznij
