;----------------------------------------
;Criação e escrita de um arquivo em 64 bits
;Eng. Fabrício de Lima Ribeiro
;03/09/2023
;----------------------------------------
 
section .data
    SYS_WRITE	equ	1
    SYS_OPEN	equ	2
    SYS_CLOSE	equ	3
    SYS_EXIT	equ	60

    O_WRONLY	equ	1
    O_CREAT		equ	64

    filename db "Arquivo.txt",0
    text db "Isto será escrito no arquivo!"
 
section .bss
    fd  resb 4          ;File Descriptor

section .text
    global _start
_start:
    ;Abre o arquivo ou cria caso não exista
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_CREAT+O_WRONLY   ;Cria o arquivo caso não exista
    mov rdx, 0644o              ;Permissões
    syscall

    mov [fd], rax ; armazenar o valor do File Descriptor
    
    ;Escreve no arquivo
    mov rax, SYS_WRITE
    mov rdi, [fd]    
    mov rsi, text
    mov rdx, 30                 ;Número de bytes a serem escritos
    syscall
 
    ;Fecha o arquivo
    mov rax, SYS_CLOSE
    mov rdi, [fd]
    syscall
 
    ;Sai do programa e retorna ao SO
	mov rax, SYS_EXIT
	mov rdi, 0
	syscall