;--------------------------------------------------
; Verificar informações do disco
; Autor: Eng. Fabrício de Lima Ribeiro
; 02/10/2023
;
; para compilar:
; 	nasm boot2.asm
; para executar:
; 	qemu-system-i386 boot2
; ou:
;	make
;--------------------------------------------------

[bits 16]
[org 0x7c00]

jmp startup

n_bytes equ 1
buffer_disk equ 9000h

drive_number: 	db 0
buffer:		times 10 db 0

nome:	db "Fabricio", 0

startup:
	mov [drive_number], dl

	;Clear disp
	mov ah, 00h     
	mov al, 03h
	int 10h
	
	;Copy string
	mov si, nome
	mov di, buffer_disk
Lx:
	mov al, [si]
	mov [di], al
	inc si
	inc di
	cmp byte[si], 0
	jne Lx

	;write disk
	;copia 512 bytes da memória 9000h para o setor 3 do disco
	mov al, 01h	;number of sectors to read	(1-128 dec.)
	mov cl, 03h	;sector (01h=boot, 02h=first avail)
	xor bx, bx
	mov es, bx
	mov bx, buffer_disk	;es:bx ->0000h:9000h
	call disk_write		

	;read disk
	;copia 512 bytes do setor 3 do disco para memória a partir do endereço 9000h
	mov al, 01h	;number of sectors to read	(1-128 dec.)
	mov cl, 03h	;sector (01h=boot, 02h=first avail)
	xor bx, bx
	mov es, bx
	mov bx, buffer_disk	;es:bx ->0000h:9000h
	call disk_read

	;Imprime o setor do disco

	;Imprime o endereço
	mov bx, buffer_disk
print_word:
	;pula linha
        mov si, line
        call print_string

	;imprime endereço
	mov ax, bx
	mov dx, 02h
        mov si, buffer
        call convert_hexa
        mov si, buffer
        call print_string

	;dois pontos e espaço
        mov si, space
        call print_string
	
	;zera di
	mov di, 0

print_byte:
	;Imprime o dado
	mov ax, [bx + di]
	mov dx, 01h
        mov si, buffer
        call convert_hexa
        mov si, buffer
        call print_string

	;Espaço
	mov ah, 0x0e
	mov al, ' '
	int 10h

	inc di
	cmp di, 16
	jne print_byte

	add bx, 10h
	cmp bx, 9100h	;9100h -> meio setor
	jne print_word

	jmp $


;---------------------------
; Disk write
; al = number of sectors to read
; dl = drive number
; ex:bx = memory location to copy into
;---------------------------
disk_write:
	mov ah, 03h	;disk read	
	mov ch, 00h	;cylinder
	;dl = drive number (may be set by qemu)
	;00h=floppy, 01h=floopy2, 80h=hdd, 81h=bdd2
	mov dl, [drive_number]
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
; Disk Read
; al = number of sectors to read
; dl = drive number
; ex:bx = memory location to copy into
;---------------------------
disk_read:
	mov ah, 02h	;disk read	
	mov ch, 00h	;cylinder
	;dl = drive number (may be set by qemu)
	;00h=floppy, 01h=floopy2, 80h=hdd, 81h=bdd2
	mov dl, [drive_number]
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

;-------------------------------------------------------------
;Rotina de conversão para hexadecimal
;Entrada: ax o valor em hexadecimal
;         dx o número de bytes
;         si o ponteiro da string
;-------------------------------------------------------------
convert_hexa:  
	push ax   
        push bx
        push cx
	push si

        mov bx, ax
        mov cx, dx
loop1:
        mov ax, bx
        and ax, 0xF    ;faz um E lógico com F
        add ax, '0'    ;adiciona 0x30
        cmp ax, '9'    ;compara com 9
        jle digito1     ;se for menor ou igual, salta para digito1
        add ax, 0x7    ;se não, adiciona 7.
digito1:
        push ax        ;guarda o valor convertido na pilha
        shr bx, 4      ;rotaciona 4 bits para a direita
        mov ax, bx
        and ax, 0xF    ;faz um E lógico com F
        add ax, '0'    ;adiciona 0x30
        cmp ax, '9'    ;compara com 9
        jle digito2     ;se for menor ou igual, salta para digito2
        add ax, 0x7    ;se não, adiciona 7.
digito2:
        push ax
        shr bx, 4      ;rotaciona 4 bits para a direita
        dec cx
        cmp cx, 0
        jne loop1
        mov cx, dx
        shl cx, 1      ;multiplica o número de bytes por 2
loop2:
        pop ax
        mov [si], ax
        inc si
        dec cx
        cmp cx, 0
        jne loop2
        mov al, 0
        inc si
        mov [si], al

	pop si
        pop cx
        pop bx
	pop ax
        ret

space:	db ": ", 0
line:	db 10, 13, 0
MSG_DISK_ERROR:	db "Error reading disk. ", 0
MSG_SECTOR_ERROR: db "Error: wrong number of sectors. ", 0

times 510 - ($-$$) db 0
dw 0xAA55

times 504 db 0		;sector2

times 512 db 'A'	;sector3