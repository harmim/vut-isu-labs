%include "rw32-2017.inc"

; generovani priznaku PF a CF pomoci instrukce ADD

section .text
main:
    MOV EBP, ESP
    
    MOV AL, -50 ; AL = 11001110
    MOV BL, 101 ; BL = 01100101
    XOR AH, AH ; AH = 0
    SAHF ; FLAGS = 0
    ADD AL, BL ; AL =  00110011
    
    ;;;;; CF = 1 && PF = 1

    XOR EAX, EAX
    RET