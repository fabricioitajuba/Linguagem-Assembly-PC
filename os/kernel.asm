[BITS 16]
[ORG 0000h]

	jmp config

	;mensagens
	CRLF db 10, 13, 0
	msg1 db "Boot e Kernell carregados!", 10, 13, 0
	dsp_cursor db '$ ', 0
        dsp_cmd_invalido db 10, 13, 'Comando invalido! ', 10, 13, 0

        ;comandos
        dsp_clear db 'clear', 0
        tam_dsp_clear equ $- dsp_clear

        dsp_time db 'time', 0
        tam_dsp_time equ $- dsp_time

        dsp_date db 'date', 0
        tam_dsp_date equ $- dsp_date

        dsp_reboot db 'reboot', 0
        tam_dsp_reboot equ $- dsp_reboot

	n_caracteres resb 1	;conta o número de caracteres

	;Buffer
	buffer resb 30    	;Cria um buffer com 30 posições

config:
	;Configura segmento
	mov ax, es          	;recebe de es o valor do segmento
	mov ds, ax          	;configura o data segment

	;Configura o stack
	mov ax, 7D00h   	;configura o stack segment
	mov ss, ax          	;configura o stack pointer
	mov sp, 0xFFFF      	;7D00h:FFFFh
                        
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
    	mov di, buffer
    	call string_read

;--> comando clear
        mov si, dsp_clear
        mov di, buffer
        mov cx, tam_dsp_clear
        cld
        repe cmpsb
        jecxz _cmd_clear

;--> comando time
        mov si, dsp_time
        mov di, buffer
        mov cx, tam_dsp_time
        cld
        repe cmpsb
        jecxz _cmd_time

;--> comando data
        mov si, dsp_date
        mov di, buffer
        mov cx, tam_dsp_date
        cld
        repe cmpsb
        jecxz _cmd_date

;--> comando reboot
        mov si, dsp_reboot
        mov di, buffer
        mov cx, tam_dsp_reboot
        cld
        repe cmpsb
        jecxz _cmd_reboot

;--> comando inválido
        mov si, dsp_cmd_invalido
	call string_print

	jmp inicio

;------------------------------------------------
; Área de jumps
;------------------------------------------------

_cmd_clear:
	jmp cmd_clear

_cmd_time:
	jmp cmd_time

_cmd_date:
	jmp cmd_date

_cmd_reboot:
	jmp cmd_reboot

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
;-------------------------------------------------
; Read string
; buffer = string lida
;------------------------------------------------
string_read:
	mov al, 00h
	mov [n_caracteres], al

string_read_loop:

	mov ah, 00h             ;serviço 0 - leitura de caracter
	int 16h                 ;no teclado e guarda em al

	cmp al, 0dh             ;compara o caracter com ENTER
	je  exit_read_string    ;salta para fim caso seja igual

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

	mov ah, 03h		;Read Cursor Position and Size	
	mov bh, 00h		;Return dh = row | dl = column
	int 10h

	dec dl			;decrementa a atual posição do cursor

	mov ah, 02h		;INT 10,2 - Set Cursor Position
	mov bh, 00h
	int 10h

	mov ah, 0eh		;Limpa a atual posição do cursor
	mov al, ' '
	int 10h

	mov ah, 03h		;Read Cursor Position and Size	
	mov bh, 00h		;Return dh = row | dl = column
	int 10h

	dec dl			;decrementa a atual posição do cursor

	mov ah, 02h		;INT 10,2 - Set Cursor Position
	mov bh, 00h
	int 10h

	dec di
	jmp string_read_loop

exit_read_string:
	inc di
	mov al, 0
	mov [di], al
	ret

;-------------------------------------------------
; comando clear
; limpa a tela
;------------------------------------------------
cmd_clear:

    	mov ah, 00h         ;modo de tela
    	mov al, 03h         ;modo texto 80x25 colorido
    	int 10h

        jmp inicio

;-------------------------------------------------
; comando time
; mostra a hora do sistema
;------------------------------------------------
cmd_time:

	mov si, CRLF
	call string_print

	;Hora do sistema
	mov ah, 02h
	int 1ah

	mov si, buffer

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

	mov si, buffer
	call string_print

	mov si, CRLF
	call string_print

	jmp inicio

;-------------------------------------------------
; comando date
; mostra a data do sistema
;------------------------------------------------
cmd_date:

	mov si, CRLF
	call string_print

	mov si, buffer

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

	mov si, buffer
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
times 1022 - ($-$$) db 0
dw 0xAA55