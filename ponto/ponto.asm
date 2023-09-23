;programa para mover um ponto na tela
;autor: Eng. Fabrício de Lima Ribeiro
;23/09/2023
;
;para compilar:
;   nasm ponto.asm
;para executar:
;   qemu-system-i386 ponto

org 7C00h
jmp main

;Constantes


;Variáveis
x_width  dw  140h
y_height dw  0c8h
timer   dw  00h
pos_x   dw  00h
pos_y   dw  00h
vel_x   dw  05h
vel_y   dw  02h

main:

loop:
    call configura_video
    call desenha_pixel
    call move_ponto
    call delay
    jmp loop
    ;jmp $           ;loop infinito

move_ponto:
    
    ;x
    mov cx, [vel_x]
    add [pos_x], cx

    mov cx, 00h
    cmp [pos_x], cx
    jl neg_vel_x

    mov cx, [x_width]
    cmp [pos_x], cx
    jg neg_vel_x

    ;y
    mov cx, [vel_y]
    add [pos_y], cx

    mov cx, 00h
    cmp [pos_y], cx
    jl neg_vel_y

    mov cx, [y_height]
    cmp [pos_y], cx
    jg neg_vel_y

    ret

neg_vel_x:
    mov cx, [vel_x]
    neg cx 
    mov [vel_x], cx   
    ret

neg_vel_y:
    mov cx, [vel_y]
    neg cx 
    mov [vel_y], cx   
    ret

    ;Configura o vídeo
configura_video:
    mov ah, 00h     ;Set video mode
    mov al, 13h     ;320x200 256 color graphics (MCGA,VGA)
    int 10h
    ;configura a cor de funto
    mov ah, 0bh     ;Set Color Palette
    mov bh, 00h     ;to set background and border color
    mov bl, 00h     ;color value (when BH = 0)
    int 10h
    ret

;desenha um pixel
desenha_pixel:  
    mov ah, 0ch     ;Write Graphics Pixel at Coordinate
    mov al, 0fh     ;color value (XOR'ED with current pixel if bit 7=1)
    mov bh, 00h     ;page number
    mov cx, [pos_x]   ;column number (zero based)
    mov dx, [pos_y]   ;row number (zero based)
    int 10h
    ret

;rotina de delay
delay:
    mov ah, 00h
    int 1ah
    cmp dx, [timer]
    je delay
    mov [timer], dx
    ret

times 510 - ($-$$) db 0

dw 0AA55h