; Nazev prikladu: Vypocet obsahu kruhu
; Po spusteni programu zadejte hodnotu polomeru
; Autor: Tomas Goldmann

%include "rw32-2015.inc"

extern printf
extern strlen
extern scanf

;kod datova sekce
section .data

sFormat db "%f",0
sFormatPrintf db "Obsah kruhu %f",0
FloatR dd 1.0
PI dd 3.1415



;kod program
section .text


obsah_kruhu:
	;vytvoreni zasobnikoveho ramce
	push ebp
	mov ebp, esp

	;r^2*PI
	fld dword [ebp+8]
	fmul dword [ebp+8]
	fmul dword [PI]


	mov esp, ebp
	pop ebp
	ret 4

main:

    finit ; inicializace FPU

	;nacteni sscanf("Zadejte polomer kruznice: %f", sFloatR)
	push FloatR
	push sFormat
	call scanf
	add esp, 8


	;zavolani funkce pro vypocet obsahu kruhu
	push dword [FloatR]
	call obsah_kruhu


	;vypsani hodnoty double
	sub esp,8  ;reserve stack for a double in stack¨
	fstp qword [esp]
	push sFormatPrintf
	call printf
	add esp,12

ret
