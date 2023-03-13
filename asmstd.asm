;-------------------------------------------
; putc
;-------------------------------------------
;ENTRY:	 	top of stack - character in lower byte
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, top of stack
;-------------------------------------------
section .text
putc_:
    push rbp
    mov rbp, rsp

    xor rax, rax
    mov eax, [rbp + 16]
    mov [chr], al
    
    mov rax, 0x01
    mov rsi, chr
    mov rdx, 1

    syscall

    pop rbp
    ret
section .data
    chr     db  '0'

;-------------------------------------------
; exit
;-------------------------------------------
;ENTRY:	 	top of stack - error type
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	NONE
;-------------------------------------------
section .text
exit_:
    mov	rax, 60
    xor rdi, rdi

    syscall

    ret    

;-------------------------------------------
; print num oct
;-------------------------------------------
;ENTRY:	 	top of stack - number
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx, top of stack
;-------------------------------------------
octmask equ 7
section .text
prtnum_:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 16]
    mov rbx, rax
    
    and rbx, octmask
    shr rax, 3

    cmp rax, 0
    je skip0

        push rbx
        push rax
        call prtnum_
        pop rax
        pop rbx

    skip0:
    
    add rbx, '0'
    push rbx
    call putc_
    pop rbx

    pop rbp
    ret

