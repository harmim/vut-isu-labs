%include "rw32-2017.inc"

section .data
    VAR_A DB 5
    VAR_B DB -2

section .text
main:
    MOV EBP, ESP; for correct debugging
    
    XOR EAX, EAX
    MOV AL, [VAR_A]
    
    ADD AL, [VAR_B]
   
    RET