;Este programa faz a leitura de todo arquivo
;24/08/2023

%include 'biblioteca.inc'

SECTION .data
  arq   db  "dados.txt"
  tam   equ 1024        ;Número de bytes lidos

SECTION .bss
  fd     resb 4
  buffer resb 1024      ;buffer de leitura 13 bytes

SECTION .text

global _start:

_start:
    ;Abre o arquivo para leitura
    mov eax, OPEN_FILE
    mov ebx, arq
    mov ecx, OPEN_READ
    int 80h

    mov [fd], eax       ;Guarda o valor do File Descriptor em fd

    ;Faz a leitura da quantidade de bytes a partir do local desejado
    mov eax, READ_FILE
    mov ebx, [fd]
    mov ecx, buffer     ;Guarda em buffer
    mov edx, tam        ;Tamanho desejado
    int 80h

    ;Mostra na tela o conteúdo lido
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, buffer
    mov edx, tam
    int 80h

    ;Fecha o arquivo
    mov eax, CLOSE_FILE
    mov ebx, [fd]
    int 80h

    ;Finaliza o programa e volta ao sistema operacional
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCESS 
    int 80h   