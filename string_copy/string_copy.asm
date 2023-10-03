;Copia uma string
;Autor: Eng. Fabrício de Lima Ribeiro
;03/10/2023

section .data
	msg db 'Texto a ser impresso! ', 10, 0

section .bss
	buffer resb 30	;reserva 30 bytes
        
section .text
        global  _start

_start:

	;Copy string
	mov rsi, msg		;Source Index (fonte)
	mov rdi, buffer		;Destination Index (destino)
	call string_copy

        mov rsi, buffer		;ponteiro da string
        call string_print	;imprime a string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall


; -----------------------------------
; Copy String
; SI - Ponteiro da string fonte
; DI - Ponteiro da string destino
; -----------------------------------
string_copy:
	push rax
	push rsi
	push rdi
copy_string_loop:
	mov al, [rsi]
	cmp al, 0
	je copy_string_fim
	mov [rdi], al
	inc rsi
	inc rdi
	jmp copy_string_loop
copy_string_fim:
	pop rdi
	pop rsi
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