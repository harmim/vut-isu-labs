; Autor: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
; Nahrazovani danych podretezcu danym retezcem v danem retezci

%include "rw32-2017.inc"

SECTION .bss
    TMP_STRING RESB 500 ; alokovany prostor pro docasne ulozeni retezce (500B)
    ; alokovany prostor pro vysledny retezec, protoze muze byt i
    ; delsi nez vstupni, napr. kdyz nahrazovaci retezec bude delsi (500B)
    RESULT_STRING RESB 500

SECTION .data
    ; vstupni hodnoty
    ;STRING DB "ahoj-vychodit-foo-chodit-dochodit", 0 ; vstupni retezec
    ;SUBSTRING DB "chodit", 0 ; hledany podretezec
    ;REPLACE_STRING DB "behat", 0 ; nahrazovaci retezec
    STRING DB "ahoj-vyprcat-prcat-zaprcat-naprcat-doprcat-fuck-off", 0 ; vstupni retezec
    SUBSTRING DB "prcat", 0 ; hledany podretezec
    REPLACE_STRING DB "jebat", 0 ; nahrazovaci retezec
    
    ; vystupni hlasky
    STRING_INFO DB "Vstupni retezec: ", 0
    SUBSTRING_INFO DB "Hledany retezec: ", 0
    REPLACE_STRING_INFO DB "Nahrazovaci retezec: ", 0
    RESULT_STRING_INFO DB "Vystupni retezec: ", 0
    
    ; delky retezcu (program je pozdeji spocita)
    STRING_LEN DD 0
    SUBSTRING_LEN DD 0
    REPLACE_STRING_LEN DD 0
    RESULT_STRING_LEN DD 0
    
    ; posunuti v ramci vyhledavani retezce
    OFFSET DD 0

SECTION .text
main:
    MOV EBP, ESP
    
    CLD ; nastaveni smeru zpracovani retezcu
    CALL PrintInfo ; vypis informaci o vstupnich hodnotach
    
    ; spocitani delku vstupniho retezce
    PUSH STRING
    CALL StringLength
    ADD ESP, 4
    MOV [STRING_LEN], EAX
    
    ; spocitani delku hledaneho retezce
    PUSH SUBSTRING
    CALL StringLength
    ADD ESP, 4
    MOV [SUBSTRING_LEN], EAX
    
    ; spocitani delku nahrazovaciho retezce
    PUSH REPLACE_STRING
    CALL StringLength
    ADD ESP, 4
    MOV [REPLACE_STRING_LEN], EAX
    
    ; kopie vstupniho retezce do vysledeho retezce
    MOV ESI, STRING
    MOV EDI, RESULT_STRING
    MOV ECX, [STRING_LEN] ; delka vstupniho retezce
    REP MOVSB
    
; cyklus, ktery testuje vstupni retezec (vystupni, protze se do nej postupne kopiruje)
; a hledany retezec na shodu, skonci az bude otestovan cely vstupni retezec
.while:
    ; spocitani velikosti vysledneho retezce
    PUSH RESULT_STRING
    CALL StringLength
    ADD ESP, 4
    MOV [RESULT_STRING_LEN], EAX

    ; porovnani vysledneho retezce s hledanym retezcem
    MOV ESI, RESULT_STRING
    ADD ESI, [OFFSET] ; vystupni retezec se zacina testovat az od offsetu
    MOV EDI, SUBSTRING
    MOV ECX, [RESULT_STRING_LEN] ; delka vystupniho retezce
    SUB ECX, [OFFSET] ; zmenseni o offset, protoze k ESI se pricita offset
    REPE CMPSB
    
    MOV EBX, [OFFSET] ; EBX = predchozi offset
    
    ;;; vypocet noveho offsetu
    ADD ECX, [OFFSET] ; pricteni offsetu k ECX, protze se pri porovnavani od ECX odcital
    ; OFFSET = delka vystupniho retezce - ECX (pocet neprojitych iteraci pro porovnani) + EBX (stary offset)
    MOV EAX, [RESULT_STRING_LEN]
    SUB EAX, ECX
    ADD EAX, EBX
    MOV [OFFSET], EAX
    
    ; pokud jsou offset a predchozi offset stejne, inkrementuje se offset pro ucely testovani konce,
    ; viz nasledujici blok
    MOV EDX, [OFFSET]
    INC EDX
    CMP [OFFSET], EBX
    CMOVE EAX, EDX
    
    ; if (OFFSET > delka vysledneho retezce) break - uz byl otestovan cely retezec
    CMP EAX, [RESULT_STRING_LEN]
    JG .endwhile
    
    ; EAX = pocet otestovanych znaku (RESULT_STRING_LEN - ECX)
    MOV EAX, [RESULT_STRING_LEN]
    SUB EAX, ECX
    ; if (EAX < delka hledaneho retezce) continue
    CMP EAX, [SUBSTRING_LEN]
    JL .while
    
    ; if (delka vysledneho retezce != OFFSET) OFFSET--
    ; pokud nejsem na konci retezce, tak je potreba dekrementovat offset,
    ; aby se nazapocital posledni neshodny znak
    MOV EAX, [RESULT_STRING_LEN]
    CMP EAX, [OFFSET]
    JE .skip_dec_offset
    DEC DWORD [OFFSET]
    
