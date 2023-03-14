
section .text
    global _start
_start:
    push -145
    call prt_d_
    pop rax

    mov rax, 10
    push rax
    call putc_
    pop rax

    call exit_

%include "asmstd.asm"

section .data
    msg:    db 'boba aboba', 0