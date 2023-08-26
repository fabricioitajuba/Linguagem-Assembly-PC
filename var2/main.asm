;teste - ainda não funcionou

section .data
        var db ' '

section .text
        global  _start:

_start:

    mov ah, 2     ;
    ;mov dl, min2  ;
    mov dl, 2  ;
    add dl, 30h   ;
    int 21h       ;
    
    ;Fim do programa
    mov ah, 4ch
    int 21h