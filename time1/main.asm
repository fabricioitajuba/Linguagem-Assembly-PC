;obs - não funcionou ainda


section .data
    hour db ''  ;
    mins db ''   ; 
    hour1 db '' ;
    hour2 db '' ;initialize variables
    min1 db ''  ;
    min2 db ''  ;

section .text
        global  _start

_start:
    mov ah, 2ch   ;get time
    int 21h       ;

    mov byte[hour], ch  
    mov byte[mins], cl

    mov ah, 0     ;
    mov al, hour  ;divide by 10
    mov bl, 10    ;
    div bl        ;

    mov byte[hour1], al 
    mov byte[hour2], ah 

    mov ah, 2     ;
    mov dl, hour1 ;  
    add dl, 30h   ;
    int 21h       ;
                  ;print hour
    mov ah, 2     ;
    mov dl, hour2 ;
    add dl, 30h   ;
    int 21h       ;

    mov ah, 2     
    mov dl, ':'   
    int 21h       

    mov ah, 0     ;
    mov al, mins  ;divide by 10
    mov bl, 10    ;
    div bl        ;

    mov byte[min1], al  
    mov byte[min2], ah  

    mov ah, 2     ;
    mov dl, min1  ; 
    add dl, 30h   ;
    int 21h       ;
                  ;print minuntes
    mov ah, 2     ;
    mov dl, min2  ;
    add dl, 30h   ;
    int 21h       ;


    ;Fim do programa
    mov EAX, 0x1
    mov EBX, 0x0
    int 0x80