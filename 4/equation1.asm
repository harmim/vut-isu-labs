%include "rw32-2017.inc"

;Vypocet vyrazu ((a+b-4)*c)%a s naslednym ulozenim do eax a vypis

section .data
    A DD -100
    B DD 462
    C DD 6941
    
section .text
main:
    MOV EBP, ESP
    
    MOV EAX, [A] ; EAX = A
    ADD EAX, [B] ; EAX += B
    
    SUB EAX, 4 ; EAX -= 4
    
    IMUL DWORD [C] ; EDX:EAX = C * EAX
    
    CDQ
    IDIV DWORD [A] ; EAX = EDX:EAX / A ; EDX = EDX:EAX % A
    
    MOV EAX, EDX
    CALL WriteInt32

    XOR EAX, EAX
    RET