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
;--- Úkol 1 ---
;
;Naprogramujte funkci "task31", která pomocí koprocesoru FPU vypočítá funkci f(x):
;
;         sin(-2x + PI)
; f(x) = --------------
;            x - 5   
;
;Funkci je předáván parametr x v resgistru EAX a výsledek vrací také v registru EAX jako 
;32bitové číslo v plovoucí řádové čárce.
;
;  - vstup:
;    - EAX: hodnota x (32bitové číslo v plovoucí řádové čárce)
;  - výstup:
;    - EAX = původní hodnota x v případě, že funkci nelze vypočítat (tj. když je jmenovatel roven 0)
;    - EAX = výsledek funkce f(x) (32bitové číslo v plovoucí řádové čárce)
;  - funkce musí zachovat obsah všech registrů, kromě registru EAX, registrů FPU a příznakového registru
;  - nezapomeňte, že jmenovatel nesmí být 0 (tedy x - 5 <> 0) 
;  - nepoužívejte datový segment, svá data ukládejte v případě potřeby, na zásobník jako lokální proměnné 
task31:
    ENTER 8, 0
    
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
;--- Úkol 2 ---
;
;Naprogramujte funkci "task32", jejímiž vstupními parametry jsou ukazatele na pole 32bitových hodnot v plovoucí řádové
;čárce pA a pB a počet prvků těchto polí N (může být i 0), a výstupem je hodnota 0 nebo 1 dle popisu níže. Funkce také
;zkopíruje prvky z pole A do pole B funkcí "memcpy" (pozor, "memcpy" mění obsah registrů ECX a EDX) a poté jednotlivé
;prvky pole A transformuje funkcí "task31" z úkolu 1. Funkci se předávají parametry na zásobníku podle konvence jazyka C
;a musí zachovat obsah registrů (kromě FPU, EAX a příznaků).
;
;int task32(float *pA, float *pB, unsigned int N)
;  - vstup:
;    pA: ukazatel na pole A (pole A obsahuje 32bitové hodnoty v plovoucí řádové čárce)
;    pB: ukazatel na pole B (pole B obsahuje 32bitové hodnoty v plovoucí řádové čárce)
;     N: počet prvků polí A a B (32bitové číslo bez znaménka, může být i 0!)
;  - výstup:
;    - EAX = 0 pokud je ukazatel pA nebo pB neplatný (tedy pA == 0 || pB == 0) nebo pokud je pole prázdné (N == 0)
;    - EAX = 1 pokud vše proběhne bez chyby
;  - funkce musí zachovat obsah všech registrů, kromě registru EAX, registrů FPU a příznakového registru
;  - nepoužívejte datový segment, svá data ukládejte v případě potřeby, na zásobník jako lokální proměnné
;
;Funkce "memcpy":
;    void* memcpy(void * destination, const void * source, size_t num)
;      - vstup:
;          size: počet bytů, které mají být rezervovány v paměti,
;          destination: ukazatel na cílové místo v paněti,
;          source: ukazatel zdroje kopírovaných dat
;      - výstup:
;          funkce vrací ukazatel "destination"
;      -- POZOR -- memcpy mění obsah registrů EAX, ECX a EDX
;
;Ukázka funkce "task32" v jazyce C:
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
