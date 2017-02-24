; Verze: 2017.02.17
; Autor: Filip Orsag (orsag@fit.vutbr.cz)
;
; Podpurna knihovna funkci "rw32-*.inc" pro predmet ISU.
; Pro svou cinnost vyuziva standardni knihovny jazyka C.
; Lze ji pouzit v OS Windows nebo Linux.
; Pro preklad je potreba vyvojove prostredi Codasip nebo NASM (a linker pro prislusny OS).
;
; Knihovnu vkladejte na zacatek vaseho programu: 
;
;	%include "rw32-2015.inc"
;
; Preklad Windows:
;	nasm -f win32 -g helloworld.asm
;	golink helloworld.obj /fo helloworld.exe /console /debug coff /entry:start msvcrt.dll kernel32.dll
;
; Preklad Linux:
;	nasm -f elf32 -g helloworld.asm	-o helloworld.o
;	gcc -m32 helloworld.o -o helloworld
;
;
; Dostupne funkce jsou nasledujici:
;
; Cteni z klavesnice:
;	ReadChar
;		Vstup:	nic.
;		Vystup:	AL = hodnota znaku.
;		Chovani: ceka na zadani znaku a na stisk klavesy ENTER (lze zadat i vice znaku, ale ty budou ignorovany, platny je pouze prvni znak).

;	ReadString
;		Vstup:	EBX = maximalni pocet znaku, ktere mohou byt nacteny.
;				EDI = adresa, kam se retezec nacte (musi byt rezervovano alespon EBX+1 bytu).
;		Vystup:	EAX = pocet prectenych znaku
;				retezec znaku ulozeny na adrese EDI.
;		Chovani: nacita znaky z klavesnice, dokud neni stisknuta klavesa ENTER. Na adresu v EDI ulozi maximalne EBX znaku
;				 nebo mene (vsechny dalsi znaky budou ignorovany), skutecny pocet znaku vraci v registru EAX.

;	ReadInt8
;		Vstup:	nic.
;		Vystup:	AL = cislo z intervalu <-128, 127>.
;		Chovani: cte cislo z klvesnice, umozni zadat jakykoliv znak, ale pouze znak '-','+' a cislice budou akceptovany,
;				 pokud neni zadana zadny znak a je stisknut ENTER, pak je vracena hodnota 0, pri prekroceni kterekoliv povolene
;				 meze je vraceno bud maximum nebo minimum daneho rozsahu.

;	ReadInt16
;		Vstup:	nic.
;		Vystup:	AX = cislo z intervalu <-32768, 32767>.
;		Chovani: viz ReadInt8.

;	ReadInt32
;		Vstup:	nic.
;		Vystup:	EAX = cislo z intervalu <-2^31, 2^31 - 1>.
;		Chovani: viz ReadInt8.

;	ReadUInt8
;		Vstup:	nic.
;		Vystup:	AL = cislo z intervalu <0, 255>.
;		Chovani: viz ReadInt8 s tim rozdilem, ze pri zadani znaku '-' bude cislo v doplnkovem kodu, ale interpretovano jako cislo bez znamenka.

;	ReadUInt16
;		Vstup:	nic.
;		Vystup:	AX = cislo z intervalu <0, 65535>.
;		Chovani: viz ReadUInt8.

;	ReadUInt32
;		Vstup:	nic.
;		Vystup:	EAX = cislo z intervalu <0, 2^32 - 1>.
;		Chovani: viz ReadUInt8.

;	ReadFloat
;		Vstup:	nic.
;		Vystup:	EAX = 32bitove realne cislo v plovouci radove carce (v jazyce C typ float).
;		Chovani: viz ReadInt8, navic je dovoleno zadat znak '.' (desetinna carka) a exponent (e+N nebo e-N).

;	ReadDouble
;		Vstup:	nic.
;		Vystup:	ST0 = 64bitove realne cislo v plovouci radove carce (v jazyce C typ double).
;		Chovani: viz ReadFloat.

; Vypis na obrazovku:
;	WriteChar
;		Vstup:	znak v AL.
;		Vystup:	vypise znak na obrazovku.

;	WriteNewLine
;		Vstup:	nic.
;		Vystup:	vypise konec radku (MS-DOS varianta end-of-line = hodnoty 13, 10, v Linuxu pouze 10).

