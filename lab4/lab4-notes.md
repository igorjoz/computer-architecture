# Architektura Komputerów, lab 4
## Notatki
| Aplikacje | 16-bit | 32-bit | 64-bit Win | 64-bit Linux| 
|----------|---------------------|---------------------|---------------------|-|
|Przekazywanie parametrów|Stos|Stos (Od prawej - C, StdCall; Od lewej - Pascal), wskaźnik obiektu klasy w ECX| RCX, RDX, R8, R9, stos; zmiennoprzecinkowe XMM0-3 | RDI, RSI; RDX, RCX, R8, R9, stos; zmiennoprzecinkowe XMM0-7
|Rejestry do zapamiętania|Indeksowe (SI, DI), bazowy (BP), segmentowy (DS)|Indeksowe (ESI, EDI), bazowe (EBP, EBX)| Indeksowe (RSI, RDI), bazowe (RBP, RBX), R12-15, XMM6-15|Bazowe (RBP, RBX), R12-15
|Zwracanie wartości|(DX:)AX; zmiennoprzecinkowe w ST(0)|(EDX:)(EAX); zmiennoprzecinkowe w ST(0)|RAX; zmiennoprzecinkowe w XMM0|(RDX:)RAX; zmiennoprzecinkowe w XMM0-1, ST(0-1)

Standardy wywoływania funkcji

|Standard| C | StdCall | Pascal |
|----------|----------|----------|---|
| Kolejność ładowania na stos  | Od prawej do lewej   | Od prawej do lewej   | **Od lewej do prawej**
| Zdejmowanie parametrów   | **Wywołujący**   | Wywoływany   | Wywoływany

## Wejściówki

### Discord

- **Jak funkcja zgodna ze standardem C zwraca wynik typu float?**
Na wierzchołku stosu koprocesora, czyli `ST(0)`.

- **Czemu przy programowaniu mieszanym pliki .asm i .c nie mogą mieć tej samej nazwy?**
Przy kompilacji generowane są pliki `.obj` o takiej samej nazwie jak plik źródłowy i nadpisywałyby się one wzajemnie.

- **Na liście jakiej dyrektywy muszą znaleźć się globalne zmienne i funkcje używane przez program w asm?**
`EXTERN`

- **Jakie rejestry muszą być zapamiętywane i odtwarzane w aplikacji 32-bit?**
Bazowe `EBP, EBX`, indeksowe `ESI, EDI`

- **Dlaczego należy używać rejestru EBP w miejsce rejestru ESP?**
Wartość `ESP` może się zmienić w trakcie wykonywania podprogramu.

- **Jakim kwantyfikatorem należy poprzedzić prototyp funkcji w kompliatorze C++ jeśli chcemy skorzystać z interfejsu języka C?**
`extern "C"`

- **Co poprzedza nazwy procedur w standardzie C?**
Znak podkreślenia `_`

- **Jak odczytać wartość parametru `(int** wsk)` w assemblerze?**
```
MOV EAX,[EBP+8]; odczytanie adresu przekazanego w pierwszym argumencie
MOV EAX,[EAX]; odczytanie adresu pod wskazanym adresem
MOV EAX,[EAX]; odczytanie wartości
```

- **Jak wygląda przekazany parametr jednobajtowy na stosie?**
Rozszerzony do 32 bitów, podany parametr w najmłodszej części.

- **Asembler MASM odróżnia małe i wielkie litery tylko wówczas, jeśli w linii wywołania asemblera podano opcję...** `-Cp` (Case Preserve)

- **Jeśli argumentem funkcji w języku C jest tablica, to na stosie zapisywany jest...** Adres pierwszego elementu (o indeksie 0).

- **Podać sekwencje rozkazów która  wczyta do ax 16-bitową wartość parametru `(short int*)` funkcji w assemblerze (funkcja napisana w standardzie C):**
```
MOV EAX,[EBP+8]
MOV AX,[EAX]
```

