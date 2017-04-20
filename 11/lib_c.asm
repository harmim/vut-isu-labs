; Prace s knihovnou jayzka C.
; Vypis komentaru ze vstupniho souboru .asm.
; Autor: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>

%include "rw32-2017.inc"

; externi funkce ze standardni knihovny jazyka C,
; ostatni pouzivane funkce se registruji v rw32-2017.inc
CEXTERN malloc
CEXTERN fopen
CEXTERN free
CEXTERN fclose

section .data
    BUFFER DD 0 ; buffer pro ulozeni radku souboru (ukazatel)
    BUFFER_SIZE DD 1000 ; velikost buffru pro radek souboru
    
    FILE DD 0 ; ukazatel na soubor
    S_FILE_OPEN_MODE DB "r", 0 ; mod otevreni vstupniho souboru
    ; vstupni soubor
    S_FILE_NAME DB "C:\Users\harmim\Disk Google\VUT\BIT\ISU\Cviceni\SASM-2017\Windows\Projects\11\lib_c.asm", 0
    S_FILE_OPEN_ERROR DB "Chyba pri otevirani souboru.", EOL, 0 ; hlaska pri chybe otevreni souboru
    
    S_COMMENT DB "Komentar:", EOL, "%s", EOL, 0 ; retezec pro vypis komentare (argument funkce printf)
    
    IS_STRING_FLAG DB 0 ; priznak obsahujici znak " nebo ' nebo 0, rika, jestli se nachazime uprostred retezce a jakeho

section .text
main:
    MOV EBP, ESP
    
    ; BUFFER = void *BUFFER = (void *)malloc(BUFFER_SIZE);
    PUSH DWORD [BUFFER_SIZE]
    CALL malloc
    ADD ESP, 4
    MOV [BUFFER],EAX
    
    ; FILE *FILE = fopen(S_FILE_NAME, "r");
    PUSH S_FILE_OPEN_MODE
    PUSH S_FILE_NAME
    CALL fopen
    ADD ESP, 8
    MOV [FILE], EAX
    
    ; if (FILE)
    CMP EAX, 0
    JE .fopen_error
    
; while(fgets(BUFFER, BUFFER_SIZE, FILE) != NULL)
.while:
    PUSH DWORD [FILE]
    PUSH DWORD [BUFFER_SIZE]
    PUSH DWORD [BUFFER]
    CALL fgets
    ADD ESP, 12
    CMP EAX, 0
    JE .end_while
    
    ; zacatek noveho radku, zatim se nevi, jestli jsme uprostred retezce, proto IS_STRING_FLAG bude 0
    MOV EAX, 0
    MOV [IS_STRING_FLAG], EAX
    
    ; for (; BUFFER != '0'; BUFFER++)
    MOV EAX, [BUFFER]
    .for_char:
        CMP BYTE [EAX], 0
        JE .while ; break;
        
        ; if (IS_STRING_FLAG != 0)
        MOV EBX, [IS_STRING_FLAG]
        CMP EBX, 0
        JE .not_string
        
        ; IS_STRING_FLAG != 0 - jsme uprostred retezce
        ; if (IS_STRING_FLAG == '"')
        CMP EBX, '"'
        JNE .apostrophe
        
        ; IS_STRING_FLAG == '"' - jsme urpostred retezce zacinajiciho znakem "
        ; if (BUFFER == '"')
        CMP BYTE [EAX], '"'
        JNE .continue
        
        ; aktualni znak je ", retezec konci
        MOV EBX, 0
        JMP .continue
        
        ; IS_STRING_FLAG == '\'' - jsme uprostred retezce zacinajiciho znakem '
        ; if (BUFFER == '\'')
        .apostrophe:
        CMP BYTE [EAX], 39
        JNE .continue
        
        ; aktualni znak je ', retezec konci
        MOV EBX, 0
        JMP .continue
        
        ; IS_STRING_FLAG == 0 - nejsme uprostred retezce
        .not_string:
        ; if (BUFFER == '"')
        CMP BYTE [EAX], '"'
        JNE .test_apostrophe
        
        ; zacatek retezce zacinajiciho znakem "
        MOV EBX, '"'
        JMP .continue
        
        ; if (BUFFER == '\'')
        .test_apostrophe:
        CMP BYTE [EAX], 39
        JNE .test_semicolon
        
        ; zacatek retezce zacinajiciho znakem '
        MOV EBX, 39
        JMP .continue
        
        ; if (BUFFER == ';')
        .test_semicolon:
        CMP BYTE [EAX], ';'
        JE .print_comment
        
        .continue:
        MOV [IS_STRING_FLAG], EBX
        INC EAX ; BUFFER++;
        JMP .for_char
    
        ; vypis komentare na STDOUT
        .print_comment:
        INC EAX ; BUFFER++;
        PUSH EAX
        PUSH S_COMMENT
        CALL printf
        ADD ESP, 8
        
        JMP .while
    
.end_while:
    ; fclose(FILE);
    PUSH DWORD [FILE]
    CALL fclose
    ADD ESP, 4
    JMP .exit
    
.fopen_error:
    ; printf(S_FILE_OPEN_ERROR);
    PUSH S_FILE_OPEN_ERROR
    CALL printf
    ADD ESP, 4
    
.exit:
    ; free(BUFFER);
    PUSH DWORD [BUFFER]
    CALL free
    ADD ESP, 4

    XOR EAX, EAX
    RET