%include "rw32-2017.inc"

; Zamìòte horní polovinu hodnoty v registru EAX s hodnotou v registru BX

section .text
main:
    MOV EBP, ESP
    
    ; EAX = nahodne zvolene hexadecimalni cislo
    MOV EAX, 0xF1D3C8F2
    ; EBX = nahodne zvolene hexadecimalni cislo
    MOV EBX, 0x0000CCDD
    
    ; presun hornich 16 bitu EAX do spodnich 16 (AX)
    ROL EAX, 16
    ; vymena horni poloviny EAX (nyni AX) s BX
    XCHG AX, BX
    ; presun spodnich 16 bitu EAX do hornich 16
    ROR EAX, 16

    XOR EAX, EAX
    RET