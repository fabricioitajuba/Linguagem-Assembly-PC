;--------------------------------------------------
; Programa para trabalhar no modo gráfico
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

msg1: db "Isso sera impresso 1", 0
msg2: db "Isso sera impresso 2", 0

start:

	;Configura o vídeo
	mov ah, 00h     
	mov al, 12h	;640x480 16 color graphics (VGA)
	int 10h

	;configura cores
	;mov ah, 0bh
	;mov bh, 00h
	;mov bl, 00h
	;int 10h

	;plota um pixel na coordenada indicada (centro da tela)
	mov ah, 0ch
	mov al, 0fh
	mov bh, 00h
	mov cx, 320 	;column X
	mov dx, 240	;line y
	int 10h

	;posiciona o cursor
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h	;row y
	mov dl, 00h	;column x
	int 10h

	;imprime um caracter
	mov ah, 0eh
	mov al, 'F'
	mov bh, 00h
	mov bl, 0ch	;cor fundo/caracter
	int 10h

	;posiciona o cursor
	mov ah, 02h
	mov bh, 00h
	mov dh, 01	;row y
	mov dl, 06	;column x
	int 10h

	;imprime uma string
	mov si, msg1
	call string_print

	;imprime string no modo gráfico
	mov ah, 13h
	mov al, 00h
	mov bh, 00h
	mov bl, 0fh	;Cor Funco/caracter
	mov cx, 20	;Comprimento da string
	mov dh, 20	;Row Y
	mov dl, 10	;Column x
	xor si, si
	mov es, si
	mov bp, msg2
	int 10h

	jmp $


;---------------------------
; String Print
; si - ponteiro da string
;---------------------------
string_print:

	push ax
	push bx
	push si

	mov ah, 0eh
	mov bh, 00h
	mov bl, 0ch	;cor fundo/caracter

string_print_loop:	

	mov al, [si]
	cmp al, 0
	je string_print_fim
	int 10h
	inc si
	jmp string_print_loop

string_print_fim:

	pop si
	pop bx
	pop ax

	ret

times 510 - ($-$$) db 0
dw 0xAA55