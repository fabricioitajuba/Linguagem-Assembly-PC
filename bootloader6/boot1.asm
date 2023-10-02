;--------------------------------------------------
; Verificar informações do disco
; Autor: Eng. Fabrício de Lima Ribeiro
; 02/10/2023
;
; para compilar:
; 	nasm boot1.asm
; para executar:
; 	qemu-system-i386 boot1
; ou:
;	make
;--------------------------------------------------

[bits 16]
[org 0x7c00]

jmp startup
drive_number: db 0

startup:
	mov [drive_number], dl
	
	mov al, 01h	;sector
	xor bx, bx
	mov es, bx
	mov bx, 9000h
	call disk_read

	mov si, STR1
	call print_string

	;print out the character at location read from disk
	mov ah, 0eh
	mov al, [9000h]
	int 10h

	jmp $

;---------------------------
; Disk Read
; al = number of sectors to read
; dl = drive number
; ex:bx = memory location to copy into
;---------------------------
disk_read:
	mov ah, 02h	;disk read
	mov cl, 02h	;sector (01h=boot, 02h=first avail)
	mov ch, 00h	;cylinder
	;dl = drive number (may be set by qemu)
	;00h=floppy, 01h=floopy2, 80h=hdd, 81h=bdd2
	mov dh, 00h	;head number
	
	int 13h		;call disk read
	jc .sector_error

	cmp al, 01h
	jne .sector_error
	ret

.disk_error:
	mov si, MSG_DISK_ERROR
	call print_string
	jmp $

.sector_error:
	mov si, MSG_SECTOR_ERROR
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

STR1:	db "Reading from 9000h: ", 0
MSG_DISK_ERROR:	db "Error reading disk. ", 0
MSG_SECTOR_ERROR: db "Error: wrong number of sectors. ", 0

times 510 - ($-$$) db 0
dw 0xAA55

times 512 db 'f'