;	WriteString
;		Vstup:	ESI = ukazatel na retezec zakonceny hodnotou 0, ktery bude vypsan.
;		Vystup:	vypise retezec na obrazovku.

;	WriteBin8
;		Vstup:	AL = cislo.
;		Vystup:	vypise cislo z AL na obrazovku v binarni podobe.

;	WriteBin16
;		Vstup:	AX = cislo
;		Vystup:	vypise cislo z AX na obrazovku v binarni podobe.

;	WriteBin32
;		Vstup:	EAX = cislo.
;		Vystup:	vypise cislo z EAX na obrazovku v binarni podobe.

;	WriteHex8
;		Vstup:	AL = cislo.
;		Vystup:	vypise cislo z AL na obrazovku v hexadecimalni podobe "0xXX".

;	WriteHex16
;		Vstup:	AX = cislo
;		Vystup:	vypise cislo z AX na obrazovku v hexadecimalni podobe "0xXXXX".

;	WriteHex32
;		Vstup:	EAX = cislo.
;		Vystup:	vypise cislo z EAX na obrazovku v hexadecimalni podobe "0xXXXXXXXX".

;	WriteInt8
;		Vstup:	AL = cislo.
;		Vystup:	vypise cislo z AL na obrazovku v dekadicke forme se znamenkem.

;	WriteInt16
;		Vstup:	AX = cislo.
;		Vystup:	vypise cislo z AX na obrazovku v dekadicke forme se znamenkem.

;	WriteInt32
;		Vstup:	EAX = cislo.
;		Vystup:	vypise cislo z EAX na obrazovku v dekadicke forme se znamenkem.

;	WriteUInt8
;		Vstup:	AL = cislo.
;		Vystup:	vypise cislo z AL na obrazovku v dekadicke forme bez znamenka.

;	WriteUInt16
;		Vstup:	AX = cislo.
;		Vystup:	vypise cislo z AX na obrazovku v dekadicke forme bez znamenka.

;	WriteUInt32
;		Vstup:	EAX = cislo.
;		Vystup:	vypise cislo z EAX na obrazovku v dekadicke forme bez znamenka.

;	WriteFlags
;		Vstup:	nic (aktualni stav priznakoveho registru).
;		Vystup:	vypise obsah priznakoveho registru priznaku na obrazovku.

;	WriteFloat
;		Vstup:	EAX = cislo (realne cislo s jednoduchou presnosti - float).
;		Vystup:	vypise cislo z EAX na obrazovku ve forme realneho cisla.

;	WriteDouble
;		Vstup:	ST0 = cislo (realne cislo v koprocesoru, vypisuje se cislo s dvojitou presnosti - double).
;		Vystup:	vypise cislo z ST0 na obrazovku ve forme realneho cisla.
;

bits 32

; Funkce standardni knihovny jazyka C (C Run-Time libraray)

%macro CEXTERN 1
    extern _%1
    %define %1 _%1
%endmacro

%macro CGLOBAL 1
    global _%1
    %define %1 _%1
%endmacro

CEXTERN printf
CEXTERN scanf
CEXTERN sscanf
CEXTERN gets
CEXTERN fgets
;CEXTERN stdin
CEXTERN getchar
CEXTERN strlen
CEXTERN strtoul
CEXTERN strtol
CEXTERN strtod
CEXTERN fflush

CGLOBAL main

%macro string 2+
	%1: DB %2
	endof.%1: DB 0
	lenof.%1 EQU endof.%1 - %1
	sizeof.%1 EQU endof.%1 - %1
%endmacro

%macro invoke 1
	call %1
%endmacro

%macro PRINTF 1-*
	%assign incStack 0
	%if %0 > 1
		%rep %0
			%rotate -1
			push dword %1
			%assign incStack incStack+4
		%endrep
		%rotate -1
	%endif
	call printf
	add esp,incStack
	
	push 0
	call fflush
	add esp,4
%endmacro

%define KB_ENTER 0x0D
%define KB_NEWLINE 0x0A
%define KB_BACKSPACE 0x08
%define EOL KB_NEWLINE

; Konstanty

%define EOF -1
%define MAX_UBYTE 0xFF
%define MAX_UWORD 0xFFFF
%define MAX_UDWORD 0xFFFFFFFF
%define MAX_SBYTE 0x0000007F
%define MAX_SWORD 0x00007FFF
%define MAX_SDWORD 0x7FFFFFFF
%define MIN_SBYTE 0xFFFFFF80
%define MIN_SWORD 0xFFFF8000
%define MIN_SDWORD 0x80000000
%define MAX_STRING_LENGTH 1024

