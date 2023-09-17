[BITS 16]
[ORG 0000h]

    jmp config

    msg1 db "Boot e Kernell carregados!", 10, 13, 0
    msg2 db "Digite seu nome: ", 0
    msg3 db "Seja bem vindo ", 0
    linha db " ", 10, 13, 0

    buffer times 20 db 0    ;Cria um buffer com 2 posições inicializado com 0

config:

    ;Configura segmento
    mov ax, es          ;recebe de es o valor do segmento
    mov ds, ax          ;configura o data segment

    ;Configura o stack
    mov ax, 7D00h   
    mov ss, ax          ;configura o stack segment
    mov sp, 03FEh       ;configura o stack pointer
                        ;7D00h:03FEh

    ;Limpa a tela
    mov ah, 00h         ;modo de tela
    mov al, 03h         ;modo texto 80x25 colorido
    int 10h

    ;Mostra a hora e data atual
    call plota_hora_data

	mov si, msg1        ;imprime mensagem 1
    call print_string

	mov si, msg2        ;imprime mensagem 2
    call print_string

    mov di, buffer      ;le uma
    call read_string    ;string

	mov si, linha       ;pula linha
    call print_string

	mov si, msg3        ;imprime mensagem 3
    call print_string

	mov si, buffer      ;imprime buffer
    call print_string

	jmp $               ;Fim do programa

;---------------------------
;Print string
;si = ponteiro da string
;---------------------------
print_string:
	mov ah, 0eh
loop:	
    mov al, [si]
	cmp al, 0
	je fim
	int 10h
	inc si
	jmp loop
fim:
    ret

;---------------------------
;Read string
;buffer = string lida
;---------------------------
read_string:
    mov ah, 00h             ;serviço 0 - leitura de caracter
    int 16h                 ;no teclado e guarda em al
    cmp al, 0dh             ;compara o caracter com ENTER
    je  exit_read_string    ;salta para fim caso seja igual
    mov ah, 0Eh             ;imprime o caracter
    int 10h                 ;na tela
    mov [di], al            ;guarda o caracter na primeira posição de buffer
    inc di
    jmp read_string
exit_read_string:
    inc di
    mov al, 0
    mov [di], al
    ret

;---------------------------
;Plota a hora e data do sistema
;---------------------------
plota_hora_data:

    ;Hora do sistema
    mov ah, 02h
    int 1ah

    ;plota hora
    sub ch, 03h ;ajusta a hora para o Brasil -3h
    mov al, ch

    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    mov ah, 0eh
    mov al, ':'
    int 10h    

    ;plota minutos
    mov al, cl

    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    mov ah, 0eh
    mov al, ':'
    int 10h  

    ;plota segundos
    mov al, dh

    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    mov ah, 0eh
    mov al, '-'
    int 10h  

    ;Data do sistema
    mov ah, 04h
    int 1ah

    ;plota dia
    mov al, dl
    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    mov ah, 0eh
    mov al, '/'
    int 10h

    ;plota mês
    mov al, dh
    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    mov ah, 0eh
    mov al, '/'
    int 10h

    ;plota ano
    mov al, cl
    push ax
    shr al, 4
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    pop ax
    and al, 0fh
    add al, '0'
    mov ah, 0eh
    int 10h

    ;pula linha
    mov ah, 0eh
    mov al, 0ah
    int 10h    

    ;retorna o cursor na primeira posição
    mov ah, 0eh
    mov al, 0dh
    int 10h    

    ret