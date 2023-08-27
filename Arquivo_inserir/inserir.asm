;Este programa cria um arquivo caso não exista e insere um texto dentro
;toda vez que for executado será inserida uma novo texto dentro
;24/08/2023

%include 'biblioteca.inc'

SECTION .data
  filename  db  "dados.txt", NULL

  text    db  "Será inserida essa frase...", "Ok!", LF
  tamTex  equ $ - text

SECTION .bss
  fd     resb 4           ;File descriptor

SECTION .text

global _start:

_start:
    ;Abre o arquivo ou cria caso não exista
    mov eax, OPEN_FILE    ;Abre o arquivo
    mov ebx, filename     ;Nome do arquivo
    mov ecx, OPEN_CREATE + OPEN_WRITE + OPEN_APPEND ;Cria caso não exista, abre para escrita e inserção
    mov edx, 0o664        ;Permissões do arquivo
    int 80h

    mov [fd], eax         ;Guarda o valor do File Descriptor em fd

    ;Faz a escrita no arquivo
    mov eax, WRITE_FILE
    mov ebx, [fd]
    mov ecx, text         ;Endereço do texto
    mov edx, tamTex       ;Tamanho do texto
    int 80h

    ;Fecha o arquivo
    mov eax, CLOSE_FILE
    mov ebx, [fd]
    int 80h

    ;Finaliza o programa e volta ao sistema operacional
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCESS 
    int 80h