section .data align=4

string msg_EOL, EOL
string msg_EnterChar, 'Zadejte znak: '
string msg_EnterUInt, 'Zadejte cele cislo bez znamenka z intervalu <%u,%u>: '
string msg_EnterSInt, 'Zadejte cele cislo se znamenkem z intervalu <%d,%d>: '
string msg_EnterFloat, 'Zadejte realne cislo (napr. 1.5): '
string msg_EnterString, 'Zadejte text (akceptovano bude maximalne %d znaku): '
string msg_NumberTooBig, 'Cislo je prilis velke, vracim maximalni moznou hodnotu.', EOL
string msg_NumberTooLow, 'Cislo je prilis male, vracim minimalni moznou hodnotu.', EOL
string msg_WrongNumber, 'Zadana hodnota neni rozpoznatelne cislo. Zadejte nove CISLO: '

errno				dd 0
format_char			db "%c",0
format_string		db "%s",0
format_int			db "%d",0
format_uint			db "%u",0
format_float		db "%f",0
format_double		db "%lf",0
format_char_in		db "%c",0
format_int_in		db "%d",0
format_uint_in		db "%u",0
format_real_in		db "%lf",0
format_hex8			db "0x%02X",0
format_hex16		db "0x%04X",0
format_hex32		db "0x%08X",0
msg_Flags			db 'Flags: xxxx|OF|DF|IF|TF|SF|ZF|xx|AF|xx|PF|xx|CF|',EOL,'       xxxx| '
msg_FlagValues		db              'x| x| x| x| x| x| x| x| x| x| x| x|',EOL
	endof_msg_Flags db 0
	lenof_msg_Flags EQU endof_msg_Flags - msg_Flags
number_in			dq 0.0
ioBuffer			times MAX_STRING_LENGTH db '!'
					db 0

section .text


;----------------
; Funkce ReadChar
;
ReadChar:
	push esi
	push eax

	mov esi,msg_EnterChar
	call WriteString
	invoke getchar
.next:
	cmp eax,KB_NEWLINE
	jz .return
	cmp eax,EOF
	jz .return
	invoke getchar
	jmp .next

.return:
	pop eax
	pop esi
	ret

;----------------
; Funkce ReadString
;
ReadString:
	pushfd
	push esi
	push edi
	push ebx
	push ecx
	push edx

	PRINTF msg_EnterString, ebx

	mov [edi], byte 0
	cmp ebx,0
	je .return

	push ioBuffer
	invoke gets
	add esp,4

;	push stdin
;	push ebx
;	push ioBuffer
;	invoke fgets
;	add esp,12
;	mov [ioBuffer + ebx], byte 0

	push ioBuffer
	invoke strlen
	add esp,4
	mov ecx,eax
	inc ecx

	mov esi,ioBuffer
	rep movsb

.return:
	pop edx
	pop ecx
	pop ebx
	pop edi
	pop esi
	popfd
	ret

;----------------
; Funkce ReadNumber
; Cte cislo ze standardniho vstupu dle formatovaciho retezce odpovidajiciho formatu scanf.
; Ukazatel na formatovaci retezec je ulozen v registru EBX.
;
ReadNumber:
	push ebx
	push ecx
	push edx

.again:
	mov [number_in], dword 0
	mov [number_in + 4], dword 0
	push ioBuffer
	invoke gets
	add esp,4
;	push dword [stdin]
;	push MAX_STRING_LENGTH
;	push ioBuffer
;	invoke fgets
;	add esp,12

	push number_in
	push ebx
	push ioBuffer
	invoke sscanf
	add esp,12
	cmp eax,0
	jne .ok

	PRINTF format_string, msg_WrongNumber

	jmp .again

.ok:
	mov eax,[number_in]

	pop edx
	pop ecx
	pop ebx
	ret

;----------------
; Funkce ReadIntX (8,16,32) {ReadInt8,ReadInt16,ReadInt32}
; Precte 8-, 16-, 32-bitovou celociselnou hodnotu se znamenkem z klavesnice
; Chovani funkci je dano chovanim funkce SSCANF. Veskere namitky se netykaji autora.
;
ReadInt8:
	push esi
	push edi
	push ebx
	mov ebx,MAX_SBYTE
	mov edi,MIN_SBYTE
	jmp ReadInt
	
