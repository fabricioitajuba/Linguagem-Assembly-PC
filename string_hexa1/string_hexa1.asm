;Este programa, lê um número em hexadecimal pelo teclado (string)
;converte para hexadecimal e converte de hexadecimal para string
;Autor: Eng. Fabrício de Lima Ribeiro
;05/10/2023
;
;                      xx ->  8 bits - 1 x 8 bits
;                   xx xx -> 16 bits - 2 x 8 bits
;             xx xx xx xx -> 32 bits - 4 x 8 bits
; xx xx xx xx xx xx xx xx -> 64 bits - 8 x 8 bits
;

section .data
	SYS_READ      equ 0      ; Código de leitura do teclado
	STD_IN        equ 0      ; System.in

section .bss
	num: resq 1
	buffer resb 17		;reserva 17 bytes
	buffer_teclado resb 4	;reserva 4 bytes

section .text
        global  _start

_start:

	;Faz a leitura do teclado
	mov RAX, SYS_READ 	;Chamada de leitura
	mov RDI, STD_IN   	;Entrada padrão
	mov RSI, buffer_teclado ;Guarda a tecla lida em val2
	mov RDX, 4        	;lê até 4 digitos
	syscall

	;Converte a String para Hexadecimal
	mov rsi, buffer_teclado	;ponteiro da string hexa
	mov rdi, num		;Ponteiro do número a ser convertido
	call string_hexa

	mov rax, [num]

	;Converte o número em hexadecimal para string
        ;mov rax, 0x0123456789ABCDEF
        mov rdx, 2              ;número de bytes a ser impresso
        mov rsi, buffer		;local de armazenamento da string
        call hexa_string	;converte de hexa para string
        mov rsi, buffer		;local de armazenamento da string
        call string_print	;imprime a string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall

;-------------------------------------------------------------
;Rotina de conversão de string para hexadecimal
; rsi - ponteiro da string hexa
; rdi - ponteiro do número a ser convertido
;-------------------------------------------------------------
string_hexa:

	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi

	xor rax, rax
	mov [num], rax

string_hexa_p2:

	mov al, [rsi]
	cmp al, 0
	je string_hexa_fim

	sub al, '0'
	cmp al, 09h
	jle string_hexa_p1
	sub al, 07h

string_hexa_p1:

	push rax
	mov rbx, 10h
	mov rax, [num]
	mul rbx
	mov [num], rax
	pop rax
	or [num], al
	inc rsi
	jmp string_hexa_p2		

string_hexa_fim:

	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret


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