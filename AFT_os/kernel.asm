[BITS 16]
[ORG 8000h]

jmp config

;Definições
TIMER equ 046Ch

;mensagens
CRLF db 10, 13, 0
version db 10, 13, "AFT_OS - versao 0.1", 10, 13, 0
help db 10, 13, "Comandos: ver, help, clear, time, crono, date, reboot, address", 10, 13, 0
msg1 db "AFT_OS, versao 0.1 - 10/10/2023", 10, 13, 0
dsp_cursor db '>> ', 0
dsp_cmd_invalido db 10, 13, 'Comando invalido! ', 10, 13, 0
tec_exit db 10, 13, 'Pressione qualquer tecla para sair! ', 10, 13, 0
_dsp_address: db 10, 13, "Address: ", 0

;comandos
dsp_ver db 'ver', 0
tam_dsp_ver equ $- dsp_ver

dsp_help db 'help', 0
tam_dsp_help equ $- dsp_help

dsp_clear db 'clear', 0
tam_dsp_clear equ $- dsp_clear

dsp_time db 'time', 0
tam_dsp_time equ $- dsp_time

dsp_crono db 'crono', 0
tam_dsp_crono equ $- dsp_crono

dsp_date db 'date', 0
tam_dsp_date equ $- dsp_date

dsp_reboot db 'reboot', 0
tam_dsp_reboot equ $- dsp_reboot

dsp_address db 'address', 0
tam_dsp_address equ $- dsp_address

n_caracteres resb 1	;conta o número de caracteres

;Buffer
bufferv resb 50    	;Buffer de vídeo
buffert resb 50    	;Buffer do teclado
num: resw 1

config:
                        
	;Configura o vídeo
	mov ah, 00h         	;modo de tela
	mov al, 03h         	;modo texto 80x25 colorido
	int 10h

	mov ah, 05h		;Select Active Display Page
	mov al, 00h		;página 0
	int 10h

	;Boot e Kernell carregados!
	mov si, msg1        
	call string_print


;################################################
; Programa principal
;################################################
inicio:

	;Cursor
    mov si, dsp_cursor
	call string_print

	;lê uma string
    mov di, buffert
    call string_read

;--> comando ver
    mov si, dsp_ver
    mov di, buffert
    mov cx, tam_dsp_ver
    cld
    repe cmpsb
    jecxz _cmd_ver

;--> comando help
    mov si, dsp_help
    mov di, buffert
    mov cx, tam_dsp_help
    cld
    repe cmpsb
    jecxz _cmd_help

;--> comando clear
    mov si, dsp_clear
    mov di, buffert
    mov cx, tam_dsp_clear
    cld
    repe cmpsb
    jecxz _cmd_clear

;--> comando time
    mov si, dsp_time
    mov di, buffert
    mov cx, tam_dsp_time
    cld
    repe cmpsb
    jecxz _cmd_time

;--> comando crono
    mov si, dsp_crono
    mov di, buffert
    mov cx, tam_dsp_crono
    cld
    repe cmpsb
    jecxz _cmd_crono

;--> comando date
    mov si, dsp_date
    mov di, buffert
    mov cx, tam_dsp_date
    cld
    repe cmpsb
    jecxz _cmd_date

;--> comando reboot
    mov si, dsp_reboot
    mov di, buffert
    mov cx, tam_dsp_reboot
    cld
    repe cmpsb
    jecxz _cmd_reboot

;--> comando address
    mov si, dsp_address
    mov di, buffert
    mov cx, tam_dsp_address
    cld
    repe cmpsb
    jecxz _cmd_address

;--> comando inválido
    mov si, dsp_cmd_invalido
	call string_print

	jmp inicio



;#################################################
;Área de jumps
;#################################################

_cmd_ver:
	jmp cmd_ver

_cmd_help:
	jmp cmd_help

_cmd_clear:
	jmp cmd_clear

_cmd_time:
	jmp cmd_time

_cmd_crono:
	jmp cmd_crono

_cmd_date:
	jmp cmd_date

_cmd_reboot:
	jmp cmd_reboot

_cmd_address:
	jmp cmd_address



;#################################################
;Aárea de rotinas do programa
;#################################################

;------------------------------------------------
; Imprime uma string na tela
; si ponteiro da string
;------------------------------------------------
string_print:

	push ax
	push bx
	push si

	mov ah, 0eh
	mov bh, 00h
	mov bl, 00h
	cld

string_print_loop:

	lodsb
	test al, al
	jz string_print_end
	int 10h
	jmp string_print_loop

string_print_end:

	pop si
	pop bx
	pop ax

	ret

;------------------------------------------------
; Delay
; Gera um delay
;------------------------------------------------
delay:

	push bx

	mov bx, [TIMER]
	add bx, 5

delay_loop:
	cmp [TIMER], bx
	jl delay_loop

	pop bx

	ret

;------------------------------------------------
; Carriage return
; Retorna o cursor para a primeira coluna
;------------------------------------------------
carriage_return:

	push ax

	mov ah, 0eh
	mov al, 0dh
	int 10h

	pop ax

	ret

;------------------------------------------------
; Cursor enable
; Habilita o cursor
;------------------------------------------------
cursor_enable:

	push ax
	push cx

	mov ah, 01h
	mov ch, 06h 
	mov cl, 07h
	int 10h

	pop cx
	pop ax

	ret

;------------------------------------------------
; Cursor disable
; Desabilita o cursor
;------------------------------------------------
cursor_disable:

	push ax
	push cx

	;Disable cursor
	mov ah, 01h
	mov ch, 3fh
	int 10h

	pop cx
	pop ax

	ret

