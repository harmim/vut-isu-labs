%include "rw32-2017.inc"

; vyraz y=((x^2)*13+37*x+87)/(21*z)

section .bss
    RESULT RESD 1

section .data
    VAR_X DD 19
    VAR_Z DD 32

section .text
main:
    MOV EBP, ESP
    
    MOV EAX, [VAR_X] ; EAX = x
    XOR EDX, EDX
    IMUL EAX ; EDX:EAX = EAX^2
    MOV EBX, 13 ; EBX = 13
    IMUL EBX ; EDX:EAX = EBX*EAX
    MOV [RESULT], EAX ; RESULT = EAX
    
    MOV EAX, [VAR_X] ; EAX = x
    MOV EBX, 37 ; EBX = 37
    IMUL EBX ; EDX:EAX = EBX*EAX
    ADD EAX, [RESULT] ; EAX += RESULT
    MOV [RESULT], EAX ; RESULT = EAX
    
    MOV EBX, 87 ; EBX = 87
    ADD [RESULT], EBX ; RESULT += EBX
    
    MOV EAX, [VAR_Z] ; EAX = z
    MOV EBX, 21 ; EBX = 21
    IMUL EBX ; EDX:EAX = EBX*EAX
    
    MOV EBX, EAX ; EBX = EAX
    MOV EAX, [RESULT] ; EAX = RESULT
    CDQ ; rozsireni EAX do EDX:EAX
    IDIV EBX ; EAX = EDX:EAX / EAX
    MOV [RESULT], EAX ; RESULT = EAX
    
    MOV EAX, [RESULT]
    CALL WriteInt32

    XOR EAX, EAX
    RET