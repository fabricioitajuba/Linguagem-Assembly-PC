;Este programa faz a leitura de uma linha de um arquivo padronizado
;24/08/2023

%include 'bibliotecaE.inc'

SECTION .data
  arq   db  "dados.txt"
  tam   equ 13          ;Número de bytes lidos

SECTION .bss
  fd     resb 4
  buffer resb 13        ;buffer de leitura

SECTION .text

global _start:

_start:
    mov eax, OPEN_FILE
    mov ebx, arq
    mov ecx, OPEN_READ
    int SYS_CALL
    mov [fd], eax

posicionar:
    mov eax, SEEK_FILE
    mov ebx, [fd]
    mov ecx, 13         ;Inicio da leitura 13*i p/i[0..n] i=linha
    mov edx, SEEK_SET   ;Configurar para ler apartir de uma posição
    int SYS_CALL

ler:
    mov eax, READ_FILE
    mov ebx, [fd]
    mov ecx, buffer
    mov edx, tam
    int SYS_CALL

saidaNoConsole:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, buffer
    mov edx, tam
    int SYS_CALL

fechar:
    mov eax, CLOSE_FILE
    mov ebx, [fd]
    int SYS_CALL

termino:
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCESS 
    int SYS_CALL   