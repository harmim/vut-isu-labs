; Nazev prikladu: Koreny kvadraticke rovnice
; Navrat hodnot z funkce je reseny prostrednictvim struktury, reseni struktur neni predmetem ISU
; Neni osetreny pripad, ze D<0
; Autor: Tomas Goldmann

%include "rw32-2015.inc"


%define ap ebp+8
%define bp ebp+12
%define cp ebp+16

;nad ramec ISU
struc   quad_eq
  .x1:      resd    1
  .x2:      resd    1
  .size:
endstruc


;kod datova sekce
section .data

fString db "%f %f %f",0
fStringEq db 'Zadejte koeficienty a,b,c kvadraticke rovnice y=a^2+b^1+c ve tvaru "a b c"',10,0
fStringOut db "x1: %f x2: %f",0

a dd 1.0
b dd 2.0
c dd 3.0

four dd 4.0
two dd 2.0
minus dd -1.0

;nad ramec ISU
p: 	istruc quad_eq               ; declare an instance of point and
at quad_eq.x1, DD 1.0                    ; initialize its fields
at quad_eq.x2, DD 2.0
iend



;kod program
section .text

main:
	finit

	;vypis popisneho retezce
	push fStringEq
	call printf
	add esp, 4

	;fflush stdin
	push dword 0
	call fflush
	add esp, 4

	;nacteni retezce pomoci scanf
	push dword c
	push dword b
	push dword a
	push fString
	call scanf
	add esp, 16

	;nad ramec ISU - pripravim si misto na zasobniku pro strukturu
	lea eax, [esp-8]
	sub esp, 8
	push eax
	;predavam parametry
	push dword [c]
	push dword [b]
	push dword [a]
	call koreny
	mov ebx, [eax + quad_eq.x1]
	mov dword [p + quad_eq.x1],ebx
	mov ebx, [eax+  quad_eq.x2]
	mov dword [p+  quad_eq.x2],ebx

	;nad ramec ISU - uklizeni mista po strukture
	add esp,8

	sub esp, 16

	fld dword [p +quad_eq.x1]  ;load float
    fstp qword [esp]  ;store double (8087 does the conversion internally)

    fld dword [p +quad_eq.x2]  ;load float
    fstp qword [esp+8]  ;store double (8087 does the conversion internally)

	;vypis hodnot
	push fStringOut
	call printf
	add esp,20

	push dword 0
	call fflush
	add esp, 4

ret


koreny:
	push ebp
	mov ebp, esp

	;sqrt(b^2-4ac)

	fld dword [cp] ;st0=c
	fmul dword [ap] ;st0=ac
	fmul dword [four] ;st0=4ac

	fld dword [bp]
	fmul  st0, st0  ; st0=b*b st1=4ac

	fsub st0, st1 ;st0=b*b-4ac ,st1=4ac
	fsqrt

	fld dword [bp] ;st0=b, st1=sqrt(b*b-4ac) ,st2=4ac
	fmul dword [minus] ;st0=-b, st1=sqrt(b*b-4ac) ,st2=4ac
	fadd st0, st1 ;st0=-b+sqrt(b*b-4ac), st1=sqrt(b*b-4ac) ,st2=4ac

	fld dword [ap] ;st0=a, st1=-b+sqrt(b*b-4ac), st2=sqrt(b*b-4ac) ,st3=4ac
	fmul dword [two]  ;st0=2a, st1=-b+sqrt(b*b-4ac), st2=sqrt(b*b-4ac) ,st3=4ac
	fdivp st1, st0  ; st0=-b+sqrt(b*b-4ac)/2a st1=sqrt(b*b-4ac) ,st2=4ac

	mov ebx, [ebp+20]
	fstp dword [ebx+quad_eq.x1]  ;st0=sqrt(b*b-4ac) ,st1=4ac

	;;;;;;;;

	fld dword [bp]  ;st0=b, st1=sqrt(b*b-4ac) ,st2=4ac
	fmul dword [minus]  ;st0=-b, st1=sqrt(b*b-4ac) ,st2=4ac
	fsub st0, st1 ;st0=-b-sqrt(4ac+b*b), st1=sqrt(b*b-4ac) ,st2=4ac

	fld dword [ap]
	fmul dword [two]
	fdivp st1, st0

	mov ebx, [ebp+20]
	fstp dword [ebx+quad_eq.x2]

	mov esp, ebp
	pop ebp
ret 16



