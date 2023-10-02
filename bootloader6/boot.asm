;--------------------------------------------------
; Verificar informações do disco
; Autor: Eng. Fabrício de Lima Ribeiro
; 02/10/2023
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

jmp	config

;Variáveis
buffer 		times 10 db 0
drive_number: 	db 0
status 		db 0
drive_type	db 0
cylinders	db 0
sectors		db 0
num_sides	db 0
num_drives	db 0

;Constantes

config:

	;Configura segmento
	xor ax, ax
	mov es, ax
	mov ds, ax

    	;Configura o stack
    	mov ax, 7D00h   
    	mov ss, ax          	;configura o stack segment
    	mov sp, 03FEh       	;configura o stack pointer
                        	;7D00h:03FEh
	;Save drive number
	mov [drive_number], dl

	;set up vídeo mode
	mov ah, 00h     
	mov al, 03h     	;text mode 80x25 characters, 16 color VGA
	int 10h

	;Diskette BIOS Services
	mov ah, 08h		;Get Current Drive Parameters
	mov dl, 80h		;(0=A:, 1=2nd floppy, 80h=drive 0, 81h=drive 1)
	int 13h

	mov [status], ah
	mov [drive_type], bl
	mov [cylinders], ch
	mov [sectors], cl
	mov [num_sides], dh
	mov [num_drives], dl

	mov si, msg
	call print_string
	
	;drive number
	mov si, msg7
	call print_string
	xor ax, ax
	mov al, [drive_number]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string
	
	;status
	mov si, msg0
	call print_string
	xor ax, ax
	mov al, [status]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string
	mov si, buffer
	call print_string

	;CMOS drive type
	mov si, msg5
	call print_string
	xor ax, ax
	mov al, [drive_type]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string

	;cylinders
	mov si, msg6
	call print_string
	xor ax, ax
	mov al, [cylinders]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string

	;sectors per track
	mov si, msg8
	call print_string
	xor ax, ax
	mov al, [sectors]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string

	;number of sides
	mov si, msg9
	call print_string
	xor ax, ax
	mov al, [num_sides]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string

	;number of drives
	mov si, msg10
	call print_string
	xor ax, ax
	mov al, [num_drives]
	mov si, buffer
	call int_to_string
	mov si, buffer
	call print_string

	jmp $

;---------------------------
; Print string
; si - ponteiro da string
;---------------------------
print_string:
	push ax
	mov ah, 0eh
loop:	
	mov al, [si]
	cmp al, 0
	je fim1
	int 10h
	inc si
	jmp loop
fim1:
	pop ax
	ret

; -----------------------------------------
; Converte Inteiro para String
; Entrada: AX (valor inteiro)
; Entrada: Ponteiro do buffer em SI
; Saída: String convertida em buffer
; -----------------------------------------
int_to_string:

	mov bx, 10
	xor cx, cx
.prox_digito:
	xor dx, dx
	div bx
	add dl, '0'
	push dx
	inc cx
	cmp ax, 0
	jnz .prox_digito
.prox_carac:
	pop dx
	mov byte[si], dl
	inc si
	dec cx
	jnz .prox_carac
	mov byte[si], 0

	ret

msg db "## Informacoes do disco:", 13, 10, 0
msg0 db 13, 10, "Status: ", 0
msg5 db 13, 10, "Drive type: ", 0
msg6 db 13, 10, "Cylinders: ", 0
msg7 db 13, 10, "Drive number: ", 0
msg8 db 13, 10, "Sectors per track: ", 0
msg9 db 13, 10, "Number of sides: ", 0
msg10 db 13, 10, "Number of drives: ", 0

times 510 - ($-$$) db 0
dw 0xAA55