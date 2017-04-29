; Nazev prikladu: Nacteni retezce ze stdi, alokovani mista pomoci malloc, vypis retezce
; Autor: Tomas Goldmann

%include "rw32-2015.inc"


extern malloc
extern printf
extern free


;kod datova sekce
section .data

fString db "%s",0
errString db "Nepodarilo se alokovat misto",0
adresa dd 0




;kod program
section .text

main:

	;vytvoreni pametoveho mista pro 100
	push dword 100
	call malloc
	add esp, 4

	;pokud malloc vraci NULL skoci na chybovou hlasku a ukonci program
	cmp eax, 0
	jz error

	;ulozeni adresy
	mov dword [adresa], eax

	;nacteni retezce pomoci scanf
	push dword [adresa]
	push fString
	call scanf
	add esp, 8

	;vypis retezce pomoci printf
	push dword [adresa]
	call printf
	add esp, 4

	;uvolneni pameti
	push dword [adresa]
	call free
	add esp, 4

	jmp end

error:
	push errString
	call printf
	add esp, 4
end:
ret
