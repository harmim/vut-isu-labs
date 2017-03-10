%include "rw32-2017.inc"

; change ABRG to RGBA

section .data
    ABRG DD 0x80ABCDFF

section .text
main:
    MOV EBP, ESP
    
    ; EAX = RGAB
    MOV EAX, [ABRG]
    ROL EAX, 16
    
    MOV BL, AH ; BL = A
    MOV BH, AL ; BH = B
    
    ; AX = 0
    XOR AX, AX
    
    ; EAX = RGBA
    OR AX, BX

    XOR EAX, EAX
    RET