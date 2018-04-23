; Autor: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
; razeni pole ruznymi algoritmy s vyberem smeru razeni
; BubbleSort, InsertionSort

%include "rw32-2017.inc"

section .data
    ARRAY DD 3, 0, -2, 10, 2, 1, 23, 42, -42, 1532 ; vstupni pole
    ARRAY_SIZE DD 10 ; velikost vstupniho pole
    
    STR_UNSORTED_ARR DB "Neserazene pole: ", 0, EOL
    STR_SORTED_ARR DB "Serazene pole: ", 0, EOL

section .text
main:
    MOV EBP, ESP
    
    ; vypis pole
    PUSH STR_UNSORTED_ARR
    PUSH DWORD [ARRAY_SIZE]
    PUSH ARRAY
    CALL PrintArray
    ADD ESP, 12
    
    ; serazeni pole (vzestupne)
    PUSH DWORD 0
    PUSH DWORD [ARRAY_SIZE]
    PUSH ARRAY
    CALL InsertionSort
    ADD ESP, 12
    
    ; vypis pole
    PUSH STR_SORTED_ARR
    PUSH DWORD [ARRAY_SIZE]
    PUSH ARRAY
    CALL PrintArray
    ADD ESP, 12

    XOR EAX, EAX
    RET
    
; BubbleSort
; arg1 - adresa pole pro serazeni
; arg2 - velikost pole pro serazeni
; arg3 - smer razeni (0 => ASC - vzestupne, 1 => DESC - sestupne)
BubblesortAsc:
    ENTER 8, 0
    PUSH EAX
    PUSH ECX
    PUSH EDX
    
    ; definice jmen parametru a lokalnich promenych
    %define direction [EBP + 16] ; arg3
    %define array_size [EBP + 12] ; arg2
    %define array [EBP + 8] ; arg1
    %define array_max_index [EBP - 4] ; maximalni index pole
    %define tmp [EBP - 8] ; docasna promenna pro vymenu prvku

    ; vypocet maximalniho indexu pole (velikost - 1)
    MOV EAX, array_size
    MOV array_max_index, EAX
    DEC DWORD array_max_index
    
; for (ECX = 0; ECX < array_max_index; ECX++)
    XOR ECX, ECX
.for_1:
    CMP ECX, array_max_index
    JGE .end_for_1
    
    PUSH ECX ; ulozeni ECX na zasobnik, protoze si ho prepisu ve vnitrnim cyklu

; for (ECX = 0; ECX < array_max_index; ECX++)
    XOR ECX, ECX
    .for_2:
        CMP ECX, array_max_index
        JGE .end_for_2
    
        
        MOV EAX, array ; EAX = aktualni prvek
        MOV EDX, [EAX + 4] ; EDX = hodnota nasledujiciho prvku
        MOV EAX, [EAX] ; EAX = hodnota aktualniho prvku
        
        ; vyber smeru razeni
        CMP direction, DWORD 0
        JNE .desc
        ; asc razeni - vzestupne
        ; if (current > next) swap(); else continue;
        CMP EAX, EDX
        JLE .continue
        JMP .swap
        
        .desc:
        ; asc razeni - sestupne
        ; if (current < next) swap(); else continue;
        CMP EAX, EDX
        JGE .continue
        
        .swap:
        ; prohozeni aktualniho a nasledujiciho prvku
        MOV tmp, EAX ; tmp = aktualni prvek
        MOV EAX, array ; EAX = adresa aktualniho prvku
        MOV [EAX], EDX ; hodnota adresy aktualniho prvku = nasledujici prvek
        ADD EAX, 4 ; zvyseni hodnoty adresy pole v EAX o 4 (nasledujici prvek)
        MOV EDX, tmp ; EDX = aktualni prvek
        MOV [EAX], EDX ; hodnota adresy nasledujiciho prvku = aktualni prvek
    
        .continue:
        ; posun adresy pole na dalsi prvek
        ADD array, DWORD 4
    
        ; inkrementace ECX a skok do dalsi iterace cyklu
        INC ECX
        JMP .for_2
    
    .end_for_2:
    ; po pruchodu vnitrnim cyklem je potreba vratit adresu pole na puvodni prvek
    MOV EAX, array_max_index
    MOV EDX, 4
    MUL EDX
    SUB array, EAX
    
    ; obnoveni ECX ze zasobniku, jeho inkrementace a skok do dalsi iterace cyklu
    POP ECX
    INC ECX
    JMP .for_1
    
.end_for_1:
    POP EDX
    POP ECX
    POP EAX
    LEAVE
    RET
    
