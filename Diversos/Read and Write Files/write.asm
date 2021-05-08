;--------------------------------------
; Escrita em arquivos
; Eng. Fabrício de Lima Ribeiro
; 08/04/2021
;
; nasm -f elf64 write.asm
; ld -s -o write write.o
;--------------------------------------

%include "linux64.inc"

section .data
	filename db "arquivo.txt",0
	text db "Isso será escrito.", 0xA, 0xD
	len  equ $ - text

section	.text
	global _start

_start:
	;Open the file
	mov rax, SYS_OPEN
	mov rdi, filename
	mov rsi, O_CREAT+O_WRONLY
	mov rdx, 0644o            ;Permissão 664 o(octonal)
	syscall

	;Write to the file
	push rax
	mov rdi, rax
	mov rax, SYS_WRITE
	mov rsi, text
	mov rdx, len              ;Número de bytes a serem escritos
	syscall

	;Close the file
	mov rax, SYS_CLOSE
	pop rdi
	syscall

	exit
		
