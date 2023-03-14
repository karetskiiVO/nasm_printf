section .text
    global _start
_start:
    mov rsi, -12
    push rsi
    push tstr
    push fstr
    call printf_
    pop rsi

    call exit_


%include "asmprintf.asm"

section .data
    fstr:   db 's %s:%d\n', 0
    tstr:   db 'boba\0'    