; BubbleSort
; arg1 - adresa pole pro serazeni
; arg2 - velikost pole pro serazeni
; arg3 - smer razeni (0 => ASC - vzestupne, 1 => DESC - sestupne)
InsertionSort:
    ENTER 8, 0
    PUSH EAX
    PUSH ECX
    PUSH EDX
    
    ; definice jmen parametru a lokalnich promenych
    %define direction [EBP + 16] ; arg3
    %define array_size [EBP + 12] ; arg2
    %define array [EBP + 8] ; arg1
    %define array_max_index [EBP - 4] ; maximalni index pole
    %define tmp [EBP - 8] ; docasna promenna
    
    ; vypocet maximalniho indexu pole (velikost - 1)
    MOV EAX, array_size
    MOV array_max_index, EAX
    DEC DWORD array_max_index
    
; for (ECX = 0; ECX < array_max_index; ECX++)
    XOR ECX, ECX
.for:
    CMP ECX, array_max_index
    JGE .end_for
    
    ; inkrementace ECX a ulozeni ECX na zasobnik, protoze si ho prepisu ve vnitrnim cyklu
    INC ECX
    PUSH ECX
    
    ; ulozeni nasledujici hodnoty v poli do promenne tmp
    MOV EAX, array ; EAX = adresa pole
    ADD EAX, 4 ; zvyseni adresy pole v EAX o 4 (dalsi prvek)
    MOV EAX, [EAX] ; EAX = hodnoty dalsi adresy pole
    MOV tmp, EAX ; tmp = EAX
    
    PUSH DWORD array ; ulozeni aktualni adresy pole na zasobnik (bude se v poli posouvat a potrebuji
                     ; se potom vratit na tuto adresu)
     ; while (ECX > 0 && tmp >/< aktualni prvek)
    .while:
        ; if (ECX <= 0) break;
        CMP ECX, 0
        JLE .end_while
        
        MOV EAX, array
        MOV EAX, [EAX] ; EAX = hodnota aktualniho prvku
        
        ; vyber smeru razeni
        CMP direction, DWORD 0
        JNE .desc
        ; asc razeni - vzestupne
        ; if (tmp >= hodnota aktualniho prvku) break;
        CMP tmp, EAX
        JGE .end_while
        JMP .do
        
        .desc:
        ; asc razeni - sestupne
        ; if (tmp <= hodnota aktualniho prvku) break;
        CMP tmp, EAX
        JLE .end_while
        
        .do:
        ; nasledujici prvek = aktualni prvek
        MOV EAX, array
        ADD EAX, 4 ; EAX = adresa nasledujiho prvku
        MOV EDX, array
        MOV EDX, [EDX] ; EDX = hodnota adresy aktualniho prvku
        MOV [EAX], EDX ; hodnota adresy nasledujiho prvku = hodnota aktualniho prvku

        DEC ECX ; dekrementace ECX
        SUB array, DWORD 4 ; posun adresy pole na predchozi prvek
        JMP .while ; skok do dalsi iterace vnitrniho cyklu
    
    .end_while:
    ; nasledujici prvek = tmp
    MOV EAX, array
    ADD EAX, 4 ; EAX = adresa nasledujiho prvku
    MOV EDX, tmp ; EDX = tmp
    MOV [EAX], EDX ; hodnot adresy nasledujiciho prvku = tmp
    
    POP DWORD array ; obnoveni adresy pole ze zasobniku po modifikaci vnitrnm cyklem
    ADD array, DWORD 4 ; posun adresy pole na dalsi prvek
    
    ; obnoveni ECX ze zasobniku a skok do dalsi iterace cyklu
    POP ECX
    JMP .for
    
.end_for:    
    POP EDX
    POP ECX
    POP EAX
    LEAVE
    RET
    
; Vypis pole
; arg1 - adresa pole pro vypis
; arg2 - velikost pole pro vypis
; arg3 - retezec vypisujici se pred vypisem pole
PrintArray:
    ENTER 0, 0
    PUSH EAX
    PUSH ECX
    PUSH ESI
    
    ; definice jmen pro parametry
    %define string [EBP + 16] ; arg3
    %define array_size [EBP + 12] ; arg2
    %define array [EBP + 8] ; arg1
    
    ; vypis info retezce a zavorky
    MOV ESI, string
    CALL WriteString
    MOV AL, '['
    CALL WriteChar
    
; for (ECX = (array_size - 1); ECX >= 0; ECX--)
    MOV ECX, array_size
    DEC ECX
.for:
    CMP ECX, 0
    JL .end_for
    
    ; vypis hodnoty na aktualni adrese pole
    MOV EAX, array
    MOV EAX, [EAX]
    CALL WriteInt32
    
    ADD array, DWORD 4 ; zvyseni adresy pole
    
    ; vypis oddelovace, pokud se nevypisuje posledni prvek
    CMP ECX, 0
    JE .no_delimieter
    MOV AL, ','
    CALL WriteChar
    
    .no_delimieter:
    ; dekrementace ECX a opakovani cyklu
    DEC ECX
    JMP .for
    
.end_for:
    ; vypis ukoncovaci zavorky a konce radku
    MOV AL, ']'
    CALL WriteChar
    CALL WriteNewLine
 
    POP ESI
    POP ECX
    POP EAX
    LEAVE
    RET
