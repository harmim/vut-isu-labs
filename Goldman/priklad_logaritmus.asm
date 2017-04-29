; Nazev prikladu: Vypocitej y=sqrtf(log(b) + a)
;
; Autor: Tomas Goldmann

%include "rw32-2015.inc"

extern log
;kod datova sekce


section .data
a dd 2.0
b dd 10.0

bFormat db "%f",0

;kod program
section .text

main:

	finit

	sub esp, 8
	fld dword [b]
	fst qword [esp]
	call log
	add esp,8

	fld dword [a]
	fadd st0, st1
	fsqrt

	sub esp, 8
	fst qword [esp]
	push bFormat
	call printf
	add esp, 12

ret
