;Imprime bytes da memória
;Autor: Eng. Fabrício de Lima Ribeiro
;08/09/2023
;
;                      xx ->  8 bits - 1 x 8 bits
;                   xx xx -> 16 bits - 2 x 8 bits
;             xx xx xx xx -> 32 bits - 4 x 8 bits
; xx xx xx xx xx xx xx xx -> 64 bits - 8 x 8 bits

;####################### não finalizado

section .data
        ;end     equ     0x0000000000000000      ;endereço inicial
        space db ' ', 0
        linha db 10, 0

section .bss
        buffer resb 9 ;armazena a string convertida
        end resq 1

section .text
        global  _start

_start:
        mov rax, 0
        mov [end], rax

        ;imprime o endereço
        mov rax, end
        mov rdx, 8              ;número de bytes a ser impresso
        mov rsi, buffer
        call convert_hexa
        mov rsi, buffer
        call print_string

        ;espaço
        mov rsi, space
        call print_string

        ;imprime o byte no endereço
        mov rax, [end]
        mov rdx, 8              ;número de bytes a ser impresso
        mov rsi, buffer
        call convert_hexa
        mov rsi, buffer
        call print_string

        ;pula linha
        mov rsi, linha
        call print_string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall

;-------------------------------------------------------------
;Rotina de conversão para hexadecimal
;Entrada: rax o valor em hexadecimal
;         rdx o número de bytes
;         rsi o ponteiro da string
;-------------------------------------------------------------
convert_hexa:     
        push rbx
        push rcx
        mov rbx, rax
        mov rcx, rdx
loop1:
        mov rax, rbx
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle digito1     ;se for menor ou igual, salta para digito1
        add rax, 0x7    ;se não, adiciona 7.
digito1:
        push rax        ;guarda o valor convertido na pilha
        shr rbx, 4      ;rotaciona 4 bits para a direita
        mov rax, rbx
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle digito2     ;se for menor ou igual, salta para digito2
        add rax, 0x7    ;se não, adiciona 7.
digito2:
        push rax
        shr rbx, 4      ;rotaciona 4 bits para a direita
        dec rcx
        cmp rcx, 0
        jne loop1
        mov rcx, rdx
        shl rcx, 1      ;multiplica o número de bytes por 2
loop2:
        pop rax
        mov [rsi], rax
        inc rsi
        dec rcx
        cmp rcx, 0
        jne loop2
        mov al, 0
        inc rsi
        mov [rsi], al
        pop rcx
        pop rbx
        ret

; -----------------------------------
; Plota String
; Entrada: Ponteiro da string em RSI
; -----------------------------------
print_string:
	mov rax, rsi
	mov rbx, 0
_printLoop:
	inc rax
	inc rbx
	mov cl, [rax]
	cmp cl, 0
	jne _printLoop

	;Imprime a string
	mov rax, 1
	mov rdi, 1
	mov rdx, rbx
	syscall
	ret