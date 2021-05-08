;--------------------------------------
; Leitura em arquivos
; Eng. Fabrício de Lima Ribeiro
; 08/04/2021
;
; nasm -f elf64 read.asm
; ld -s -o read read.o
;--------------------------------------

%include "linux64.inc"

section .data
	filename db "arquivo.txt",0
	linha    db 0xA, 0xD

section .bss
	text resb 18

section	.text
	global _start

_start:
	;Open the file
	mov rax, SYS_OPEN
	mov rdi, filename
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall

	;Read to the file
	push rax
	mov rdi, rax
	mov rax, SYS_READ
	mov rsi, text
	mov rdx, 19
	syscall

	;Close the file
	mov rax, SYS_CLOSE
	pop rdi
	syscall

	print text
	print linha
	exit
	
