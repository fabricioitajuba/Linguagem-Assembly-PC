;Imprime um byte em hexadecimal
;Autor: Eng. Fabrício de Lima Ribeiro
;08/09/2023
;
;                      xx ->  8 bits - 1 x 8 bits
;                   xx xx -> 16 bits - 2 x 8 bits
;             xx xx xx xx -> 32 bits - 4 x 8 bits
; xx xx xx xx xx xx xx xx -> 64 bits - 8 x 8 bits

section .data
        ;n_bytes equ 1 ;Define o número de bytes a ser convertido 1 byte
        ;n_bytes equ 2 ;Define o número de bytes a ser convertido 2 byte
        n_bytes equ 8 ;Define o número de bytes a ser convertido 8 bytes

section .bss
        buffer resb 9 ;armazena a string convertida

section .text
        global  _start

_start:
        ;mov rax, 0x12
        ;mov rax, 0x1234
        mov rax, 0x0123456789ABCDEF
        mov rcx, n_bytes
        mov rsi, buffer
        call print_hexa

        ;Impressão do valor em hexadecimal
        mov RSI, buffer         ;String a ser impressa
        call Print_String       ;Chama a rotina de impressão da string

        ;Fim do programa
        mov rax, 60
        mov rdi, 0
        syscall

;-------------------------------------------------------------
;Rotina de impressão em hexadecimal
;Entrada: rax o valor em hexadecimal
;         rcx o número de bytes
;         rsi o ponteiro da string
;-------------------------------------------------------------
print_hexa:     
        mov rbx, rax
loop1:
        mov rax, rbx
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle digito1     ;se for menor ou igual, salta para digito1
        add rax, 0x7    ;se não, adiciona 7.
digito1:
        push rax        ;guarda o valor convertido na pilha
        shr rbx, 4      ;rotaciona 4 bits para a direita
        mov rax, rbx
        and rax, 0xF    ;faz um E lógico com F
        add rax, '0'    ;adiciona 0x30
        cmp rax, '9'    ;compara com 9
        jle digito2     ;se for menor ou igual, salta para digito2
        add rax, 0x7    ;se não, adiciona 7.
digito2:
        push rax
        shr rbx, 4      ;rotaciona 4 bits para a direita
        dec rcx
        cmp rcx, 0
        jne loop1
        mov rax, n_bytes
        mov rbx, 2
        mul rbx
        mov rcx, rax
loop2:
        pop rax
        mov [rsi], rax
        inc rsi
        dec rcx
        cmp rcx, 0
        jne loop2
        mov al, 0
        inc rsi
        mov [rsi], al
        ret

; -----------------------------------
; Plota String
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