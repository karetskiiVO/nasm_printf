chunksize equ 8

;-------------------------------------------
; putc
;-------------------------------------------
;ENTRY:	 	top of stack - character in lower byte
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax
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
; print oct, same as %o
;-------------------------------------------
;ENTRY:	 	top of stack - number
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx
;-------------------------------------------
octmask equ 7
section .text
prt_o_:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 2 * chunksize]
    mov rbx, rax
    
    and rbx, octmask
    shr rax, 3

    cmp rax, 0
    je skip0

        push rbx
        push rax
        call prt_o_
        pop rax
        pop rbx

    skip0:
    
    add rbx, '0'
    push rbx
    call putc_
    pop rbx

    pop rbp
    ret

;-------------------------------------------
; print oct, same as %h
;-------------------------------------------
;ENTRY:	 	top of stack - number
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx
;-------------------------------------------
hexmask equ 15
section .text
prt_x_:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 2 * chunksize]
    mov rbx, rax
    
    and rbx, hexmask
    shr rax, 4

    cmp rax, 0
    je skip1

        push rbx
        push rax
        call prt_x_
        pop rax
        pop rbx

    skip1:
    
    cmp rbx, 10
    jl numchar
    add rbx, 'a' - '0' - 10

    numchar:
    add rbx, '0'

    push rbx
    call putc_
    pop rbx

    pop rbp
    ret

;-------------------------------------------
; print bin
;-------------------------------------------
;ENTRY:	 	top of stack - number
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx
;-------------------------------------------
binmask equ 1
section .text
prt_b_:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 2 * chunksize]
    mov rbx, rax
    
    and rbx, binmask
    shr rax, 1

    cmp rax, 0
    je skip2

        push rbx
        push rax
        call prt_b_
        pop rax
        pop rbx

    skip2:
    add rbx, '0'

    push rbx
    call putc_
    pop rbx

    pop rbp
    ret

;-------------------------------------------
; strlen
;-------------------------------------------
;ENTRY:	 	top of stack - str pointer
;EXIT:		rax - strlen([sp])
;EXPECT:	NONE
;DESTOYS:	rax, rbx
;-------------------------------------------
section .text
strlen_:
    xor rax, rax
    mov rbx, [rsp + chunksize]

    startloop:
    cmp byte [rbx], 0
    je break

    inc rax
    inc rbx

    jmp startloop
    break:

    ret

;-------------------------------------------
; print unsigned dec, same as %u
;-------------------------------------------
;ENTRY:	 	top of stack - str pointer
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx, rdx
;-------------------------------------------
decbase equ 10
section .text
prt_u_:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 2 * chunksize]
    
    ;change here
    xor rdx, rdx
    mov rbx, decbase
    div rbx
    mov rbx, rdx

    cmp rax, 0
    je skip3

        push rbx
        push rax
        call prt_u_
        pop rax
        pop rbx

    skip3:
    add rbx, '0'

    push rbx
    call putc_
    pop rbx

    pop rbp
    ret

;-------------------------------------------
; print unsigned dec, same as %d
;-------------------------------------------
;ENTRY:	 	
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx
;-------------------------------------------
section .text
prt_d_:
    mov rax, [rsp + chunksize]
    cmp rax, 0
    jge morezero0

        xor rbx, rbx
        sub rbx, rax
        
        push '-'
        call putc_

        mov rax, rbx
        pop rbx
        
    morezero0:

    push rax
    call prt_u_
    pop rax
    
    ret