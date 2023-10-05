;Imprime um byte em hexadecimal
;Autor: Eng. Fabrício de Lima Ribeiro
;08/09/2023
;
;                      xx ->  8 bits - 1 x 8 bits
;                   xx xx -> 16 bits - 2 x 8 bits
;             xx xx xx xx -> 32 bits - 4 x 8 bits
; xx xx xx xx xx xx xx xx -> 64 bits - 8 x 8 bits

section .data

section .bss
	buffer resb 17	;reserva 17 bytes

section .text
        global  _start

_start:
        ;mov rax, 0x12
        ;mov rax, 0x1234
        mov rax, 0x0123456789ABCDEF
        mov rdx, 8              ;número de bytes a ser impresso
        mov rsi, buffer		;local de armazenamento da string
        call hexa_string	;converte de hexa para string
        mov rsi, buffer		;local de armazenamento da string
        call string_print	;imprime a string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall

;-------------------------------------------------------------
;Rotina de conversão de hexadecimal para string
;Entrada: rax o valor em hexadecimal
;         rdx o número de bytes
;         rsi o ponteiro do buffer
;-------------------------------------------------------------
hexa_string:   

  	push rax
        push rbx
        push rcx
	push rdx
	push rsi

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

	pop rsi
	pop rdx
        pop rcx
        pop rbx
	pop rax

        ret

; -----------------------------------
; String Print
; Entrada: Ponteiro da string em RSI
; -----------------------------------
string_print:

	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi

	mov rbx, rsi
	xor rcx, rcx
print_loop:
	mov al, [rbx]
	cmp al, 0
	je fim_print
	inc rbx
	inc rcx
	jmp print_loop
fim_print:
	;Imprime a string, rsi possui o ponteiro
	mov rax, 1
	mov rdi, 1
	mov rdx, rcx ;quantidade de bytes
	syscall

	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret