;--------------------------------------------------
; Padrão de cores melhorado com endereçamento indexado
; Autor: Eng. Fabrício de Lima Ribeiro
; 01/10/2023
;
; para compilar:
; 	nasm boot1.asm
; para executar:
; 	qemu-system-i386 boot1
;--------------------------------------------------
[bits 16]
[org 0x7c00]

jmp inicio

Max_H   equ 80  ;Número máximo de linhas na horizontal
Max_V   equ 25  ;Número máximo de linhas na vertical
n       equ 10  ;Número de cores por linha

;Branco, amarelo, cian, verde, magenta, vermelho, azul, preto
cores db 0xF0, 0xE0, 0xB0, 0x20, 0x50, 0x40, 0x10, 0x00

inicio:

	;set up vídeo mode
	mov ah, 00h     
	mov al, 03h     ;text mode 80x25 characters, 16 color VGA
	int 10h

	mov dh, 00h	;Linha
loop:	
    call plota_linha
	inc dh
	cmp dh, Max_V
	jne loop

	jmp $

;---------------------------
; dh - linha
;---------------------------
plota_linha:

    push ax
    push bx
    push cx
    push dx
    push si

	;Set cursor position
    mov cl, 0
    mov ch, 0
    mov si, 0

loop1:
	mov dl, cl	            ;Seleciona a coluna
	call set_pos            ;Posiciona a coluna

	mov bl, [cores + si]	;Seleciona a cor
	call set_color          ;Imprime a cor  

    add cl, n
    cmp cl, Max_H
    je fim
    inc si
    jmp loop1

fim:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret


;---------------------------
; dh - linha
; dl - coluna
;---------------------------
set_pos:
	;Set cursor position
    push ax
    push bx

	mov ah, 02h
	mov bh, 00h
	int 10h	
	
    pop bx
    pop ax

    ret

;---------------------------
; bl - cor
;---------------------------
set_color:

    push ax
    push bx
    push cx

	mov ah, 09h
	mov al, ' '	;ASCII character to write
	mov bh, 00h	;display page
	mov cx, n	;count of characters to write (CX >= 1)
	int 10h

    pop cx
    pop bx
    pop ax

	ret

times 510 - ($-$$) db 0
dw 0xAA55