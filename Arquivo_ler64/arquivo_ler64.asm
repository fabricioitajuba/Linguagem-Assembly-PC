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
    SYS_EXIT	equ	60
        
    STDIN	    equ	0

    O_RDONLY	equ	0
    
    filename db "arquivo.txt",0
 
section .bss
    text resb 30        ;Buffer de leitura
 	printSpace resb 8
    fd  resb 4          ;File Descriptor
section .text
    global _start

_start:
    ;abre o arquivo para leitura
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    mov [fd], rax ; armazenar o valor do File Descriptor
    
    ;faz a leitura do arquivo
    mov rax, SYS_READ
    mov rdi, [fd]
    mov rsi, text
    mov rdx, 30         ;Número de bytes lidos
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