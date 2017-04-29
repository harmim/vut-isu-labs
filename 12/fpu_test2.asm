; Test vypisu a cteni cisel s plovouci radovou carkou.

%include "rw32-2017.inc"

SECTION .data
    W_FLOAT DD -1234.5678
    W_DOUBLE DQ 2.718281828459045
    
    R_FLOAT DD 0.0
    R_DOUBLE DQ 0.0
    
    FRM_TISK DB "Cislo typu double pomoci printf: %f", EOL, 0

SECTION .text
main:
    MOV EBP, ESP
    
    ; vypis: 32-bitove cislo
    MOV EAX, [W_FLOAT]
    CALL WriteFloat
    CALL WriteNewLine
    
    ; vypis: 64-bitove cislo
    FLD QWORD [W_DOUBLE]
    CALL WriteDouble
    CALL WriteNewLine
    
    ; cteni: 32-bitove cislo
    CALL ReadFloat
    MOV [R_FLOAT], EAX
    CALL WriteFloat
    CALL WriteNewLine
    
    ; cteni: 64-bitove cislo
    CALL ReadDouble
    ; ulozeni nacteneho cisla do pameti
    FST QWORD [R_DOUBLE]
    CALL WriteDouble
    CALL WriteNewLine
    
    ; vypis: 64-bitove 'double' pomoci printf
    PUSH DWORD [R_DOUBLE + 4] ; 64-bitove cislo na 2x protoze ve 32-bitovem 
    PUSH DWORD [R_DOUBLE] ;  rezimu neni podporvana instrukce PUSH QWORD ...
    PUSH FRM_TISK
    CALL printf
    ADD ESP, 12 ; odstrani 4*3 byte ze zasobniku (parametry printf)

    XOR EAX, EAX
    RET