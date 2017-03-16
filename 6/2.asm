%include "rw32-2017.inc"

; definice pole se tremi 32 bitovymi hodnotami
; odecteni prvniho a druheho prvku od nulteho prvku, vysledek bude v AX

section .data
    ARR DD 0xA, 0xB, 0xC

section .text
main:
    MOV EBP, ESP
    
    MOV EAX, [ARR] ; EAX = 0xA
    MOV EBX, [ARR + 4] ; EBX = 0xB
    SUB EAX, EBX ; EAX = 0xFF
    
    MOV EBX, [ARR + 8] ; EBX = 0xC
    SUB EAX, EBX ; EAX = 0xF3
    
    ;;;;; AX = vysledek

    XOR EAX, EAX
    RET