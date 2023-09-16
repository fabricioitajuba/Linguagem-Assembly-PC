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
	mov ah, 0eh
loop:	
	mov al, [si]
	cmp al, 0
	je fim
	int 10h
	inc si
	jmp loop
fim:
	jmp $

msg db "Boot carregado com sucesso!", 13, 10, 0

times 510 - ($-$$) db 0
dw 0xAA55