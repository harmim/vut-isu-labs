; Autor: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
; Pohyb na dvourozmernem poli X*Y stiskem numerickych sipek na klavesnici.

%include "rw32-2017.inc"

section .data
    ENTER_VALUE_STR DB "Zadejte smer (8 - nahoru; 2 - dolu; 4 - vlevo; 6 - vpravo):", EOL, 0
    
    SIZE_OF_AREA_STR DB "Velikost plochy: ", 0
    SIZE_OF_AREA DD 8, 8 ; velikost plochy (x,y)
    
    CURRENT_COORDINATES_STR DB "Aktualni souradnice: ", 0
    CURRENT_COORDINATES DD 0, 0 ; aktualni souradnice (x,y)
    
    ; pole hodnot a ukazatelu na navesti pro switch na zpracovani stisknutych klaves
    MOVE_CASES DD 8, ProcessUp
               DD 2, ProcessDown
               DD 4, ProcessLeft
               DD 6, ProcessRight
               
   EMPTY_FIELD_STR DB " - ", 0 ; znak pro prazdnou bunku pole
   NON_EMPTY_FILED_STR DB " X ", 0 ; znak pro neprazdnou (aktualni) bunku pole

section .text
main:
    MOV EBP, ESP
    
    ; vypis velikosti plochy
    PUSH SIZE_OF_AREA_STR
    PUSH DWORD [SIZE_OF_AREA + 4]
    PUSH DWORD [SIZE_OF_AREA]
    CALL WriteCoordinates
    
    MOV ESI, ENTER_VALUE_STR ; ulozeni ukazatele na vyzvu zadani hodnoty smeru do ESI, protoze se vypisuje v kazde iteraci cyklu
    
; nekonecny cyklus, ktery zpracovava zadany smer, vypisuje a vykresluje zmenu pozice
.while:
    ; vypis aktualni pozice
    PUSH DWORD CURRENT_COORDINATES_STR
    PUSH DWORD [CURRENT_COORDINATES + 4]
    PUSH DWORD [CURRENT_COORDINATES]
    CALL WriteCoordinates
    
    ; vykresleni plochy a aktualni pozice v ni
    CALL DrawArea
    
    ; cekani na zadani smeru pohybu z klavesnice (vypise se zadost, protoze v ESI je ENTER_VALUE_STR)
    CALL WriteString 
    CALL ReadInt8 ; hodnota se ulozi do AL
    
; cyklus pres vsechny pripustne klavesy ulozene v MOVE_CASES a zavolani patricne funkce podle stisknute klavesy
    MOV ECX, 4 ; iterator cyklu
.case_loop:
    CMP AL, [MOVE_CASES + 8 * ECX - 8]
    JE .match
    LOOP .case_loop
    JMP .while
    
; zavolani funkce podle stisknute klavesy (v ECX je pozice funkce v poli MOVE_CASES)
.match:
    CALL DWORD [MOVE_CASES + 8 * ECX - 4]
    JMP .while
    
; Zpracovani stisku klavesy "nahoru".
ProcessUp:
    PUSH EAX
    
    ; zvyseni hodnoty osy Y, pokud uz neni na hranici
    MOV EAX, [SIZE_OF_AREA + 4]
    DEC EAX
    CMP DWORD [CURRENT_COORDINATES + 4], EAX
    JGE .return
    INC DWORD [CURRENT_COORDINATES + 4]
    
.return:
    POP EAX
    RET
    
; Zpracovani stisku klavesy "vpravo".
ProcessRight:
    PUSH EAX
    
    ; zvyseni hodnoty osy X, pokud uz neni na hranici
    MOV EAX, [SIZE_OF_AREA]
    DEC EAX
    CMP DWORD [CURRENT_COORDINATES], EAX
    JGE .return
    INC DWORD [CURRENT_COORDINATES]
    
.return:
    POP EAX
    RET

; Zpracovani stisku klavesy "dolu".
ProcessDown:
    ; snizeni hodnoty osy Y, pokud uz neni na hranici
    CMP DWORD [CURRENT_COORDINATES + 4], 0
    JLE .return
    DEC DWORD [CURRENT_COORDINATES + 4]
    
.return:
    RET

; Zpracovani stisku klavesy "vlevo".
ProcessLeft:
    ; snizeni hodnoty osy X, pokud uz neni na hranici
    CMP DWORD [CURRENT_COORDINATES], 0
    JLE .return
    DEC DWORD [CURRENT_COORDINATES]
    
.return:
    RET

; Vypis souradnic a jejich popisku.
; arg1 - souradnice X
; arg2 - souradnice Y
; arg3 - ukazatel na retezec, ktery se vypise pred vypisem souradnic
WriteCoordinates:
    ENTER 0,0
    PUSH EAX
    PUSH ESI

    ; vypis popisku
    MOV ESI, [EBP + 16]
    CALL WriteString
    
    MOV AL, '('
    CALL WriteChar

    ; vypis souradnice X
    MOV EAX, [EBP + 8]
    CALL WriteInt32
    
    MOV AL, ','
    CALL WriteChar
    
    ; vypis souradnice Y
    MOV EAX, [EBP + 12]
    CALL WriteInt32
    
    MOV AL, ')'
    CALL WriteChar
    
    CALL WriteNewLine
    
    POP ESI
    POP EAX
    LEAVE
    RET 12
    
; Vykresleni plochy a aktualni pozice v ni.
DrawArea:
    PUSH EAX
    PUSH EBX
    PUSH ESI
    
    MOV EAX, [SIZE_OF_AREA + 4] ; citac pro cyklus radku (Y), zacina od nejvyssi hodnoty osy Y (size_y - 1)
    DEC EAX
    
; while (EAX >= 0) - pruchod pres vsechny radky (sestupne)
.while_x:
    CMP EAX, 0
    JL .end_while_x
    
    XOR EBX, EBX ; citac pro cyklus sloupcu (X), zacina od 0
    
    ; while (EBX < size_x) - pruchod pres vsechny sloupce v danem radku (vzestupne)
    .while_y:
        CMP EBX, [SIZE_OF_AREA]
        JGE .end_while_y
        
    ; pokud je dana pozice aktualni, vypise se NON_EMPTY_FILED_STR, jinak EMPTY_FIELD_STR
    ; if (EAX == CURRENT_Y && EBX == CURRENT_X)
    .if:
        CMP EAX, [CURRENT_COORDINATES + 4]
        JNE .else
        CMP EBX, [CURRENT_COORDINATES]
        JNE .else
        ; vypis NON_EMPTY_FILED_STR - dana pozice je aktualni
        MOV ESI, NON_EMPTY_FILED_STR
        CALL WriteString
        JMP .endif
        
    .else:
        ; vypis EMPTY_FIELD_STR - dana pozice neni aktualni
        MOV ESI, EMPTY_FIELD_STR
        CALL WriteString
        
    .endif:
        INC EBX ; zvyseni citace sloupcu
        JMP .while_y
    
    .end_while_y:
    
    CALL WriteNewLine
    DEC EAX ; snizeni citace radku
    JMP .while_x
    
.end_while_x:

    CALL WriteNewLine
    
    POP ESI
    POP EBX
    POP EAX
    RET
