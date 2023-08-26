;Hello world em 64 bits

section .data
        msg db 'Hello, World!', 0xA, 0xD
        tam equ $- msg

section .text
        global  _start

_start:
        ;Impressão da string
        mov rax, 1
        mov rdi, 1
        mov rsi, msg
        mov rdx, tam
        syscall

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall