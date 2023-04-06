section .text
    global _start
_start:
    mov rsi, -12
    push rsi
    push tstr
    push fstr
    call print_
    pop rsi

    call exit_


%include "asmprint.asm"
%include "asmstd.asm"

section .data
    fstr:   db 's %s:%d\n', 0
    tstr:   db 'boba\0'    