;Este programa cria um arquivo e insere um texto dentro
;24/08/2023

%include 'biblioteca.inc'

SECTION .data
  filename  db  "dados.txt", NULL

  text    db  "Será inserida essa frase...", "Ok!", LF, CR
  tamTex  equ $ - text

SECTION .bss
  fd     resb 4           ;File descriptor

SECTION .text

global _start:

_start:
    ;Cria o arquivo
    mov eax, CREATE_FILE  ;Cria o arquivo
    mov ebx, filename     ;Nome do arquivo
    mov ecx, 0o664        ;Permissões do arquivo
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