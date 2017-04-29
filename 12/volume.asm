; objem kvadru ze zadanych cisel a odecteni objemu koule a porovnani rozdilu s objemem koule

%include "rw32-2017.inc"

SECTION .data
    STR_BLOCK_ENTER DB "Zadejte rozmery kvadru", EOL, 0
    STR_BLOCK_X DB "strana X: ", EOL, 0
    STR_BLOCK_Y DB "strana Y: ", EOL, 0
    STR_BLOCK_Z DB "strana Z: ", EOL, 0
    STR_ORB_ENTER DB "Zadejte rozmery koule", EOL, 0
    STR_ORB_R DB "polomer r: ", EOL, 0
    STR_ORB_V DB "Objem koule: ", 0
    STR_DIFF_V DB "Zbyly objem kvadru: ", 0
    STR_DIFF_GREATER DB "Koule nezaplnuje vetsinu objemu v kvadru.", EOL, 0
    STR_ORB_GREATER DB "Koule zaplnuje vetsinu objemu v kvadru.", EOL, 0
    
    BLOCK_X DQ 0
    BLOCK_Y DQ 0
    BLOCK_Z DQ 0
    ORB_R DQ 0
    
    BLOCK_V DQ 0
    ORB_V DQ 0
    DIFF DQ 0
    
    ORB_V_CONST_4 DD 4
    ORB_V_CONST_3 DD 3

SECTION .text
main:
    MOV EBP, ESP
    
    ; rozmery kvadru
    MOV ESI, STR_BLOCK_ENTER
    CALL WriteString
    
    ; strana X
    MOV ESI, STR_BLOCK_X
    CALL WriteString
    CALL ReadDouble
    FSTP QWORD [BLOCK_X] ; BLOCK_X = ST0
    
    ; strana Y
    MOV ESI, STR_BLOCK_Y
    CALL WriteString
    CALL ReadDouble
    FSTP QWORD [BLOCK_Y] ; BLOCK_Y = ST0
    
    ; strana Z
    MOV ESI, STR_BLOCK_Z
    CALL WriteString
    CALL ReadDouble
    FSTP QWORD [BLOCK_Z] ; BLOCK_Z = ST0
    
                         ; ST0
    FLD QWORD [BLOCK_X]  ; X
    FMUL QWORD [BLOCK_Y] ; X*Y
    FMUL QWORD [BLOCK_Z] ; X*Y*Z
    FSTP QWORD [BLOCK_V] ; BLOCK_V = ST0
    
    
    ; rozmery koule
    MOV ESI, STR_ORB_ENTER
    CALL WriteString
    
    ; polomer R
    MOV ESI, STR_ORB_R
    CALL WriteString
    CALL ReadDouble
    FSTP QWORD [ORB_R] ; ORB_R = ST0
    
                                ; ST0             ST1  ST2  ST3
    FILD DWORD [ORB_V_CONST_4]  ; 4
    FIDIV DWORD [ORB_V_CONST_3] ; 4/3
    FLDPI                       ; PI              4/3
    TIMES 2 FLD QWORD [ORB_R]   ; R               R    PI   4/3
    FMUL ST0                    ; R^2             R    PI   4/3
    FMUL ST1                    ; R^3             R    PI   4/3
    FMUL ST2                    ; (R^3)*PI        R    PI   4/3
    FMUL ST3                    ; (R^3)*PI*(4/3)  R    PI   4/3
    FSTP QWORD [ORB_V] ; ORB_V = ST0
    
    FLD QWORD [BLOCK_V] ; ST0 = BLOCK_V
    FSUB QWORD [ORB_V] ; ST0 = BLOCK_V - ORB_V
    FSTP QWORD [DIFF] ; DIFF = BLOCK_V - ORB_V
    
    ; zbyly objem kvadru
    FLD QWORD [DIFF]
    MOV ESI, STR_DIFF_V
    CALL WriteString
    CALL WriteDouble
    CALL WriteNewLine
    
    ; objem koule
    FLD QWORD [ORB_V]
    MOV ESI, STR_ORB_V
    CALL WriteString
    CALL WriteDouble
    CALL WriteNewLine
    
    FCOMI ST1 ; CMP ORB_V, DIFF
    JA .else
    MOV ESI, STR_DIFF_GREATER
    JMP .end_if
    
.else:
    MOV ESI, STR_ORB_GREATER
    
.end_if:
    CALL WriteString

    XOR EAX, EAX
    RET