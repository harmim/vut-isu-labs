%include "../rw32-2015.inc"

section .data
    VAR_A DB 10
    VAR_B DB 20

section .text
main:
    MOV AL, [SF]
    CALL WriteInt8
