%include "rw32-2017.inc"

; Vypoèítejte výraz y=(a*2+c/2)%3, kde a a c jsou ukazatele na hodnoty o velikosti 16 bitù.

section .bss
    Y RESW 1

section .data
    A DW -10
    C DW 6
    
section .text
main:
    MOV EBP, ESP
    
    XOR EAX, EAX
    MOV AX, [A] ; AX = A
    XOR EBX, EBX
    MOV BX, 2 ; BX = 2
    IMUL BX ; DX:AX = 2 * AX
    MOV [Y], AX ; Y = AX
    
    XOR EAX, EAX
    MOV AX, [C] ; AX = C
    XOR EBX, EBX
    MOV BX, 2 ; BX = 2
    CWD ; rozsireni AX do DX:AX
    IDIV BX ; AX = DX:AX / BX ; DX = DX:AX % BX
    
    ADD [Y], AX ; Y += AX
    
    XOR EAX, EAX
    MOV AX, [Y] ; AX = Y
    XOR EBX, EBX
    MOV BX, 3 ; BX = 3
    CWD ; rozsireni AX do DX:AX
    IDIV BX ; AX = DX:AX / BX ; DX = DX:AX % BX
    MOV [Y], DX ; Y = DX
    
    MOV AX, [Y]
    CALL WriteInt16

    XOR EAX, EAX
    RET