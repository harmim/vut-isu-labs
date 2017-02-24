%include "rw32-2017.inc"

section .bss
    ; rezervace pameti o velikosti 16b
    RES RESW 1

section .data
    ; inicializace pametoveho mista o velikosi 32 bitu 
    VAR_A DD 600256
    ; inicializace pole s 5 16b polozkami
    NUMBERS DW 10, 30, 50, 100, 125
    ; inicializace pole bajtu
    STRING DB "abcdef", 0

section .text
main:
    MOV EBP, ESP  ; pro spravny debugging
    
    XOR EAX, EAX ; EAX = 0
    XOR ECX, ECX ; ECX = 0
    MOV EBX, NUMBERS ; EBX = adresa na NUMBERS
    MOV AX, [NUMBERS] ; AX = 10
    MOV CX, [NUMBERS + 2] ; CX = 30
    ADD AX, CX ; AX = 10 + 30 = 40
    CALL WriteInt16 ; vypis vysledku 40
    MOV [RES], AX ; ulozeni vysledku na adresu oznacenou RES
    
    CALL WriteNewLine ; vypis noveho radku
    
    XOR EAX, EAX ; EAX = 0
    MOV ESI, STRING ; ESI = adresa na STRING
    ; vypis 1. znaku retezce
    MOV AL, [STRING]
    CALL WriteChar
    ; vypis 2. znaku retezce
    MOV AL, [STRING + 1]
    CALL WriteChar
    ; vypis 3. znaku retezce
    MOV AL, [STRING + 2]
    CALL WriteChar

    RET