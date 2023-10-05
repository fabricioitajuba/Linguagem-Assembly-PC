;--------------------------------------------------
; Conversão de String-Hexa e Hexa-String
; Autor: Eng. Fabrício de Lima Ribeiro
; 05/10/2023
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

string	db "4A5B", 0

num: resw 1
buffer: resb 5

start:

	;Clear disp
	mov ah, 00h     
	mov al, 03h
	int 10h

	mov si, string		;ponteiro da string hexa
	mov di, num		;Ponteiro do número a ser convertido
	call string_hexa

	mov ax, [num]

	mov dx, 2
	mov si, buffer
	call hexa_string

	mov si, buffer
	call string_print

	jmp $


;-------------------------------------------------------------
;Rotina de conversão de string para hexadecimal
; si - ponteiro da string hexa
; di - ponteiro do número a ser convertido
;-------------------------------------------------------------
string_hexa:

	push ax
	push bx
	push cx
	push dx
	push si
	push di

	xor ax, ax
	mov [num], ax

string_hexa_p2:

	mov al, [si]
	cmp al, 0
	je string_hexa_fim

	sub al, '0'
	cmp al, 09h
	jle string_hexa_p1
	sub al, 07h

string_hexa_p1:

	push ax
	mov bx, 10h
	mov ax, [num]
	mul bx
	mov [num], ax
	pop ax
	or [num], al
	inc si
	jmp string_hexa_p2		

string_hexa_fim:

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret


;-------------------------------------------------------------
;Rotina de conversão de hexadecimal para string
;Entrada: ax o valor em hexadecimal
;         dx o número de bytes
;         si o ponteiro da string
;-------------------------------------------------------------
hexa_string:  
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

;---------------------------
; String Print
; si - ponteiro da string
;---------------------------
string_print:

	push ax
	push si
	mov ah, 0eh
loop:	
	mov al, [si]
	cmp al, 0
	je fim1
	int 10h
	inc si
	jmp loop
fim1:
	pop si
	pop ax

	ret


times 510 - ($-$$) db 0
dw 0xAA55