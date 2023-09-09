;Imprime um byte em hexadecimal
;Autor: Eng. Fabrício de Lima Ribeiro
;08/09/2023

section .data

section .bss
        _byte resb 2

section .text
        global  _start

_start:
        mov rax, 0xFA
        mov rsi, _byte
        call byte_hexa

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall

;-------------------------------------------------------------
;Rotina de impressão do byte
;Entrada: rax o byte a ser visualizado
;         rsi o ponteiro da string
;-------------------------------------------------------------
byte_hexa:
        push rax        ;coloca o valor de rax na pilha
        ror rax, 4      ;rotaciona 4 bits para a direita
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle prox_digito ;se for menor ou igual, salta para prox_digito
        add rax, 0x7    ;se não, adiciona 7.
prox_digito:
        mov [rsi], rax  ;guarda o valor em rax em _byte
        inc rsi         ;incrementa rsi
        pop rax         ;recupera rax
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle fim         ;se for menor ou igual, salta para prox_digito
        add rax, 0x7    ;se não, adiciona 7.    
fim:
        mov [rsi], rax  ;guarda o valor em rax em _byte

        ;Impressão do byte
        mov rax, 1
        mov rdi, 1
        mov rsi, _byte
        mov rdx, 2
        syscall

        ret