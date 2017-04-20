; Battleship - lode
; Autor: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
; zatim nefunguje

%include "rw32-2017.inc"

extern _print_ships
extern @hit_check@8
extern _shot@8
extern _printf
extern _get_pointer_to_hits

section .data
    ; informace o lodi jsou ulozeny v polich za sebou,
    ; kazda polozka obsahuje data v tomto poradi: x, y, sirka, vyska,
    ; kde x,y je souradnice horniho rohu,
    ; v nize uvedenych datech jsou definovane 3 lode
    SHIPS_DATA DD 10, 10, 30, 70
               DD 220, 200, 50, 20
               DD 300, 400, 70, 30
               DD 15, 200, 120, 30
    SHIPS_COUNT DD 4
     
    HIT_STR DB 10, "******Zasah!******", 10, 0
    NOHIT_STR DB 10, "******Vedle!******", 10, 0
     
    AREA_W DD 500
    AREA_H DD 500
 
    COUNT_HITS DD 1
    
    ENTER_X_STR DB "Zadejte souradnici X pro vystrel: ", EOL, 0
    ENTER_Y_STR DB "Zadejte souradnici Y pro vystrel: ", EOL, 0

section .text
main:
    MOV EBP, ESP
    
    PUSH DWORD 3
    CALL ReadShots
    ADD ESP, 4
    
    CALL CheckHits
    
    CALL PrintShips

    XOR EAX, EAX
    RET
    
; UKOL c.1
; Nactete ze vstupu pomoci ReadUInt32 souradnici x a nasledne opet pomoci ReadUInt32 y
; Po nacteni vystrelu zavolejte funkci _shot@8, urcete o jakou konvenci se jedna a spravne ji pouzijte
; Funkce je deklarovana jako: void shot(int x, int y)
; Funkce provede zaznamenani pozice cile a bude si ho pamatovat pro dalsi casti prikladu
; Nactete ze stdin alespon 3 pozice kam maji dopadnout rakety
ReadShots:
    ENTER 2, 0
    PUSH EAX
    PUSH ECX
    PUSH ESI
 
    %define number_of_shots [EBP + 8]
    %define x [EBP - 4]
    %define y [EBP - 8]
          
    MOV ECX, number_of_shots
.for:
    CMP ECX, 0
    JLE .end_for
    
    MOV ESI, ENTER_X_STR
    CALL WriteString
    CALL ReadUInt32
    MOV x, EAX
    
    MOV ESI, ENTER_Y_STR
    CALL WriteString
    CALL ReadUInt32
    MOV y, EAX
    
    CALL WriteNewLine
    
    PUSH DWORD y
    PUSH DWORD x
    CALL _shot@8
    ADD ESP, 8
    
    DEC ECX
    JMP .for
    
.end_for:
    POP ESI
    POP ECX
    POP EAX
    LEAVE
    RET
    
; UKOL volitelny
; Zkuste pomoci funkce z jazyka C T_shot * get_pointer_to_shots(int * shots_count) ziskat hodnotu ukazatele
; a vypsat si pomoci debugeru pamet, kde jsou ulozene souradnice
    
; UKOL c.2
; Pomoci funkce @hit_check@8 zkontrolujte, zda doslo k zasahu,
; nasledne vypiste pomoci funkce printf text zacinajici na adresach hit_str nebo nohit_str
; Funkce je deklarovana jako: char hit_check(int *ships, int ship_count)
; int *ships - ukazatel pole poli s lodemi
; int ship_count - celkovy pocet lodi
; Pokud doslo k zasahu nejake lodi nejakou strelou, tak vrati 1, jinak 0
CheckHits:
    ENTER 0, 0
    
    PUSH SHIPS_DATA
    PUSH DWORD [SHIPS_COUNT]
    CALL @hit_check@8
    ADD ESP, 8
    
.if:
    CMP EAX, 1
    JNE .else
    
    PUSH HIT_STR
    
    JMP .end_if
.else:
    
    PUSH NOHIT_STR
    
.end_if: 

    CALL _printf
    ADD ESP, 4

    LEAVE
    RET
  
; UKOL c.3
; Vykreslete hraci pole pomoci funkce _print_ships
; Funkce je deklarovana jako: void print_ships(int area_w, int area_h, int *ships, int ship_count)  
PrintShips:
    ENTER 0, 0
    
    PUSH DWORD [SHIPS_COUNT]
    PUSH SHIPS_DATA
    PUSH DWORD [AREA_H]
    PUSH DWORD [AREA_W]
    CALL _print_ships
    ADD ESP, 16
    
    LEAVE
    RET
    
; UKOL c.4
; Vypiste pozice x a y lodi do souboru isu.txt

; UKOL c.5
; Udelejte kontrolu, zda raketa nemiri mimo hraci plochu promena area_w a area_h
