%include "rw32-2017.inc"
    
section .text
main:
    MOV EBP, ESP
    
    ; MUL
    XOR EDX, EDX
    MOV EBX, 10 ; EBX = 10
    MOV EAX, 20 ; EAX = 20
    MUL EBX ; EDX:EAX = 10*20
    CALL WriteInt32
    CALL WriteNewLine
    
    ; IMUL
    XOR EDX, EDX
    MOV EBX, 10 ; EBX = 10
    MOV EAX, -20 ; EAX = -20
    IMUL EBX ; EDX:EAX = 10*-20
    CALL WriteInt32
    CALL WriteNewLine
    
    ; DIV
    XOR EDX, EDX
    MOV EAX, 106 ; EAX = 106
    MOV EBX, 10 ; EBX = 10
    DIV EBX ; EAX = 106 / 10 ; EDX = 106 % 10
    CALL WriteInt32
    CALL WriteNewLine
    MOV EAX, EDX
    CALL WriteInt32
    CALL WriteNewLine
    
    ; IDIV
    MOV EAX, -106 ; EAX = -106
    CDQ ; znamenkove rozsireni EAX do EDX:EAX
    MOV EBX, 10 ; EBX = 10
    IDIV EBX ; EAX = -106 / 10 ; EDX = -106 % 10
    CALL WriteInt32
    CALL WriteNewLine
    MOV EAX, EDX
    CALL WriteInt32
    CALL WriteNewLine

    XOR EAX, EAX
    RET