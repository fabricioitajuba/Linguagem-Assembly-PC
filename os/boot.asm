;Este arquivo ficará no setor 1
;em dl fica o dispositivo de inicialização.
;   00h - diskete 1 - para usar o qemu
;   80h - primeiro dispositivo de boot configurado no setup

[BITS 16]
[ORG 7C00h]

	;Initialize Registers
	cli
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, 0x6ef0		;setup the stack like qemu does
	sti
                      
	mov ah, 0		;Reset disk system
	int 13h    		;0x13 ah=0 dl = drive number
	jc errorpart

	;carregando na memória o kernel no setor 2
	mov ah, 02h     	;serviço 2 par ler disco
	mov al, 2       	;quantidade de setor lido
	mov ch, 0       	;trilha 0
	mov cl, 2       	;setor 2
	mov dh, 0       	;cabeçote 0
	mov dl, 80h     	;boot: 00h - disket - qemu | 80h - hd - pendrive
	mov bx, 8000h   	;endereço onde se localiza o kernel
	int 13h

	jmp 8000h 		;salta para o endereço do kernel

errorpart:            		;if stuff went wrong you end here so let's display a message
	mov si, errormsg
	mov bh, 0x00         	;page 0
	mov bl, 0x07          	;text attribute
	mov ah, 0x0E          	;tells BIOS to print char
.part:
	lodsb
	sub al, 0
	jz end
	int 10h
	jmp .part
end:
	jmp $

errormsg db "Falha ao carregar o sistema ...", 0

times 510 - ($-$$) db 0
dw 0xAA55