chunksize equ 8

;-------------------------------------------
; printf_
;-------------------------------------------
;ENTRY:	 	top of stack - format string
;           at stack - args in cdecl
;EXIT:		NONE
;EXPECT:	NONE
;DESTOYS:	rax, rbx, rdx, rsi
;-------------------------------------------
section .text
printf_:
    push rbp
    mov rbp, rsp

    mov rbx, [rbp + 2 * chunksize]
    mov rdx, 3 * chunksize
    _$startloop:
        cmp byte [rbx], 0
        je _$break

        cmp byte [rbx], '\' ; if not spec symbol as \t or \n
        je _$specsymb

        cmp byte [rbx], '%' ; if form output
        je _$formsymb

        ; print manual symbol
            push rbx
            push rdx
            movsx rsi, byte [rbx]
            push rsi
            call putc_
            pop rsi
            pop rdx
            pop rbx

            inc rbx
            jmp _$startloop
        ;

        _$specsymb:           ; if is _$specsymb

            inc rbx

            cmp byte [rbx], 'r'
                jb _$abn_BS_s
                ja _$t_s

                push cr_symb
                call putc_
                pop rsi

                inc rbx
                jmp _$startloop
            _$abn_BS_s:
                cmp byte [rbx], 'b'
                jb _$a_BS_s
                ja _$n_s

                push bs_symb
                call putc_
                pop rsi

                inc rbx
                jmp _$startloop

                _$n_s:
                    cmp byte [rbx], 'n'
                    jne _$missymb

                    push lf_symb
                    call putc_
                    pop rsi

                    inc rbx
                    jmp _$startloop


                _$a_BS_s:
                    cmp byte [rbx], '\'
                    jne _$a_s
                    
                    push '\'
                    call putc_
                    pop rsi

                    inc rbx
                    jmp _$startloop
                _$a_s:
                    cmp byte [rbx], 'a'
                    jne _$end_s
                    
                    push belsymb
                    call putc_
                    pop rsi

                    inc rbx
                    jmp _$startloop
                _$end_s:
                    cmp byte [rbx], '0'
                    je _$break
                    jmp _$missymb
            _$t_s:
                cmp byte [rbx], 't'
                jne _$missymb

                push tabsymb
                call putc_
                pop rsi

                inc rbx
                jmp _$startloop
            ;
        
        _$formsymb:
            inc rbx

            cmp byte [rbx], '%'
            jne _$notper

                push '%'
                call putc_
                pop rsi

                inc rbx
                jmp _$startloop

            _$notper:
                cmp byte [rbx], 'b'
                jb _$missymb

                cmp byte [rbx], 'x'
                ja _$missymb

                movsx rax, byte [rbx]
                sub rax, 'b'

                push rdx
                mov rsi, chunksize
                mul rsi
                pop rdx

                mov rsi, [jmptbl + rax]
                jmp rsi

            _$b_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_b_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
            _$d_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_d_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
            _$o_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_o_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
            _$s_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_s_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
            _$u_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_u_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
            _$x_form:
                push rbx
                push rdx
                
                mov rsi, [rbp + rdx]
                push rsi
                call prt_x_
                pop rsi
                pop rdx
                pop rbx

                add rdx, chunksize
                inc rbx
                jmp _$startloop
        _$missymb:

        movsx rsi, byte [rbx - 1]
        push rsi
        call putc_
        pop rsi

    jmp _$startloop

    _$break:
    pop rbp
    ret
section .data
    jmptbl: dq _$b_form, _$missymb, _$d_form, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$missymb, _$o_form, _$missymb, _$missymb,  _$missymb, _$s_form, _$missymb, _$u_form, _$missymb, _$missymb, _$x_form


