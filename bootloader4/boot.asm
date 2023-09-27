;--------------------------------------------------
; Padrão de cores
; Autor: Eng. Fabrício de Lima Ribeiro
; 27/09/2023
;
; para compilar:
; 	nasm boot.asm
; para executar:
; 	qemu-system-i386 boot
;--------------------------------------------------
[bits 16]
[org 0x7c00]

	;set up vídeo mode
	mov ah, 00h     
	mov al, 03h     ;text mode 80x25 characters, 16 color VGA
	int 10h

	mov dh, 00h	;Linha
loop:	call plota_linha
	inc dh
	cmp dh, 19h
	jne loop
	jmp $

;---------------------------
; dh - linha
;---------------------------
plota_linha:
	;Set cursor position
	mov dl, 00h	;column
	call set_pos

	mov bl, 0F0h	;Branco
	call set_color

	;Set cursor position
	mov dl, 0ah	;column
	call set_pos

	mov bl, 0E0h	;Amarelo
	call set_color

	;Set cursor position
	mov dl, 14h	;column
	call set_pos

	mov bl, 0b0h	;Cian
	call set_color

	;Set cursor position
	mov dl, 1eh	;column
	call set_pos

	mov bl, 20h	;Verde
	call set_color

	;Set cursor position
	mov dl, 28h	;column
	call set_pos

	mov bl, 50h	;Magenta
	call set_color

	;Set cursor position
	mov dl, 32h	;column
	call set_pos

	mov bl, 40h	;Vermelho
	call set_color

	;Set cursor position
	mov dl, 3ch	;column
	call set_pos

	mov bl, 10h	;Azul
	call set_color

	;Set cursor position
	mov dl, 46h	;column
	call set_pos

	mov bl, 00h	;Preto
	call set_color

	ret

;---------------------------
; dh - linha
; dl - coluna
;---------------------------
set_pos:
	;Set cursor position
	mov ah, 02h
	mov bh, 00h
	int 10h	
	ret

;---------------------------
; bl - cor
;---------------------------
set_color:
	mov ah, 09h
	mov al, ' '	;ASCII character to write
	mov bh, 00h	;display page
	mov cx, 0ah	;count of characters to write (CX >= 1)
	int 10h
	ret

times 510 - ($-$$) db 0
dw 0xAA55