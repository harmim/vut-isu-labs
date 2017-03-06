%include "rw32-2017.inc"

section .data
    sMessage db "Hello World!",EOL,0
    
section .text   
main:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    mov esi,sMessage	; ukazka volani funkce,
    call WriteString    ; ktera napise "Hello World!"
   
    xor eax, eax
    pop ebp
    ret