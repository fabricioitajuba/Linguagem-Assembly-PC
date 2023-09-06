;---------------------------------------------------
;Converte string para inteiro e inteiro para string
;Autor: Eng. Fabrício de Lima Ribeiro
;64 bits
;06/09/2023
;Rotina Int_String otimizada
;---------------------------------------------------

section .data
    text db "123456"	;String

section .bss
    buffer resb 10	;Buffer para armazenar a string convertida

section .text
    global _start
 
_start:
    mov RSI, text	;RSI recebe o endereço inicial de text
    call String_Int

    add rax, 1

    mov RSI, buffer	;RSI recebe o endereço inicial de buffer
    call Int_String

    ;imprime a string
    mov RSI, buffer	;RSI recebe o endereço inicial de buffer
    mov rax, 1
    mov rdi, 1
    mov rdx, 10
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
    xor rcx, rcx
.prox_digito:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    cmp rax, 0
    jnz .prox_digito
.prox_carac:
    pop rdx
    mov byte[rsi], dl
    inc rsi
    dec rcx
    jnz .prox_carac
    mov byte[rsi], 0
    ret