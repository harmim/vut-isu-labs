; (N1 - N2) / N3

%include "rw32-2017.inc"

SECTION .data
    N1 DD 31
    N2 DD 13
    N3 DQ 5.0

SECTION .text
main:
    MOV EBP, ESP
    
    FILD DWORD [N1]
    FISUB DWORD [N2]
    FDIV QWORD [N3]   
    CALL WriteDouble

    XOR EAX, EAX
    RET