;------------------------------------------------
; Read string
; di = Buffer da string
;------------------------------------------------
string_read:

	mov al, 00h
	mov [n_caracteres], al

string_read_loop:

	mov ah, 00h             ;serviço 0 - leitura de caracter
	int 16h                 ;no teclado e guarda em al

	cmp al, 0dh             ;compara o caracter com ENTER
	je  string_read_exit    ;salta para fim caso seja igual

	cmp al, 08h             ;compara o caracter com BACKSPACE
	je  key_backspace       ;salta para fim caso seja igual

	mov ah, 0Eh             ;imprime o caracter
	int 10h                 ;na tela

	mov [di], al            ;guarda o caracter na primeira posição de buffer
	inc di

	mov al, [n_caracteres]
	inc al
	mov [n_caracteres], al

	jmp string_read_loop

key_backspace:

	mov al, [n_caracteres]
	test al, al
	jz string_read	

	mov al, [n_caracteres]
	dec al
	mov [n_caracteres], al

	mov ah, 03h		;Read Cursor Position	
	mov bh, 00h		;Return dh = row | dl = column
	int 10h

	dec dl			;decrementa a atual posição do cursor

	mov ah, 02h		;INT 10,2 - Set Cursor Position
	mov bh, 00h
	int 10h

	mov ah, 0eh		;Limpa a atual posição do cursor
	mov al, ' '
	int 10h

	mov ah, 03h		;Read Cursor Position	
	mov bh, 00h		;Return dh = row | dl = column
	int 10h

	dec dl			;decrementa a atual posição do cursor

	mov ah, 02h		;INT 10,2 - Set Cursor Position
	mov bh, 00h
	int 10h

	dec di

	;mov al, 00h
	;mov [si], al

	jmp string_read_loop

string_read_exit:
	
	inc di
	mov al, 0
	mov [di], al

	ret

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
	mov [di], ax

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
	mov ax, [di]
	mul bx
	mov [di], ax
	pop ax
	or [di], al
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

;#################################################
;Aárea de comandos
;#################################################

;------------------------------------------------
; comando ver
; mostra a versão do sistema operacional
;------------------------------------------------
cmd_ver:

	mov si, version 
	call string_print

	jmp inicio

;------------------------------------------------
; comando help
; mostra todos os comandos
;------------------------------------------------
cmd_help:

	mov si, help 
	call string_print

	jmp inicio

;------------------------------------------------
; comando clear
; limpa a tela
;------------------------------------------------
cmd_clear:

	push ax

    mov ah, 00h         ;modo de tela
    mov al, 03h         ;modo texto 80x25 colorido
    int 10h

	pop ax

	jmp inicio

;------------------------------------------------
; comando time
; mostra a hora do sistema
;------------------------------------------------
cmd_time:

	mov si, CRLF
	call string_print

	;Hora do sistema
	mov ah, 02h
	int 1ah

	mov si, bufferv

	;hora
	mov al, ch
	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, ':'
	mov [si], al
	inc si   

	;plota minutos
	mov al, cl

	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, ':'
	mov [si], al
	inc si 

	;plota segundos
	mov al, dh

	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov si, bufferv
	call string_print

	mov si, CRLF
	call string_print

	jmp inicio


;------------------------------------------------
; comando crono
; mostra a hora do sistema atualizada
;------------------------------------------------
cmd_crono:

	call cursor_disable

	mov si, tec_exit
	call string_print

cmd_crono_loop:

	;Verifica se uma tecla foi pressionada
	mov ah, 01h
	int 16h
	jnz cmd_crono_fim

	;Hora do sistema
	mov ah, 02h
	int 1ah

	mov si, bufferv

	;hora
	mov al, ch
	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, ':'
	mov [si], al
	inc si   

	;plota minutos
	mov al, cl

	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, ':'
	mov [si], al
	inc si 

	;plota segundos
	mov al, dh

	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov si, bufferv
	call string_print

	call carriage_return
	call delay

	jmp cmd_crono_loop

cmd_crono_fim:

	mov si, CRLF
	call string_print

	call cursor_enable

	jmp inicio

;-------------------------------------------------
; comando date
; mostra a data do sistema
;------------------------------------------------
cmd_date:

	mov si, CRLF
	call string_print

	mov si, bufferv

	mov ah, 04h
	int 1ah

	;plota dia
	mov al, dl
	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, '/'
	mov [si], al
	inc si

	;plota mês
	mov al, dh
	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov al, '/'
	mov [si], al
	inc si

	;plota ano
	mov al, cl
	push ax
	shr al, 4
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	pop ax
	and al, 0fh
	add al, '0'
	mov [si], al
	inc si

	mov si, bufferv
	call string_print

	mov si, CRLF
	call string_print

	jmp inicio

;-------------------------------------------------
; comando reboot
; reinicia o sistema
;------------------------------------------------
cmd_reboot:
	int 19h

;-------------------------------------------------
; comando address
; verifica uma possição de memória
;------------------------------------------------
cmd_address:

	;mov si, _dsp_address
	;call string_print

	mov si, CRLF
	call string_print

	;lê o endereço 2 bytes
    mov di, buffert
    call string_read

	;espaço
	mov ah, 0eh
	mov al, ':'
	int 10h

	;converte a string em hexa
	mov si, buffert
	mov di, num
	call string_hexa

	;carrega o dado no endereço
	mov bx, [num]
	mov al, [bx]

	;converte o dado para string
	mov dx, 1
	mov si, bufferv
	call hexa_string

	;mostra o dado
	mov si, bufferv
	call string_print

	mov si, CRLF
	call string_print

	jmp inicio

;-------------------------------------------------
times 2046 - ($-$$) db 0
dw 0xAA55