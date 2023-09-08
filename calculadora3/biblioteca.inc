; -------------------------------------
; Biblioteca para os registradores E
; -------------------------------------
segment .data

  LF            equ 10     ; Line Feed (pula linha e retorna a primeira posição)
  CR            equ 13     ; Carriage return (pula uma linha em branco)
  NULL      	equ 0      ; Caracter nulo

  ;RAX
  SYS_READ      equ 0      ; Código de leitura do teclado
  SYS_WRITE		equ 1	   ; Código de escrita na tela
  SYS_EXIT      equ 60     ; Codigo de chamada para finalizar

  ;RDI
  EXIT_SUCESS   equ 0      ; Operação com Sucesso
  STD_IN        equ 0      ; System.in
  STD_OUT       equ 1      ; System.out

segment .bss
	

segment .text

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
	mov RAX, SYS_WRITE
	mov RDI, STD_OUT
	mov RDX, RBX
	syscall
	ret

;-------------------------------------------
;String para inteiro
;Entrada: Ponteiro da String em RSI
;Saída: RAX - valor inteiro
;-------------------------------------------
String_Int:
    xor rax, rax
.prox_digit:
    mov dl, byte[rsi]
    inc rsi
    cmp dl, '0'
    jl .fim
    cmp dl, '9'
    jg .fim
    sub dl, '0'
    imul rax, 10
    add rax, rdx
    jmp .prox_digit
.fim:
    ret

; -----------------------------------------
; Converte Inteiro para String
; Entrada: RAX (valor inteiro)
; Entrada: Ponteiro do buffer em RSI
; Saída: String convertida em buffer
; -----------------------------------------
int_to_string:
    mov rbx, 10
    xor rcx, rcx
.prox_digito:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    cmp rax, 0
    jnz .prox_digito
.prox_carac:
    pop rdx
    mov byte[rsi], dl
    inc rsi
    dec rcx
    jnz .prox_carac
    mov byte[rsi], 0
    ret