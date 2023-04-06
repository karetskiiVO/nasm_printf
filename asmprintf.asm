global prtf

chunksize equ 8
;-------------------------------------------
; std call --> cdecl
;-------------------------------------------
;ENTRY:	 	same as func
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax
;-------------------------------------------
section .text
prtf:	; stdcall -> cdecl
    mov qword [_bufrbx], rbx
	pop rax
	mov qword [_bufret], rax

    s1:
    sub rsp, chunksize * 6

	push r9
    push r8
    push rcx
    push rdx
	push rsi
    push rdi
    s2:

	call print_
 
	add rsp, chunksize * 6

    mov rsi, qword [_bufret]
    push rsi

    mov rbx, [_bufrbx]
    ret

%include "asmprint.asm"
%include "asmstd.asm"
 
section .data
	_bufret dq 0
    _bufrbx dq 0
