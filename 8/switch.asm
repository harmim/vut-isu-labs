%include "rw32-2017.inc"

; Jednoduchý pøíklad na switch s polem ukazatelù. V pøípadì, že na vstupu bude hodnota vìtší než 3
; nastaví se hodnota registru al na 4. Tato hodnota zajistí vykonání možnosti deafult v konstrukci switch.

section .data
    string0 db "Case 0: ....",0
    string1 db "Case 1: ....",0
    string2 db "Case 2: ....",0
    string3 db "Case 3: ....",0
    stringd db "Default: ....",0

    cases DD case_val0
          DD case_val1
          DD case_val2
          DD case_val3
          DD case_default

section .text
main:
    mov ebp, esp

    xor eax,eax
    call ReadUInt8

    ;pokryty interval 0-3
    cmp al,3
    jle continue
    mov al,4
    
continue:
    JMP dword [cases+4*(EAX)]
    
case_default:
    mov esi, stringd
    call WriteString
    jmp break
    
case_val0:
    mov esi, string0
    call WriteString
    jmp break
    
case_val1:
    mov esi, string1
    call WriteString
    jmp break
    
case_val2:
    mov esi, string2
    call WriteString
    jmp break
    
case_val3:
    mov esi, string3
    call WriteString

break:

    xor eax, eax
    ret
