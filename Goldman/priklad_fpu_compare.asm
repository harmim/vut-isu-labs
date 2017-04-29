; Nazev prikladu: Vypocitej y=   a^2+b^2+c <= 10 else 0
;
; Autor: Tomas Goldmann

%include "rw32-2015.inc"

extern log
;kod datova sekce


section .data
a dd 2.0
b dd 10.0
c dd 3.0

cons10 dd 10.0
consZero dd 0.0

bFormat db "%f",0

;kod program
section .text

main:

	finit

	fld dword [a]
	fmul st0
	fld dword [b]
	fmul st0
	fadd st0, st1
	fld dword [c]
	fadd st0, st1

	fld dword [cons10]
	fcomi st0, st1
	fstp st0
	jnb next

	fld dword [consZero]
next:
	sub esp, 8
	fst qword [esp]
	push bFormat
	call printf
	add esp, 12

ret
