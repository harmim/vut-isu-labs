%include "rw32-2015.inc"

section .data
    STRING DB "abc", 0
    NUMBERS DB 10, 30, 50, 100

section .text
main:
    mov ebp, esp
    
    MOV EBX, STRING
    MOV AL, [EBX]
    CALL WriteChar
    
    ;ADD EBX, 1
    INC EBX
    MOV AL, [EBX]
    CALL WriteChar
    
    ;ADD EBX, 1
    INC EBX
    MOV AL, [EBX]
    CALL WriteChar
    
    MOV EBX, NUMBERS
    XOR EAX, EAX
    XOR ECX, ECX
    MOV AX, [EBX]
    MOV CX, [EBX+3]

    xor eax, eax
    ret