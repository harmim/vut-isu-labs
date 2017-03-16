%include "rw32-2017.inc"

; vypocitani vyrazu y=(b+a%b)/(c/5)
; vysledek bude v EAX

section .data
    A DB 64
    B DB 12
    C DB 25

section .text
main:
    MOV EBP, ESP
    
    MOVZX AX, [A] ; AX = zeroextended(A)
    DIV BYTE [B] ; AH = A % B
    MOV BL, AH ; BL = A % B
    
    ADD BL, [B] ; BL = B + A % B
    
    MOVZX AX, [C] ; AX = zeroextened(C)
    MOV CL, 5 ; CL = 5
    DIV CL ; AL = C / 5
    MOV CL, AL ; CL = C / 5
    
    MOVZX AX, BL ; AX = B + A % B
    DIV CL ; AL = (B + A % B) / (C / 5)
    MOVZX EAX, AL ; EAX = zeroextended(AL)
    
    ;;;;; EAX = Y

    XOR EAX, EAX
    RET