;trabalhando com variávies de 8bits

section .data
        var db ' '

section .text
        global  _start:

_start:

    mov dl, 0x2   ; valor a ser plotado 
    add dl, 0x30
    mov [var], dl

    ;Impressão da string
    mov EAX, 4h
    mov EBX, 1h
    mov ECX, var
    mov EDX, 1h
    int 80h
    
    ;Fim do programa
    mov eax, 1h
    mov ebx, 0h
    int 80h