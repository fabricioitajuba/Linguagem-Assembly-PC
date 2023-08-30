; -------------------------------------
; Biblioteca para os registradores E
; -------------------------------------
segment .data

  LF            equ 10     ; Line Feed (pula linha e retorna a primeira posição)
  CR            equ 13     ; Carriage return (pula uma linha em branco)
  NULL      	equ 0      ; Caracter nulo

  ;RAX
  SYS_READ      equ 0      ; Código de leitura do teclado
  SYS_WRITE	equ 1	   ; Código de escrita na tela
  SYS_EXIT      equ 60     ; Codigo de chamada para finalizar

  ;RDI
  EXIT_SUCESS   equ 0      ; Operação com Sucesso
  STD_IN        equ 0      ; System.in
  STD_OUT       equ 1      ; System.out

segment .bss
	digitSpace 	resb 100
	digitSpacePos 	resb 8

segment .text

; -----------------------------------
; Plota String
; RAX - ponteiro da string
; -----------------------------------
Print_String:
	push RAX
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
	pop RSI
	mov RDX, RBX
	syscall
	ret

;-------------------------------------------
;String para inteiro
;Entrada: Ponteiro da String em RDX
;Saída: RAX - string convertida para inteiro
;-------------------------------------------
String_Int:
atoi:
	xor RAX, RAX 		; zero a "result so far"
.top:
	movzx RCX, byte [RDX] 	; get a character
	inc RDX 		; ready for next one
	cmp RCX, '0' 		; valid?
	jb .done
	cmp RCX, '9'
	ja .done
	sub RCX, '0' 		; "convert" character to number
	imul RAX, 10 		; multiply "result so far" by ten
	add RAX, RCX 		; add in current digit
	jmp .top 		; until done
.done:
    ret 

; -----------------------------------------
; Converte Inteiro para String
; Entrada: RAX (valor inteiro)
; -----------------------------------------
int_to_string:
	mov RCX, digitSpace
	mov RBX, 10
	mov [RCX], RBX
	inc RCX
	mov [digitSpacePos], RCX

_printRAXLoop:
	mov RDX, 0
	mov RBX, 10
	div RBX
	push RAX
	add RDX, 48

	mov RCX, [digitSpacePos]
	mov [RCX], DL
	inc RCX
	mov [digitSpacePos], RCX
	
	pop RAX
	cmp RAX, 0
	jne _printRAXLoop

_printRAXLoop2:
	mov RCX, [digitSpacePos]

	mov RAX, 1
	mov RDI, 1
	mov RSI, RCX
	mov RDX, 1
	syscall

	mov RCX, [digitSpacePos]
	dec RCX
	mov [digitSpacePos], RCX

	cmp RCX, digitSpace
	jge _printRAXLoop2

	ret