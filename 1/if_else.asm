%include "rw32-2017.inc"

section: .data
    VAR_A DW 5
    VAR_B DW 4
    S_A_GREATER DB "A je vetsi.", EOL, 0
    S_A_SMALLER DB "A je mensi.", EOL, 0

section: .text
main:
    MOV EBP, ESP ; for correct debugging
    
    XOR EAX, EAX
    ADD AX, [VAR_A]
    CMP [VAR_B], AX
    JL AGreater
    JG ASmaller
    	
    RET

AGreater:
    MOV ESI, S_A_GREATER
    CALL WriteString

    RET

ASmaller:
    MOV ESI, S_A_SMALLER
    CALL WriteString

    RET

