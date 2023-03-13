
section .text
    global _start
_start:
    xor rax, rax
    mov rax, 14512

    push rax
    call prtnum_
    pop rax    

    mov rax, 10
    push rax
    call putc_
    pop rax

    call exit_

%include "asmstd.asm"