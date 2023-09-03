;Exemplo de utilização:
;$ ./parametros2 "paran1"
;$ ./parametros2 1

%include "linux64.inc"

section .data
	newline db 10,0

section .bss
	argc resb 8
	argPos resb 8

section .text
	global _start

_start:
	pop rax		;tem que possuir
	pop rax		;./nomedoarquivo
	pop rax		;parâmetro digitado após ./nomedoarquivo
	print rax
	print newline

	exit