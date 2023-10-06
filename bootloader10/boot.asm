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


start:

	;Configura o vídeo
	mov ah, 0   ;Set display mode
	mov al, 12h ;640x480 16 color graphics (VGA)
	int  0x10   ;Video BIOS Services

	;mostra um quadrado
	mov cx, 20	;posição inicial em X
	mov dx, 20	;posição inicial em Y
	mov si, 20h	;comprimento em X
	mov di, 10h	;comprimento em Y
	mov al, 0x0e	;cor do quadrado
	call drawBox

	mov cx, 100	;posição inicial em X
	mov dx, 100	;posição inicial em Y
	mov si, 20	;raio
	mov al, 0x0a	;cor do circulo
	call drawCircle

	jmp $

;----------------------------------------------------------------
;cx = xpos , dx = ypos, si = x-length, di = y-length, al = color
;----------------------------------------------------------------
drawBox:
	push si               ;save x-length
	.for_x:
		push di           ;save y-length
		.for_y:
			pusha
			mov bh, 0     ;page number (0 is default)
			add cx, si    ;cx = x-coordinate
			add dx, di    ;dx = y-coordinate
			mov ah, 0xC   ;write pixel at coordinate
			int 0x10      ;draw pixel!
			popa
		sub di, 1         ;decrease di by one and set flags
		jnz .for_y        ;repeat for y-length times
		pop di            ;restore di to y-length
	sub si, 1             ;decrease si by one and set flags
	jnz .for_x            ;repeat for x-length times
	pop si                ;restore si to x-length  -> starting state restored
	ret
;------------------------------------------------------

;------------------------------------------------------
;cx = xpos , dx = ypos, si = radius, al = color
drawCircle:
	pusha                      ;save all registers
	mov di, si
	add di, si                 ;di = si * 2, di = diameter y-axis
	mov bp, si                 ;bp = copy of radius
	add si, si                 ;si = si * 2, si = diameter x-axis
	.for_x:
		push di                ;save y-length
		.for_y:
			pusha
			add cx, si         ;cx = x-coordinate (start x + si)
			add dx, di         ;dx = y-coordinate (start y + di)
                               ;(x-middle.x)^2 + (y-middle.y)^2 <= radius^2
			                   ;(si-bp)^2 + (di-bp)^2 <= bp^2
			sub si, bp         ;di = y - r
			sub di, bp         ;di = x - r
			imul si, si        ;si = x^2
			imul di, di        ;di = y^2
			add si, di         ;add (x-r)^2 and (y-r)^2
			imul bp, bp        ;signed multiplication, r * r = r^2
			cmp si, bp         ;if r^2 >= distance^2: point is within circle
			jg .skip           ;if greater: point is not within circle
			mov bh, 0          ;page number (0 is default)
			mov ah, 0xC        ;write pixel at coordinate
			int 0x10           ;draw pixel!
			.skip:
			popa
		sub di, 1              ;decrease di by one and set flags
		jnz .for_y             ;repeat for y-length
		pop di                 ;restore di
	sub si, 1                  ;decrease si by one and set flags
	jnz .for_x                 ;repeat for x-length
	popa                       ;restore all registers
	ret
;------------------------------------------------------

times 510 - ($-$$) db 0
dw 0xAA55