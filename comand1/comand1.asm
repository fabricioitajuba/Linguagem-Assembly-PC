;-------------------------------------------------------
; Programa para interpretar comandos em assembly
; Autor: Eng. Fabrício de Lima Ribeiro
; 16/09/2023
;-------------------------------------------------------
section .data
        ;mensagens
        dsp_cursor db '$ ', 0
        dsp_cmd_msg1 db 'Mensagem 1', 10, 0
        dsp_cmd_invalido db 'Comando inválido! ', 10, 0
        dsp_cmd_sair db 'Sair do programa! ', 10, 0

        ;comandos
        dsp_msg1 db 'msg1', 0
        tam_dsp_msg1 equ $- dsp_msg1

        dsp_sair db 'exit', 0
        tam_dsp_sair equ $- dsp_sair

segment .bss
        buffer resb 8   ;comando de no máximo 8 caracteres

section .text
        global  _start

_start:

loop1:
        ;programa principal
        mov rsi, dsp_cursor
        call Print_String

        call le_comando

        ;mostra mensagem 1
        mov rsi, dsp_msg1
        mov rdi, buffer
        mov rcx, tam_dsp_msg1
        cld
        repe cmpsb
        jecxz cmd_msg1

        ;comando sair
        mov rsi, dsp_sair
        mov rdi, buffer
        mov rcx, tam_dsp_sair
        cld
        repe cmpsb
        jecxz cmd_sair
        
        ;comando inválido
        mov rsi, dsp_cmd_invalido 
        call Print_String

        jmp loop1

; --------------------------------------
;Faz a leitura de uma string no teclado 
; --------------------------------------  
le_comando:
        mov RAX, 0              ;Chamada de leitura
        mov RDI, 0              ;Entrada padrão
        mov RSI, buffer         ;Guarda o caracter lido em buffer
        mov RDX, 8              ;lê até 1 byte
        syscall
        ret

; -----------------------------------
; Print String
; Entrada: Ponteiro da string em RSI
; -----------------------------------
Print_String:
	mov RAX, RSI
	mov RBX, 0
_printLoop:
	inc RAX
	inc RBX
	mov CL, [RAX]
	cmp CL, 0
	jne _printLoop

	;Imprime a string
	mov RAX, 1
	mov RDI, 1
	mov RDX, RBX
	syscall
	ret

; -----------------------------------
;comandos
; -----------------------------------

;mostra uma mensagem
cmd_msg1:
        mov RSI, dsp_cmd_msg1 
        call Print_String
        jmp loop1

;sai do programa
cmd_sair:
        mov RSI, dsp_cmd_sair 
        call Print_String

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall