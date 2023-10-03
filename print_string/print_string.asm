;Imprime uma string
;Autor: Eng. Fabrício de Lima Ribeiro
;08/09/2023

section .data
	msg db 'Texto a ser impresso! ', 10, 0

section .bss
        
section .text
        global  _start

_start:

        mov rsi, msg 		;ponteiro da string
        call print_string	;imprime a string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall


; -----------------------------------
; Print String
; Entrada: Ponteiro da string em RSI
; -----------------------------------
print_string:

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