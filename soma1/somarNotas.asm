%include 'bibliotecaE.inc'

section .data
    dispMsg db 'Resultado: '
    tamDispMsg  equ $-dispMsg
    salto   db '',LF
    tamValor    db 0

section .bss
    val1    resw    1
    val2    resw    1
    soma    resb    2

section .text

global _start:

_start:

    mov byte[soma], 0       ;Zera soma
    mov dword[val1], '21'   ;Acrecenta 21 (string) na posição val1
    mov dword[val2], '12'   ;Acrecenta 12 (string) na posição val2

    lea ESI, [val1]         ;pega o endereço de val1
    mov ECX, 0x2            ;números de caracteres da string
    call string_to_int      ;converte de string para inteiro
    add [soma], EAX         ;adiciona o número convertido a variável soma

    lea ESI, [val2]         ;pega o endereço de val2
    mov ECX, 0x2            ;números de caracteres da string
    call string_to_int      ;converte de string para inteiro
    add [soma], EAX         ;adiciona o número convertido a variável soma

    mov EAX, SYS_WRITE      ;Imprime
    mov EBX, STD_OUT        ;a
    mov ECX, dispMsg        ;mensagem
    mov EDX, tamDispMsg     ;Resultado:
    int 80h

    ;Imprime o resultado
    mov EAX, [soma]
    call int_to_string
    mov ECX, EAX
    call tamStr
    mov EAX, SYS_WRITE
    mov EBX, STD_OUT
    int 80h
    
    ;Pula uma linha
    mov EAX, SYS_WRITE
    mov EBX, STD_OUT
    mov ECX, salto
    mov EDX, 0x2
    int 80h

    ;Finaliza o programa e volta ao sistema
    mov EAX, SYS_EXIT
    mov EBX, EXIT_SUCESS
    int 80h