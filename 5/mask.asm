%include "rw32-2017.inc"

; Proveïte vymaskování hodnoty v registru AX, maskou 0xFF0F

section .data
    MASK DD 0xFF0F

section .text
main:
    MOV EBP, ESP
    
    MOV EBX, 0xA1F8
    
    MOV EAX, EBX
    AND EAX, [MASK] ; EAX = 0xA108
    
    MOV EAX, EBX
    OR EAX, [MASK] ; EAX = 0xFFFF

    XOR EAX, EAX
    RET