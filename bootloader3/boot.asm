;--------------------------------------------------
; Simples bootloader
; para compilar:
; 	nasm boot.asm
; para executar:
; 	qemu-system-i386 boot
;--------------------------------------------------
[bits 16]
[org 0x7c00]

	;Write string
	mov ah, 13h
	mov al, 01h	;write mode
	mov bh, 00h	;video page number
	mov bl, 1bh	;ABh - A - BGCOLOR/ B - FONTCOLOR
	mov cx, 30	;length of string (ignoring attributes)
	mov dh, 09h	;row
	mov dl, 00h	;column
	mov bp, msg	;ES:BP = pointer to string
	int 10h

	;Set cursor position
	mov ah, 02h
	mov bh, 00h	;page number (0 for graphics modes)
	mov dh, 0ah	;row
	mov dl, 00h	;column
	int 10h

	;Write Character and Attribute at Cursor Position
	mov ah, 0eh
	mov al, 'x'	;ASCII character to write
	mov bh, 00h	;display page
	mov bl, 0fh	;character attribute (text) foreground color (graphics)
	int 10h

	;Set cursor position
	mov ah, 02h
	mov bh, 00h	;page number (0 for graphics modes)
	mov dh, 0bh	;row
	mov dl, 00h	;column
	int 10h

	;Write character at current cursor
	mov ah, 0ah
	mov al, '-'	;ASCII character to write
	mov bh, 00h	;display page
	mov bl, 00h	;foreground color
	mov cx, 05h	;count of characters to write (CX >= 1)
	int 10h

	;Set cursor position
	mov ah, 02h
	mov bh, 00h	;page number (0 for graphics modes)
	mov dh, 0bh	;row
	mov dl, 00h	;column
	int 10h

	;Write Character and Attribute at Cursor Position
	mov ah, 09h
	mov al, '+'	;ASCII character to write
	mov bh, 00h	;display page
	mov bl, 21h	;ABh - A - BGCOLOR/ B - FONTCOLOR
	mov cx, 05h	;count of characters to write (CX >= 1)
	int 10h

	;Set cursor position
	mov ah, 02h
	mov bh, 00h	;page number (0 for graphics modes)
	mov dh, 0bh	;row
	mov dl, 06h	;column
	int 10h

	jmp $

msg db "Boot carregado com sucesso!", 13, 10, 0

times 510 - ($-$$) db 0
dw 0xAA55