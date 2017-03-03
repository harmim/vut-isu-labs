%include "rw32-2017.inc"

section .bss
    SUM_RESULT RESQ 1
    SUB_RESULT RESQ 1

section .data
    VAR_A DQ 548454531123
    VAR_B DQ 189465144132

section .text
main:
    MOV EBP, ESP
    
    ; SUM
    MOV EAX, [VAR_A]
    MOV EBX, [VAR_A + 4]
    ADD EAX, [VAR_B]
    ADD EBX, [VAR_B + 4]
    MOV [SUM_RESULT], EAX
    MOV [SUM_RESULT + 4], EBX
    
    ; SUB
    MOV EAX, [VAR_A]
    MOV EBX, [VAR_A + 4]
    SUB EAX, [VAR_B]
    SUB EBX, [VAR_B + 4]
    MOV [SUB_RESULT], EAX
    MOV [SUB_RESULT + 4], EBX

    XOR EAX, EAX
    RET