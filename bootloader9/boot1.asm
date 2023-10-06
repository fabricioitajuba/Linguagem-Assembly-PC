;--------------------------------------------------
; Programa para trabalhar no modo gráfico
; Imprime uma string no modo gráfico
; Autor: Eng. Fabrício de Lima Ribeiro
; 06/10/2023
;
; para compilar:
; 	nasm boot.asm
; para executar:
; 	qemu-system-i386 boot
; ou:
;	make
;--------------------------------------------------

[bits 16]
[org 0x7c00]

jmp start

msg: db "Essa e a string impressa!", 0

start:
	;Configura o vídeo
	mov ah, 00h     ;Set Video Mode
	mov al, 12h	;640x480 16 color graphics (VGA)
	int 10h

	;cor de fundo
	mov ah, 0bh	;Set Color Palette
	mov bh, 00h	;palette color ID
	mov bl, 09h	;color value	01h-blue, 02-green, 04-red
	int 10h

	;imprime uma string
	mov si, msg	;Ponteiro da string
	mov bl, 0x0f	;Branco
	mov dh, 20	;Posição Y
	mov dl, 10	;Posição X
	call string_print

	jmp $

;------------------------------------------
; Imprime string no modo gráfico
; si - ponteiro da string
; bl - Cor do caracter (nibble lsb)
; dh - Row Y
; dl - Column X
;------------------------------------------
string_print:

	call string_count

	mov ah, 13h	;Write String
	mov al, 00h	;Write mode
	mov bh, 00h	;Vídeo page
	;mov cx, 20	;Comprimento da string
	mov bp, si	;transfere si para bp
	xor si, si	;clear si
	mov es, si
	int 10h	

	ret

;------------------------------------------
; Conta o número de caracteres de uma string
; si - ponteiro da string
; cx - retorna a quantidade de caracteres
;------------------------------------------
string_count:

	push ax
	push bx

	mov bx, si
	xor cx, cx

string_count_loop:

	mov al, [bx]
	test al, al
	jz string_count_end	
	inc bx	
	inc cx
	jmp string_count_loop

string_count_end:

	pop bx
	pop ax

	ret

times 510 - ($-$$) db 0
dw 0xAA55