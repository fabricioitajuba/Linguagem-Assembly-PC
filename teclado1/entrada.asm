segment .data
	LF equ 0xA  ; Line Feed
	CR equ 0xD  ; Final da String

	SYS_EXIT  equ 0x1  ; Codigo de chamada para finalizar
	SYS_READ  equ 0x3  ; Operacao de leitura
	SYS_WRITE equ 0x4  ; Operacao de escrita

	RET_EXIT  equ 0x0  ; Operacao realizada com Sucesso
	STD_IN    equ 0x0  ; Entrada padrao
	STD_OUT   equ 0x1  ; Saida padrao

section .data
	msg1 db "Entre com seu nome:", LF, CR
	tam1 equ $- msg1
	msg2 db "olá "
 	tam2 equ $- msg2

section .bss
	nome resb 10  

section .text  
	global _start

_start:
	mov EAX, SYS_WRITE	;chamada para
	mov EBX, STD_OUT	;escrita na tela
	mov ECX, msg1		;da mensagem
	mov EDX, tam1		;msg1
	int 80h

	mov EAX, SYS_READ	;chamada para
	mov EBX, STD_IN		;leitura do teclado
	mov ECX, nome		;armazenar no máximo
	mov EDX, 10		;10 bytes em nome
	int 80h

	mov EAX, SYS_WRITE	;chamada para
	mov EBX, STD_OUT	;escrita na tela
	mov ECX, msg2		;da mensagem
	mov EDX, tam2		;msg2
	int 80h

	mov EAX, SYS_WRITE	;chamada para
	mov EBX, STD_OUT	;escrita na tela
	mov ECX, nome		;do nome
	mov EDX, 10		;digitado, 10 bytes
	int 80h

	mov EAX, SYS_EXIT	;Finaliza o programa
	mov EBX, RET_EXIT	;e retorna ao
	int 80h			;sistema operacional
