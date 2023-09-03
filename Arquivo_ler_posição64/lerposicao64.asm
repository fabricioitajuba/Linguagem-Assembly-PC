;----------------------------------------
;Leitura de um arquivo em 64 bits
;Eng. Fabrício de Lima Ribeiro
;03/09/2023
;----------------------------------------
 
section .data
    SYS_READ	equ	0
    SYS_WRITE	equ	1
    SYS_OPEN	equ	2
    SYS_CLOSE	equ	3
    SYS_LSEEK	equ	8
    SYS_EXIT	equ	60
        
    STDIN	    equ	0
    O_RDONLY	equ	0
    
    filename db "dados.txt",0

    linha       equ 2     ;Qual linha deseja ler
    tamanho     equ 13    ;Tamanho de bytes lidos(foi padronizado 13 par esse arquivo)
 
section .bss
    fd resb 4           ;File Descriptor
    text resb 30        ;Buffer de leitura
 	printSpace resb 8

section .text
    global _start

_start:
    ;abre o arquivo para leitura
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    mov [fd], rax               ;guarda o fd

    mov rdi, [fd]       
    mov rax, SYS_LSEEK
    mov rsi, (tamanho*linha)    ;Posição de leitura dentro do arquivo
    mov rdx, 0                  ;keep 0 if the offset should be from the begining of the file
    syscall

    ;faz a leitura do arquivo
    mov rdi, [fd]
    mov rax, SYS_READ
    mov rsi, text
    mov rdx, tamanho            ;Número de bytes lidos
    syscall
 
    ;fecha o arquivo
    mov rax, SYS_CLOSE
    mov rdi, [fd]
    syscall
 
    ;mostra na tela o conteúdo do arquivo
	mov rax, text
	mov [printSpace], rax
	mov rbx, 0
printLoop:
	mov cl, [rax]
	cmp cl, 0
	je endPrintLoop
	inc rbx
	inc rax
	jmp printLoop
endPrintLoop:
	mov rax, SYS_WRITE
	mov rdi, STDIN
	mov rsi, [printSpace]
	mov rdx, rbx
	syscall

    ;Sai do programa e retorna ao SO
	mov rax, SYS_EXIT
	mov rdi, 0
	syscall