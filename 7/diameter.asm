%include "rw32-2017.inc"

; prumer - vypocita prumer ze zadanych cisel

section .data
    SIZE DD 8 ; number of values for calculation diameter
    VALUES DD 1, 2, 3, 4, 5, 6, 3, 8 ; values for calculation diameter
    
section .text
Diameter: ; function to calculate diameter
    ENTER 0, 0 ; stack-frame enter
    ; push (store) used registers
    PUSH ECX
    PUSH EDX
    
    MOV ECX, [EBP + 8] ; ECX = SIZE (loop counter)
    XOR EAX, EAX ; EAX = 0
    MOV EDX, [EBP + 12] ; EDX = VALUES (address of array of values)
    
    sum: ; sum array values loop
        ADD EAX, [EDX] ; EAX += current value of VALUES array item
        ADD EDX, 4 ; EDX += 4 (move to next value of VALUES array)
        LOOP sum ; loop until ECX != 0 (SIZE times)
    
    CDQ ; EDX:EAX = signextended(EAX)
    MOV ECX, [EBP + 8] ; ECX = SIZE
    IDIV ECX ; EAX = EDX:EAX / ECX (sum / SIZE) -> return value in EAX
    
    ; pop (restore) used registers
    POP EDX
    POP ECX
    LEAVE ; stack-frame leave
    RET 8 ; clear two 32bit parameters from stack

main:
    MOV EBP, ESP
    
    ; push parameters to Diameter function
    PUSH VALUES
    PUSH DWORD [SIZE]
    CALL Diameter ; calculate diameter -> result in EAX
    CALL WriteInt32 ; write result from EAX to stdout

    XOR EAX, EAX
    RET