ReadInt16:
	push esi
	push edi
	push ebx
	mov ebx,MAX_SWORD
	mov edi,MIN_SWORD
	jmp ReadInt

ReadInt32:
	push esi
	push edi
	push ebx
	mov ebx,MAX_SDWORD
	mov edi,MIN_SDWORD

ReadInt:
	push ecx
	push edx

	PRINTF msg_EnterSInt, edi, ebx

	pop edx
	pop ecx

	push ebx
	mov ebx,format_int_in
	call ReadNumber
	pop ebx

	cmp eax,ebx
	jng .test_min

	mov esi,msg_NumberTooBig
	call WriteString
	mov eax,ebx
	jmp .return

.test_min:
	cmp eax,edi
	jnl .return

	mov esi,msg_NumberTooLow
	call WriteString
	mov eax,edi

.return:
	pop ebx
	pop edi
	pop esi
	ret

;----------------
; Funkce ReadUIntX (8,16,32) {ReadUInt8,ReadUInt16,ReadUInt32}
; Precte 8-, 16-, 32-bitovou celociselnou hodnotu bez znamenka z klavesnice
; Chovani funkci je dano chovanim funkce SSCANF. Veskere namitky se netykaji autora.
;
ReadUInt8:
	push esi
	push edi
	push ebx
	mov ebx,MAX_UBYTE
	mov edi,0
	jmp ReadUInt

ReadUInt16:
	push esi
	push edi
	push ebx
	mov ebx,MAX_UWORD
	mov edi,0
	jmp ReadUInt

ReadUInt32:
	push esi
	push edi
	push ebx
	mov ebx,MAX_UDWORD
	mov edi,0

ReadUInt:
	push ecx
	push edx

	PRINTF msg_EnterUInt, edi, ebx

	pop edx
	pop ecx

	push ebx
	mov ebx,format_uint_in
	call ReadNumber
	pop ebx

	cmp eax,ebx
	jna .return

	mov esi,msg_NumberTooBig
	call WriteString
	mov eax,ebx

.return:
	pop ebx
	pop edi
	pop esi
	ret

;----------------
; Funkce ReadFloat
; Precte 32bitove realne cislo z klavesnice
; Chovani funkci je dano chovanim funkce SSCANF. Veskere namitky se netykaji autora.
;
ReadFloat:
	pushfd
	push esi
	push ebx

	mov esi,msg_EnterFloat
	call WriteString
	mov ebx,format_real_in
	call ReadNumber
	fld qword [number_in]
	sub esp,4
	fstp dword [esp]
	pop eax

.return:

	pop ebx
	pop esi
	popfd
	ret

;----------------
; Funkce ReadDouble
; Precte 64bitove realne cislo z klavesnice
; Chovani funkci je dano chovanim funkce SSCANF. Veskere namitky se netykaji autora.
;
ReadDouble:
	pushfd
	push esi
	push ebx
	push eax

	mov esi,msg_EnterFloat
	call WriteString
	mov ebx,format_real_in
	call ReadNumber
	fld qword [number_in]

.return:

	pop eax
	pop ebx
	pop esi
	popfd
	ret

;----------------
; WriteChar
; Vypise znak ulozeny v registru AL
;
WriteChar:
	push eax
	push ecx
	push edx

	movzx ecx,al
	PRINTF format_char,ecx

	pop edx
	pop ecx
	pop eax
	ret
    
;----------------
; WriteNewLine
; Vypise "End Of Line", tedy ASCII hodnoty CR, LF ve Windows (13, 10) a LF v Linuxu (10)
;
WriteNewLine:
	pushfd
	push eax
	push ecx
	push edx

	PRINTF format_string,msg_EOL

	pop edx
	pop ecx
	pop eax
	popfd
	ret

;----------------
; Funkce WriteBinX (8, 16, 32) {WriteBin8, WriteBin16, WriteBin32}
; Vypise 8,16,32 bitu z registru AL, AX, EAX
;
WriteBin8:
	pushfd
	push ecx
	push eax

	mov ecx,8
	rcl eax,24
	jmp WriteBin

WriteBin16:
	pushfd
	push ecx
	push eax

	mov ecx,16
	rcl eax,16
	jmp WriteBin

