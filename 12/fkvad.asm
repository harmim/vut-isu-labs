; Vypocet kvadraticke rovnice.

%include "rw32-2017.inc"

SECTION .data
    res1 DD 0.0
    res2 DD 0.0

    VAR_A DD 16.0
    VAR_B DD 8.0
    VAR_C DD 1.0

    str_formatR DB "2 ruzne realne koreny:",EOL,"x1 = %f",EOL,"x2 = %f",EOL,0
    str_formatD DB "1 dvojnasobny realny koren:",EOL,"x1 = x2 = %f",EOL,0
    str_formatI DB "2 komplexne sdruzene koreny:",EOL,"x1 = %f + %fi",EOL,"x2 = %f - %fi",EOL,0
    str_error   DB "Chyba! Neocakavany vysledek reseni kvadraticke rovnice.",EOL,0

SECTION .text
main:
    MOV EBP, ESP

    PUSH res2
    PUSH res1
    PUSH DWORD [VAR_C]
    PUSH DWORD [VAR_B]
    PUSH DWORD [VAR_A]
    CALL kvadraticka_rovnice
    ADD ESP,20

    CMP AL,'I'
    JNZ .not_complex

    SUB ESP,32
    FLD dword [res2]
    FST qword [ESP + 24]
    FLD dword [res1]
    FST qword [ESP + 16]
    FXCH st0,st1
    FSTP qword [ESP + 8]
    FSTP qword [ESP]
    PUSH str_formatI
    CALL printf
    ADD ESP,36
    JMP .exit

.not_complex:
    CMP AL,'D'
    JNZ .not_double_real

    SUB ESP,8
    FLD dword [res1]
    FST qword [ESP]
    PUSH str_formatD
    CALL printf
    ADD ESP,12
    JMP .exit

.not_double_real:
    CMP AL,'R'
    JNZ .not_real

    SUB ESP,16
    FLD dword [res2]
    FSTP qword [ESP + 8]
    FLD dword [res1]
    FSTP qword [ESP]
    PUSH str_formatR
    CALL printf
    ADD ESP,20
    RET

.not_real:
    MOV ESI,str_error
    CALL WriteString
    CALL WriteNewLine

.exit:
    XOR EAX, EAX
    RET

; char kvadraticka_rovnice(float a, float b, float c, float *p_result1, float *p_result2);

; Vstup
;   a, b, c - parametry rovnice
;   p_result1, p_result2 - ukazatele na mista v pameti, kam ulozit vysledek
; Vystup
;   AL = 'I' - komplexne sdruzene koreny
;   AL = 'R' - realne koreny
;   AL = 'D' - dvojnasobny realny koren
;   prvni vysledek na adrese 'p_result1'
;   druhy vysledek na adrese 'p_result2'
; Obsah zasobniku:
;   p_result1   <- [EBP + 24]
;   p_result2   <- [EBP + 20]
;   c           <- [EBP + 16]
;   b           <- [EBP + 12]
;   a           <- [EBP + 8]
;   EIP         <- [EBP + 4]
;   stare EBP   <- [EBP]
kvadraticka_rovnice:
%define a EBP+8
%define b EBP+12
%define c EBP+16
%define p_result1 EBP+20
%define p_result2 EBP+24

; Rovnice: ax^2 + bx + c = 0 (x1, x2)
; Reseni 1: x1 = (-B-SQRT(B*B - 4*A*C))/2A
; Reseni 2: x2 = (-B+SQRT(B*B - 4*A*C))/2A

; Diskriminant: D = B*B - 4*A*C

; D < 0 ... komplexne sdruzene
;   x1 = -b/2a
;   x2 = sqrt(-D)/2a

; D = 0 ... realny, 2nasobny
;   x1 = -b/2a

; D > 0 ... 2 realne koreny
;   x1 = (-b + sqrt(D))/2a
;   x2 = (-b - sqrt(D))/2a

; komponenty potrebne pro vypocet: -B, B^2, 4AC, 2A

    PUSH EBP
    MOV EBP,ESP

    FINIT                    ;ST0    ST1    ST2    ST3    ST4
    FLD dword [a]            ;A
    FLD ST0                  ;A      A
    FMUL dword [c]           ;AC     A
    FADD ST0,ST0             ;2AC    A
    FADD ST0,ST0             ;4AC    A
    FXCH ST1                 ;A      4AC
    FADD ST0,ST0             ;2A     4AC
    FLD dword [b]            ;B      2A     4AC
    FCHS                     ;-B     2A     4AC
    FLD ST0                  ;-B     -B     2A     4AC
    FMUL ST0,ST0             ;B^2    -B     2A     4AC
    FSUB ST0,ST3             ;D      -B     2A     4AC
    FTST                     ;"ST(0)?  0"

    FSTSW AX                 ;"B,C3,TOP,C2,C1,C0..."
    SAHF
    JA .real_single          ;"ST(0) > 0"
    JE .real_double          ;"ST(0) == 0"

    MOV AL,'I'               ;D<0    -B     2A     4AC
                            ;reseni ma komplexne sdruzene koreny
    FCHS                     ;-D     -B     2A     4AC
    FSQRT                    ;-D^1/2 -B     2A     4AC
    FDIV ST0,ST2             ;I      -B     2A     4AC
    MOV EDI,[p_result2]
    FSTP dword [EDI]         ;-B     2A     4AC
    FDIV ST0,ST1             ;R      2A     4AC
    MOV EDI,[p_result1]
    FSTP dword [EDI]         ;2A     4AC
    JMP .exit

.real_double:                   ;reseni ma realny dvojnasobny koreny
    MOV AL,'D'               ;D=0    -B     2A     4AC
    FCOMP ST1                ;-B     2A     4AC
    FDIV ST0,ST1             ;R      2A     4AC
    MOV EDI,[p_result1]
    FST dword [EDI]          ;R      2A     4AC
    MOV EDI,[p_result2]
    FSTP dword [EDI]         ;2A     4AC
    JMP .exit

.real_single:                   ;reseni ma dva realne koreny
    MOV AL,'R'               ;D>0    -B     2A     4AC
    FSQRT                    ;D^1/2  -B     2A     4AC
    FLD ST0                  ;D^1/2  D^1/2  -B     2A     4AC
    FADD ST0,ST2             ;CIT1   D^1/2  -B     2A     4AC
    FDIV ST0,ST3             ;R1     D^1/2  -B     2A     4AC
    MOV EDI,[p_result1]
    FSTP dword [EDI]         ;D^1/2  -B     2A     4AC
    FSUBP ST1,ST0            ;CIT2   2A     4AC
    FDIV ST0,ST1             ;R2     2A     4AC
    MOV EDI,[p_result2]
    FSTP dword [EDI]         ;2A     4AC

.exit:
    FCOMPP                   ;

    MOV ESP,EBP
    POP EBP
    RET
