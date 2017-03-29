; Uk?ka p??ladu na cykly se zn??m po?em iterac? v?stupem tohoto programu je vykreslen? vzor diamantu. Vstupn? parametrem
; je po?t ??ku jedn?poloviny diamantu. Program vych??z http://www.programmingsimplified.com/c/source-code/c-program-print-diamond-pattern.

%include "rw32-2017.inc"

section .text
main:
    mov ebp, esp

    xor eax,eax
    ;nacteni Uint8 ze stdin
    call ReadUInt8

    mov ebx, eax;ebx=n
    dec eax ;eax   space=n-+

    ;implementace cyklu for
    mov ecx, 1
    while1:
    cmp ebx,ecx
    jnge end ;n>=ecx opakuj
        mov edx, 1
        for_inner_1:
        cmp edx,eax
        JNLE end_inner_1 ;edx<=space opakuj
            push eax
            ;vypise znak
            mov al,' '
            call WriteChar
            pop eax
        inc edx
        jmp for_inner_1
        end_inner_1:

        dec eax
        push ecx

        ;2*k-1
        shl ecx,1
        dec ecx

        mov edx, 1
        for_inner_2:
        cmp edx,ecx
        JNLE end_inner_2  ;edx<=2*k-1 opakuj
            push eax
            ;vypise znak
            mov al,'*'
            call WriteChar
            pop eax
        inc edx
        jmp for_inner_2
        end_inner_2:

        call WriteNewLine
        pop ecx
    inc ecx
    jmp while1
    end:

    ;sapce=1, eax=space
    mov eax,1

    mov ecx, 1
    while2:
    cmp ebx,ecx  ;ecx<n opakuj
    jnge end2
        mov edx, 1
        for_inner_3:
        cmp edx,eax
        JNLE end_inner_3
            push eax
            ;vypise znak
            mov al,' '
            call WriteChar
            pop eax
        inc edx
        jmp for_inner_3
        end_inner_3:

        inc eax ; space ++

        push ecx
        push ebx

        ;(n-k)*2-1
        sub ebx, ecx
        shl ebx,1
        dec ebx
        mov ecx,ebx

        mov edx, 1
        for_inner_4:
        cmp edx,ecx
        JNLE end_inner_4
            push eax
            ;vypise znak
            mov al,'*'
            call WriteChar
            pop eax
        inc edx
        jmp for_inner_4
        end_inner_4:

        call WriteNewLine

        pop ebx
        pop ecx
    inc ecx
    jmp while2
    end2:

    xor eax, eax
    ret
