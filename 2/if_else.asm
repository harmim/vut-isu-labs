%include "../rw32-2015.inc"

section: .data
	a_vetsi db "A je vetsi",EOL,0
	a_mensi db "A je mensi",EOL,0
	var_a dd 15
	var_b dd 20

section: .text
main:
	mov eax,0
	add eax,[var_a]
	cmp [var_b],eax
	jg a_greater
	ja a_smaller
	
	ret

a_greater:
	mov esi,a_vetsi
	call WriteString

	ret

a_smaller:
	mov esi,a_mensi
	call WriteString

	ret

