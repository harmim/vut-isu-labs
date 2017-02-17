%include "../rw32-2015.inc"

section .data
	sMessage db "Hello World!",EOL,0

section .text
main:

	mov esi,sMessage	; ukazka volani funkce, ktera napise "Hello World!"
	call WriteString

	; zde muzete psat vas kod

	ret
