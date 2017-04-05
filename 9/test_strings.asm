%include "rw32-2017.inc"

section .data
    string1 db "Hello",0
    string2 db "World",0

section .text
main:
    mov ebp, esp

    cld ;nastaveni priznaku smeru na 0
    MOV ESI,string1
    MOV EDI,string2
    MOV ECX,5

    call writeString1String2

    ;Provede porovnani retezcu, REPE opakuje tak dlouho dokud jsou retzece ekvivalentni (ZF=1), delka je nastavena v registru ECX
    REPE CMPSB

    ;ulozi prvni byte retezce do AL
    MOV ESI,string1
    MOV EDI,string2
    LODSB

    ;instrukce vezme byte z AL a ulozi ho na pametove misto urcene ukazatele EDI
    STOSB

    call writeString1String2

    MOV ESI,string1
    MOV EDI,string2
    MOV ECX,5
    ;Kopiruje retezec, na zdroj ukazuje ESI, na cil EDI, delka je dana hodnotou v ECX
    REP MOVSB

    call writeString1String2

    xor eax, eax
    ret

writeString1String2:
    MOV ESI,string1
    call WriteString
    call WriteNewLine
    MOV ESI,string2
    call WriteString
    call WriteNewLine
    call WriteNewLine
    ret
