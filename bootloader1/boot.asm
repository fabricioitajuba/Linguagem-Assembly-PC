;--------------------------------------------------
; Simples bootloader
; para compilar:
; 	nasm boot.asm
; para executar:
; 	qemu-system-i386 boot
;--------------------------------------------------
[bits 16]
[org 0x7c00]

	;Print string
	mov si, msg
	call string_print

	jmp $

;----------------------------------------
; Imprime uma string na tela
; si ponteiro da string
;----------------------------------------
string_print:

	push ax
	push bx
	push si

	mov ah, 0eh	;Write text in teletype mode
	mov bh, 00h	;page number (text modes)
	mov bl, 00h	;foreground pixel color (graphics modes)

string_print_loop:

	lodsb			;carrega al com o conteúdo apontado por si e incrementa si
	test al, al		;verifica se al é zero
	jz string_print_end
	int 10h
	jmp string_print_loop

string_print_end:

	pop si
	pop bx
	pop ax

	ret

msg db "Boot carregado com sucesso!", 13, 10, 0

times 510 - ($-$$) db 0
dw 0xAA55