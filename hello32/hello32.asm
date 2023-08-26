;Hello world em 64 bits

section .data
        msg db 'Hello, World!', 0xA, 0xD
        tam equ $- msg

section .text
        global  _start

_start:
        ;Impressão da string
        mov EAX, 0x4
        mov EBX, 0x1
        mov ECX, msg
        mov EDX, tam
        int 0x80

        ;Fim do programa
        mov EAX, 0x1
        mov EBX, 0x0
        int 0x80