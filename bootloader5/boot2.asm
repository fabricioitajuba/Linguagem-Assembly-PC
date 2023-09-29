;--------------------------------------------------
; Quadriculados menores
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

jmp	config

;Variáveis
pos_x:	db 00h
pos_y:	db 00h
cor:	db 0FFh
n	db 00h

;Constantes
n_caracter equ 05h

config:
	;set up vídeo mode
	mov ah, 00h     
	mov al, 03h     ;text mode 80x25 characters, 16 color VGA
	int 10h

loop1:	call linha1
	mov al, [pos_x]
	cmp al, 80
	jne loop1
	mov bl, [cor]		;retirar
	neg bl			;para
	mov [cor], bl		;linhas contínuas
	mov al, [pos_y]
	inc al
	cmp al, 25
	je fim
	mov [pos_y], al
	mov al, 0
	mov [pos_x], al
	jmp loop1
fim:	
	jmp $

linha1:
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
	mov [pos_x], al

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