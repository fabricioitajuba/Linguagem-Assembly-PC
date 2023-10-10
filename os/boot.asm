;Este arquivo ficará no setor 1
;em dl fica o dispositivo de inicialização.
;   00h - diskete 1 - para usar o qemu
;   80h - primeiro dispositivo de boot configurado no setup

[BITS 16]
[ORG 7C00h]

    ;carregando na memória o kernel no setor 2
    mov ah, 02h     ;serviço 2 par ler disco
    mov al, 2       ;quantidade de setor lido
    mov ch, 0       ;trilha 0
    mov cl, 2       ;setor 2
    mov dh, 0       ;cabeçote 0
    mov dl, 00h     ;boot: 00h - disket - qemu | 80h - hd - pendrive
    mov bx, 0800h   ;endereço onde se localiza o kernel
    mov es, bx      ;ES:BX = 0800h:0000h - segmento:offset
    mov bx, 0000h
    int 13h

    jmp 0800h:0000h ;salta para o endereço do kernel

times 510 - ($-$$) db 0
dw 0xAA55