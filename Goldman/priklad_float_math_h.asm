; Nazev prikladu: Nacteni float a pouziti funkce z math.h
;
; Autor: Tomas Goldmann

%include "rw32-2015.inc"


extern floor

;kod datova sekce
section .data
fString db 'Hodnota %f, nejblizsi "nizsi" cislo: %f',10,0

float_var dd 123.123


;kod program
section .text

main:
	finit

	;vytvoreni mista na zasobniku pro qword
	sub esp, 8
	fld dword [float_var]
	fst qword [esp]
	;zavolani funkce floor
	call floor
	add esp, 8

	sub esp, 16
	;ulozeni hodnoty po volani funkce floor
	fst  qword [esp+8]
	;nacteni puvodni hodnoty a opet ulozeni na zasobnik
	fld dword [float_var]
	fst qword [esp]
	;vypis popisneho retezce
	push fString
	call printf
	add esp, 20
ret