- **Kiedy wyskakuje bład `unresolved external symbol`` podczas konsolidacji?**
Kiedy załączymy u góry pliku zewnętrzną funkcję, która nie istnieje (lub plik/biblioteka z nią nie jest włączony do kompilacji)

- **Czy w 32bit trzeba zapamietywac i odczytywac rejestry xmm0-xmm7**
Nie

- **Odczytaj wartosc z zmiennej parametru funkcji `f(char** x)` i wpisz do `AH`**
```
MOV EAX, [EBP+8]; odczytanie adresu przekazanego w parametrze
MOV EAX, [EAX]; odczytanie adresu pod podanym adresem
MOV AH, [EAX]; odczytanie wartości
```

- **Gdzie będą parametry `int funkcja(int a, float b, int c, float d, int e, float f);`?**
	- W trybie 32-bitowym: wszystko na stosie, kolejno EBP+8, EBP+12 itd. aż do EBP+28
	- W trybie 64-bitowym: Podobno Dziub Dziub mówił że zależy od kompilatora, mogą być wstawiane nie po kolei

- **Czym różni się standard C od Pascal?**
Usuwanie parametrów - w C wywołujący, w Pascalu wywoływany; Przekazywanie parametrów - w C od prawej do lewej, w Pascalu od lewej do prawej.

- **Ponumeruj wykonywane akcje przy wychodzeniu z procedury w standardzie stdcall (jeżeli wykonują się jednocześnie to wpisz tą samą liczbę)**

	2. zwolnienie zmiennych lokalnych
	1. odtworzenie rejestrów
	3. usunięcie argumentów ze stosu
	3. wywołanie instrukcji RET

- **Jakiego interfejsu dotyczy komunikacja w zadaniu "Czym się różni standard C od Pascal"?**
ABI - Application Binary Interface

- **W jakiej kolejności wykonywane są: Prolog, Rezerwacja zmiennych lokalnych, Zapamietanie rejestrow**
	1. Prolog
	2. Rezerwacja zmiennych lokalnych
	3. Zapamiętanie rejestrów

### Paczka

- **Chcąc uzyskać wyrównanie danych do adresów podzielnych przez 16 należy na początku segmentu
danych umieścić dyrektywę...** `ALIGN 16`

- **Wskaż nazwy rejestrów, których wartości należy zachować w podprogramie przystosowanym do wywołania w
standardzie C w trybie 32-bitowym.** `EBX, EBP, EDI, ESI`

- **Wskaż sekwencję rozkazów w asemblerze x86 (tryb 32 bitowy), która pobierze do rejestru drugi parametr
funkcji (adres) o następującym prototypie
`void funkcja1 (unsigned char a, double* b)`
Zakłada się wywołanie zgodne z standardem C i istniejący już fragment standardowego prologu na początku kodu asemblera.**
```
MOV EAX, [EBP+12]; (lub MOV EAX, [ESP+12])
```

- **Czym jest shadow space w trybie 64 bitowym?**
Obszar pamięci na stosie o rozmiarze **32 bajtów**, tworzony przez program **wywołujący**.

- **W trybie 64-bitowym piąty parametr i następne, jeśli występują, przekazywane są przez...** stos.

- **W jakim celu w programach w języku C++ prototyp funkcji kodowanej w asemblerze poprzedza się kwalifikatorem `extern "C"` ?** Ze względu na brak konieczności uwzględnienia kłopotliwej zmiany nazw funkcji.

- **Różnica między ABI a API**
API to interfejs programowy - zestaw metod, typów, zmiennych itp. przeznaczonych do wywoływania przez programistę.\
ABI to interfejs binarny - określa sposób wywoływania funkcji na poziomie procesora, m.in przekazywanie parametrów, zwracanie wartości, zachowywanie rejestrów, usuwanie parametrów itp.

- **Różnice między konsolidacją, asemblacją i linkowaniem.**
Konsolidacja to łączenie wszystkich skompilowanych plików i wymaganych bibliotek statycznych w jeden program wynikowy.\
Asemblacja to kompilowanie kodu źródłowego w assemblerze na kod pośredni `.obj`.\
Linkowanie to angielska nazwa konsolidacji.

- **Biblioteki statyczne i dynamiczne.**
Biblioteki statyczne są dołączane do kodu wynikowego w procesie konsolidacji.\
Biblioteki dynamiczne - w procesie ładowania programu w czasie jego uruchamiania.

- **W jakim rejestrze zwracany jest wynik typu double w programie 64-bitowym?** `XMM0`

- **Jeżeli funkcja w x64 przymuje 5 argumentów to jak są one przekazywane? Czy wykorzystywane są rejestry, a jeśli tak to jakie?**
Zakładając że nie są to liczby zmiennoprzecinkowe, to kolejno: RCX, RDX, R8, R9 i stos.

- **W trybie 64 bitowym, rozkazy grupy SSE wykonywane są na ... rejestrach XMM, z których każdy zawiera ... bitów.** `16` rejestrów, każdy po `128` bitów.