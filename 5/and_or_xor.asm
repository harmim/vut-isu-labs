%include "rw32-2017.inc"

section .data
    RGB DB 0b11001010
    SET DB 0b00000111 
    NEW_RGB DB 0b10101010
    MASK DB 0b00111111

section .text
main:
    MOV EBP, ESP
    
    ; vyuluje prvni dva bity RGB
    MOV AL, [MASK]
    AND [RGB], AL
    
    ; nastavi posledni tri bity RGB
    MOV AL, [SET]
    OR [RGB], AL
    
    ; vynuluje RGB
    MOV AL, [RGB]
    XOR AL, AL
    MOV [RGB], AL
    
    ; nastavi RGB na novou hodnotu
    MOV AL, [NEW_RGB]
    OR [RGB], AL

    XOR EAX, EAX
    RET