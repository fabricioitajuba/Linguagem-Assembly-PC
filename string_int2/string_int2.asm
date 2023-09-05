;---------------------------------------------------
;Converte string para inteiro e inteiro para string
;Autor: Eng. Fabrício de Lima Ribeiro
;64 bits
;---------------------------------------------------

section .data
    text db "123456"		;String

section .bss
    text2 resb 10

section .text
    global _start
 
_start:
    mov RSI, text
    call String_Int
    mov RSI, text2
    call Int_String

    ;imprime a string
    mov rax, 1
    mov rdi, 1
    mov rdx, 6
    syscall    
 
    mov RAX, 60
    mov RDI, 0
    syscall

;-------------------------------------------
;String para inteiro
;Entrada: Ponteiro da String em RSI
;Saída: RAX - valor inteiro
;-------------------------------------------
String_Int:
    xor rax, rax
.prox_digit:
    mov dl, byte[rsi]
    inc rsi

    cmp dl, '0'
    jl .fim
    cmp dl, '9'
    jg .fim

    sub dl, '0'
    imul rax, 10
    add rax, rdx

    jmp .prox_digit
.fim:
    ret

;-------------------------------------------
;Inteiro para String
;Entrada: RAX - valor inteiro
;Saída: Tela
;-------------------------------------------
Int_String:
    mov rbx, 10
.prox_digit:
    mov rdx, 0
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    cmp rax, 0
    jnz .prox_digit
    ret