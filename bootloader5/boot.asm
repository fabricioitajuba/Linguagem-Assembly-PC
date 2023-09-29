;--------------------------------------------------
; Quadriculados maiores
; Autor: Eng. Fabrício de Lima Ribeiro
; 29/09/2023
;
; para compilar:
; 	nasm boot.asm
; para executar:
; 	qemu-system-i386 boot
;--------------------------------------------------
[bits 16]
[org 0x7c00]

jmp	config

;Variáveis
pos_x:	db 00h
pos_y:	db 00h
cor:	db 0FFh
nl	db 00h

;Constantes
n_caracter equ 05h

config:
	;set up vídeo mode
	mov ah, 00h     
	mov al, 03h     ;text mode 80x25 characters, 16 color VGA
	int 10h

loop:	call linha
	call inverte_cor
	call linha
	call inverte_cor
	mov al, [pos_y]
	cmp al, 25
	jle loop

	jmp $

inverte_cor:
	mov bl, [cor]
	neg bl
	mov [cor], bl
	ret

linha:
	;Set cursor position
	mov dl, [pos_x]	;coluna
	mov dh, [pos_y]	;linha
	call set_pos

	mov bl, [cor]
	call set_color

	mov al, [pos_x]
	add al, 05h
	mov [pos_x], al

	;Set cursor position
	mov dl, [pos_x]	;coluna
	mov dh, [pos_y]	;linha
	call set_pos

	mov bl, [cor]
	neg bl
	call set_color

	mov al, [pos_x]
	add al, 05h
	cmp al, 80
	je fim1
	mov [pos_x], al
	jmp linha
fim1:	mov al, 0
	mov [pos_x], al
	mov al, 1
	add [pos_y], al
	add [nl], al
	mov al, [nl]
	cmp al, 2
	jne linha
	mov al, 0
	mov [nl], al
	ret	

;---------------------------------------------
; text mode 80x25 characters, 16 color VGA
; dh - linha
; dl - coluna
;---------------------------------------------
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
	mov al, ' '		;ASCII character to write
	mov bh, 00h		;display page
	mov cx, n_caracter 	;count of characters to write (CX >= 1)
	int 10h
	ret

times 510 - ($-$$) db 0
dw 0xAA55