.skip_dec_offset:
    ; kopie vysledneho retezce do pomocneho retezce
    MOV ESI, RESULT_STRING
    MOV EDI, TMP_STRING
    MOV ECX, [RESULT_STRING_LEN] ; delka vysledneho retezce
    REP MOVSB
    
    ; kopie nahrazovaciho retezce na patricne misto do pomocneho retezce
    MOV ESI, REPLACE_STRING
    MOV EDI, TMP_STRING ; spravne misto v pomocnem retezci se musi prictenim odectenim offssetu a
    ADD EDI, [OFFSET]   ; odectenim delky hledaneho retezce (EDI + OFFSET - SUBSTRING_LEN)
    SUB EDI, [SUBSTRING_LEN]
    MOV ECX, [REPLACE_STRING_LEN] ; delka nahrazovaciho retezce
    REP MOVSB
    
    ; kopie zbytku vystupniho retezce do pomocneho retezce
    MOV ESI, RESULT_STRING ; zacina se kopirovat z mista od offsetu (ESI + OFFSET)
    ADD ESI, [OFFSET]
    MOV EDI, TMP_STRING ; zacina se kopirovat do mista od offsetu minus delka hledaneho retezce,
    ADD EDI, [OFFSET]   ; plus delka nahrazovaciho retezce (EDI + OFFSET - SUBSTRING_LEN + REPLACE_STRING_LEN)
    SUB EDI, [SUBSTRING_LEN]
    ADD EDI, [REPLACE_STRING_LEN]
    MOV ECX, [RESULT_STRING_LEN] ; zbytek vstupniho retezce je dlouhy RESULT_STRING_LEN - OFFSET
    SUB ECX, [OFFSET]
    REP MOVSB
    MOV AL, 0 ; na konec je pridan znak 0
    STOSB
    
    ; kopie pomocneho retezce zpet do vysledneho retezce
    MOV ESI, TMP_STRING
    MOV EDI, RESULT_STRING
    PUSH TMP_STRING
    CALL StringLength
    ADD ESP, 4
    MOV ECX, EAX ; spocitana delka pomocneho retezce
    REP MOVSB
    MOV AL, 0 ; na konec je pridan znak 0
    STOSB
    
    ; if (OFFSET >= RESULT_STRING_LEN) break - pokud je offset vetsi nebo roven delce vystupniho retezce,
    ; pak byl otestovan cely retezec
    MOV EAX, [RESULT_STRING_LEN]
    CMP [OFFSET], EAX
    JGE .endwhile
    
    MOV DWORD [OFFSET], 0 ; vynulovani offsetu
    JMP .while
    
.endwhile:
    CALL PrintOut ; vypis vystupnich informaci

    XOR EAX, EAX
    RET

; Spocita delku retezce
; arg1 - ukazatel na vstupni retezec
; return - delka retezce v EAX
StringLength:
    ENTER 2, 0
    MOV [EBP - 8], ESI ; ulozeni ESI
    
    MOV [EBP - 4], DWORD 0 ; vynulovaci pocitadla znaku
    MOV ESI, [EBP + 8] ; presunuti argumentu na ESI
    
; while (get_next_char() != 0) - cyklus pres vsechny znaky retezce, opakuje se,
; dokud neni na konci retezce, znak 0
.while:
    LODSB ; AL = get_next_char()
    CMP AL, 0
    JE .endwhile
    INC DWORD [EBP - 4] ; zvyseni pocitadla znaku
    JMP .while
    
.endwhile:
    MOV EAX, [EBP - 4] ; EAX = vysledek

    MOV ESI, [EBP - 8] ; obnoveni ESI
    LEAVE
    RET
    
; Vypis vystupnich informaci
PrintOut:
    ; vypis vystupniho retezce
    CALL WriteNewLine
    MOV ESI, RESULT_STRING_INFO
    CALL WriteString
    MOV ESI, RESULT_STRING
    CALL WriteString
    CALL WriteNewLine

    RET
    
; Vypis informaci o vstupnich hodnotach
PrintInfo:
    ; vypis vstupniho retezce
    MOV ESI, STRING_INFO
    CALL WriteString
    MOV ESI, STRING
    CALL WriteString
    CALL WriteNewLine
    
    ; vypis hledaneho retezce
    MOV ESI, SUBSTRING_INFO
    CALL WriteString
    MOV ESI, SUBSTRING
    CALL WriteString
    CALL WriteNewLine
    
    ; vypis nahrazovaciho retezce
    MOV ESI, REPLACE_STRING_INFO
    CALL WriteString
    MOV ESI, REPLACE_STRING
    CALL WriteString
    CALL WriteNewLine
    
    RET