WriteBin32:
	pushfd
	push ecx
	push eax

	mov ecx,32

WriteBin:
	push edx
	push ebx
	push edi
	push esi

	cld
	mov edi,ioBuffer
	mov ebx,eax

.next_bit:
	rcl ebx,1
	setc al
	add al,'0'
	stosb
	loop .next_bit

	mov [edi], byte 0

	mov esi,ioBuffer
	call WriteString

	pop esi
	pop edi
	pop ebx
	pop edx
	pop eax
	pop ecx
	popfd
	ret

;----------------
; WriteString
; Vypise retezce ukonceneho 0 (ASCIIZ), jehoz adresa je ulozena v registru ESI
;
WriteString:
	pushfd
	push eax
	push ecx
	push edx

	PRINTF format_string, esi

	pop edx
	pop ecx
	pop eax
	popfd
	ret

;----------------
; WriteFlags
; Vypise stav registru priznaku
;
WriteFlags:
	pushfd
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	pushfd
	pop ebx
	shl ebx,20

	mov ecx,12
	mov edi,msg_FlagValues

.cycle:
	rcl ebx,1
	setc al
	add al,'0'
	mov [edi],al
	add edi,3
	loop .cycle

	mov esi,msg_Flags
	call WriteString

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	popfd
	ret

;----------------
; Funkce WriteIntX (8,16,32) {WriteInt8,WriteInt16,WriteInt32}
; Vypise 8-, 16-, 32-bitovou celociselnou hodnotu se znamenkem z registru AL, AX, EAX
;
;----------------
; Funkce WriteUIntX (8,16,32) {WriteUInt8,WriteUInt16,WriteUInt32}
; Vypise 8-, 16-, 32-bitovou celociselnou hodnotu bez znamenka z registru AL, AX, EAX
;
; Chovani funkci je dano chovanim funkce PRINTF a prislusnym formatovacim retezcem.
;

WriteInt8:
	pushfd
	push eax
	movsx eax,al
	jmp WriteInt

WriteUInt8:
	pushfd
	push eax
	movzx eax,al
	jmp WriteUInt

WriteInt16:
	pushfd
	push eax
	movsx eax,ax
	jmp WriteInt 

WriteUInt16:
	pushfd
	push eax
	movzx eax,ax
	jmp WriteUInt

WriteInt32:
	pushfd
	push eax

WriteInt:
	push ecx
	push edx

	PRINTF format_int, eax
	
	pop edx
	pop ecx
	pop eax
	popfd
	ret

WriteUInt32:
	pushfd
	push eax

WriteUInt:
	push ecx
	push edx

	PRINTF format_uint, eax

	pop edx
	pop ecx
	pop eax
	popfd
	ret

;----------------
; Funkce WriteHexX (8,16,32) {WriteHex8,WriteHex16,WriteHex32}
; Vypise hexadecimalne 8-, 16-, 32-bitovou celociselnou hodnotu bez znamenka z registru AL, AX, EAX
;
; Chovani funkci je dano chovanim funkce PRINTF a prislusnym formatovacim retezcem.
;

WriteHex8:
	pushfd
	push eax
	push esi
	movzx eax,al
	mov esi,format_hex8
	jmp WriteHex

WriteHex16:
	pushfd
	push eax
	push esi
	movzx eax,ax
	mov esi,format_hex16
	jmp WriteHex

WriteHex32:
	pushfd
	push eax
	push esi
	mov esi,format_hex32

WriteHex:
	push ecx
	push edx

	PRINTF esi, eax

	pop edx
	pop ecx
	pop esi
	pop eax
	popfd
	ret

;----------------
; Funkce WriteFloat
; Vypise 32-bitove realne cislo z registru EAX
;
WriteFloat:
	pushfd
	push eax
	push ecx
	push edx

	push eax
	fld dword [esp]
	sub esp, 4
	fstp qword [esp]
	push dword format_float
	invoke printf			; printf vyzaduje vzdy double!
	add esp,12

	pop edx
	pop ecx
	pop eax
	popfd
	ret

;----------------
; Funkce WriteDouble
; Vypise 64-bitove realne cislo z registru koprocesoru ST0
;
WriteDouble:
	pushfd
	push eax
	push ecx
	push edx

	sub esp,8
	fst qword [esp]
	push dword format_double
	invoke printf
	add esp,12

	pop edx
	pop ecx
	pop eax
	popfd
	ret
