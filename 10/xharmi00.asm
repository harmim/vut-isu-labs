znaménka%include "rw32-2017.inc"

%macro WRITE_ARRAY 4
	push esi
	push ecx
	push eax
	mov esi,%1
   	mov ecx,%2
%%writeElement:
  	lods%3
   	call Write%4
   	cmp ecx,1
   	jbe %%skipComma
   	mov al,','
   	call WriteChar
%%skipComma:
   	loop %%writeElement

   	call WriteNewLine
   	pop eax
   	pop ecx
   	pop esi
%endmacro

%macro F13_CALL 3
	mov esi,%2
	mov ecx,%3
	call %1
%endmacro

%macro F2_CALL 5
	push %5
	push %4
	push %3
	push %2
	call %1
	add esp,16
%endmacro

section .data
    A1_1 dw 2048,256,4608,3328,2304
    A2_1 dw 2048,256,4608,3328,2304
    B2 dw 51608,56324,8993,11406,25763
    A3_1 dw -1024,-2816,1536,256,-768

section .text

;--- Úkol 1 ---
;
;Naprogramujte funkci "getMin", která v poli 16bitových èísel bez znaménka nalezne minimum a vrátí jeho hodnotu.
;
;unsigned short getMin(ESI, ECX)
;  - vstup:
;    - ESI: ukazatel na zaèátek pole 16bitových prvkù bez znaménka
;    - ECX: poèet prvkù pole (32bitová hodnota bez znaménka)
;  - výstup:
;    - AX: hodnota 16bitového minima bez znaménka     
;  - funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru

getMin:
    ENTER 0, 0
    
    CMP ECX, 0
    JLE .end_for
    
    MOV AX, WORD [ESI]
    DEC ECX
    ADD ESI, 2
    
.for:
    CMP ECX, 0
    JLE .end_for
    
    CMP WORD [ESI], AX
    JGE .continue
    
    MOV AX, WORD [ESI]

.continue:
    ADD ESI, 2
    DEC ECX
    JMP .for

.end_for:
    LEAVE    
    RET


;--- Úkol 2 ---
;
;Naprogramujte funkci "addX", která k jednotlivým prvkùm pole A pøiète hodnotu x a jednotlivé výsledky uloží do pole B.
;
;Délka polí je dána parametrem N. Funkce musí být naprogramována s využitím pøedávání parametrù na zásobníku tak,
;že parametry funkce se ukládají na zásobník od posledního do prvního (zprava doleva),
;parametry ze zásobníku uklízí volající a výsledek funkce se vrací v registru EAX.
;
;int addX(unsigned short *pA, unsigned int N, unsigned short x, unsigned short *pB)
;  - vstup:
;    pA: ukazatel na pole A (pole A obsahuje 16bitové hodnoty bez znaménka)
;     N: poèet prvkù pole A (32bitové èíslo bez znaménka)
;     x: hodnota x (16bitové èíslo bez znaménka)
;    pB: ukazatel na pole B (pole B bude obsahovat 16bitové hodnoty bez znaménka)
;  - výstup:
;    - EAX =  0: v pøípadì, že nenastala žádná chyba  
;    - EAX = -1: v pøípadì, že je neplatný ukazatel *pA (tj. pA == 0)
;    - EAX = -2: v pøípadì, že je neplatný ukazatel *pB (tj. pB == 0)
;  - funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru

addX:
    ENTER 1, 0
    PUSH ECX
    PUSH EBX
    
    %define pB [EBP + 20]
    %define x [EBP + 16]
    %define N [EBP + 12]
    %define pA [EBP + 8]
    %define tmp_value [EBP - 4]
    
    CMP pA, DWORD 0
    JE .invalid_pA
    
    CMP pB, DWORD 0
    JE .invalid_pB
    
    MOV ECX, N
.for:
    CMP ECX, 0
    JLE .end_for
    
    MOV EAX, pA
    MOV AX, WORD [EAX]
    ADD AX, x
    
    MOV EBX, pB
    MOV WORD [EBX], AX
    
    ADD pA, WORD 2
    ADD pB, WORD 2
    DEC ECX
    JMP .for
 
.end_for:
    JMP .success
    
.invalid_pA:
    MOV EAX, -1
    JMP .exit

.invalid_pB:
    MOV EAX, -2
    JMP .exit

.success:
    XOR EAX, EAX

.exit:
    POP EBX
    POP ECX
    LEAVE
    RET

;
;--- Úkol 3 ---
;
;Naprogramujte funkci "sort", která sestupnì (od nejvìtšího k nejmenšímu) seøadí pole 16bitových prvkù se znaménkem A. 
;
;Ukázka algoritmu øazení v jazyce C:
;
;int *pA, i, j, N;
;for(i = 0; i < N; i++) {
;    for(j = i + 1; j < N; j++) {
;        if (pA[i] < pA[j]) { tmp = pA[i]; pA[i] = pA[j]; pA[j] = tmp; }      
;    }
; }
;
;void sort(short *pA, unsigned int N)
;  - vstup:
;    ESI: ukazatel na pole A (pole A obsahuje 16bitové hodnoty se znaménkem)
;    ECX: poèet prvkù pole A (32bitové èíslo bez znaménka)
;  - funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru     

sort:
    ENTER 1, 0
    PUSH EAX
    PUSH ECX
    PUSH EDX
    PUSH ESI
    
    %define array_max_index [EBP - 4]
    
    MOV array_max_index, ECX
    DEC DWORD array_max_index
    
    XOR ECX, ECX
.for_1:
    CMP ECX, array_max_index
    JGE .end_for_1
    
    PUSH ECX
    
    XOR ECX, ECX
    .for_2:
        CMP ECX, array_max_index
        JGE .end_for_2
        
        MOV AX, WORD [ESI]
        MOV DX, WORD [ESI + 2]
        CMP AX, DX
        JGE .skip_swap
         
        MOV [ESI + 2], AX
        MOV [ESI], DX
        
        .skip_swap:
        ADD ESI, 2
        INC ECX
        JMP .for_2
    
    .end_for_2:
    MOV EAX, array_max_index
    MOV EDX, 2
    MUL EDX
    SUB ESI, EAX
    
    POP ECX
    INC ECX
    JMP .for_1
    
.end_for_1:
    POP ESI
    POP EDX
    POP ECX
    POP EAX
    LEAVE
    RET

main:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp,esp

    WRITE_ARRAY A1_1, 5, w, UInt16
    F13_CALL getMin, A1_1, 5
    call WriteUInt16
    call WriteNewLine

    WRITE_ARRAY A2_1, 5, w, UInt16
    WRITE_ARRAY B2, 5, w, UInt16
    F2_CALL addX, A2_1, 5, 38674, B2
    call WriteUInt16
    call WriteNewLine
    call WriteFlags
    WRITE_ARRAY A2_1, 5, w, UInt16
    WRITE_ARRAY B2, 5, w, UInt16

    WRITE_ARRAY A3_1, 5, w, Int16
    F13_CALL sort, A3_1, 5
    call WriteInt16
    call WriteNewLine
    WRITE_ARRAY A3_1, 5, w, Int16

    pop ebp
    ret