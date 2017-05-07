%include "rw32-2017.inc"

CEXTERN memcpy

SECTION .data
    task32A DD 3072.0,-1024.0,-2816.0,1536.0,256.0,-768.0,-15360.0,-15360.0
    task32B DD -1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0

SECTION .text
main:
    MOV EBP, ESP; for correct debugging
    
    MOV EAX, __float32__(3.0)
    CALL task31
    CALL WriteFloat
    CALL WriteNewLine
    
    
    PUSH 8
    PUSH task32B    
    PUSH task32A
    CALL task32
    ADD esp,12
    CALL WriteInt32
    CALL WriteNewLine

    RET
;
;--- �kol 1 ---
;
;Naprogramujte funkci "task31", kter� pomoc� koprocesoru FPU vypo��t� funkci f(x):
;
;         sin(-2x + PI)
; f(x) = --------------
;            x - 5   
;
;Funkci je p�ed�v�n parametr x v resgistru EAX a v�sledek vrac� tak� v registru EAX jako 
;32bitov� ��slo v plovouc� ��dov� ��rce.
;
;  - vstup:
;    - EAX: hodnota x (32bitov� ��slo v plovouc� ��dov� ��rce)
;  - v�stup:
;    - EAX = p�vodn� hodnota x v p��pad�, �e funkci nelze vypo��tat (tj. kdy� je jmenovatel roven 0)
;    - EAX = v�sledek funkce f(x) (32bitov� ��slo v plovouc� ��dov� ��rce)
;  - funkce mus� zachovat obsah v�ech registr�, krom� registru EAX, registr� FPU a p��znakov�ho registru
;  - nezapome�te, �e jmenovatel nesm� b�t 0 (tedy x - 5 <> 0) 
;  - nepou��vejte datov� segment, sv� data ukl�dejte v p��pad� pot�eby, na z�sobn�k jako lok�ln� prom�nn� 
task31:
    ENTER 2, 0
    
    %define X DWORD [EBP - 4]
    %define tmp DWORD [EBP - 8]
    
    FINIT
    MOV X, EAX
                             ; ST0       ST1       ST2
    FLD X                    ; X
    MOV tmp, DWORD 5
    FISUB tmp                ; X - 5
    FLDZ                     ; 0        X - 5
    FCOMIP ST1 ; CMP 0, X - 5  X - 5
    JZ .exit
    
    FLD X                    ; X        X - 5
    MOV tmp, DWORD -2
    FIMUL tmp                ; -2*x     X - 5
    FLDPI                    ; PI       -2*x       X - 5
    FADDP ST1                ; -2*x+PI  X - 5
    FSIN                 ; sin(-2*x+PI) X - 5
    FDIV ST1                ; sin(-2*x+PI)/x-5  x - 5
    
    FST tmp
    MOV EAX, tmp
    
.exit:
    LEAVE
    RET
;
;--- �kol 2 ---
;
;Naprogramujte funkci "task32", jej�mi� vstupn�mi parametry jsou ukazatele na pole 32bitov�ch hodnot v plovouc� ��dov�
;��rce pA a pB a po�et prvk� t�chto pol� N (m��e b�t i 0), a v�stupem je hodnota 0 nebo 1 dle popisu n�e. Funkce tak�
;zkop�ruje prvky z pole A do pole B funkc� "memcpy" (pozor, "memcpy" m�n� obsah registr� ECX a EDX) a pot� jednotliv�
;prvky pole A transformuje funkc� "task31" z �kolu 1. Funkci se p�ed�vaj� parametry na z�sobn�ku podle konvence jazyka C
;a mus� zachovat obsah registr� (krom� FPU, EAX a p��znak�).
;
;int task32(float *pA, float *pB, unsigned int N)
;  - vstup:
;    pA: ukazatel na pole A (pole A obsahuje 32bitov� hodnoty v plovouc� ��dov� ��rce)
;    pB: ukazatel na pole B (pole B obsahuje 32bitov� hodnoty v plovouc� ��dov� ��rce)
;     N: po�et prvk� pol� A a B (32bitov� ��slo bez znam�nka, m��e b�t i 0!)
;  - v�stup:
;    - EAX = 0 pokud je ukazatel pA nebo pB neplatn� (tedy pA == 0 || pB == 0) nebo pokud je pole pr�zdn� (N == 0)
;    - EAX = 1 pokud v�e prob�hne bez chyby
;  - funkce mus� zachovat obsah v�ech registr�, krom� registru EAX, registr� FPU a p��znakov�ho registru
;  - nepou��vejte datov� segment, sv� data ukl�dejte v p��pad� pot�eby, na z�sobn�k jako lok�ln� prom�nn�
;
;Funkce "memcpy":
;    void* memcpy(void * destination, const void * source, size_t num)
;      - vstup:
;          size: po�et byt�, kter� maj� b�t rezervov�ny v pam�ti,
;          destination: ukazatel na c�lov� m�sto v pan�ti,
;          source: ukazatel zdroje kop�rovan�ch dat
;      - v�stup:
;          funkce vrac� ukazatel "destination"
;      -- POZOR -- memcpy m�n� obsah registr� EAX, ECX a EDX
;
;Uk�zka funkce "task32" v jazyce C:
;
;int task32(float *pA, float *pB, unsigned int N) {
;    if (pB != NULL && pA != NULL && N > 0) {
;        memcpy(pB, pA, N*sizeof(float));
;        for(unsigned int i = 0; i < N; i++) pA[i] = task1(pA[i]);
;        return 1;
;    }
;    return 0;
;}
;            
task32:
    ENTER 0, 0
    PUSH ECX
    PUSH EDX
    
    %define pA DWORD [EBP + 8]
    %define pB DWORD [EBP + 12]
    %define N DWORD [EBP + 16]
    
    MOV EAX, pA
    CMP EAX, 0
    JE .ret_0
    
    MOV EAX, pB
    CMP EAX, 0
    JE .ret_0
    
    MOV EAX, N
    CMP EAX, 0
    JE .ret_0
    
    
    MOV EAX, N
    MOV EDX, 4
    MUL EDX
    PUSH EAX
    PUSH pA
    PUSH pB
    CALL memcpy
    ADD ESP, 12
    
    
    MOV ECX, N
    MOV EDX, pA
.for:
    CMP ECX, 0
    JLE .end_for
    
    MOV EAX, DWORD [EDX]
    CALL task31
    MOV DWORD [EDX], EAX
    
    
    ADD EDX, 4
    DEC ECX
    JMP .for
.end_for:
  
    
    MOV EAX, 1
    JMP .exit
    
.ret_0:
    MOV EAX, 0

.exit:
    POP EDX
    POP ECX
    LEAVE
    RET
