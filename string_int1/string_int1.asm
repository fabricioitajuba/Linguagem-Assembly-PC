;---------------------------------------------------
;Converte string para inteiro e inteiro para string
;Autor: Eng. Fabrício de Lima Ribeiro
;64 bits
;---------------------------------------------------

section .bss
    digitSpace resb 100
    digitSpacePos resb 8
 
section .data
    text db "123456"		;String
 
section .text
    global _start
 
_start:
    mov RDX, text 		; our string
    call String_Int
    call Int_String
 
    mov RAX, 60
    mov RDI, 0
    syscall

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
    inc RDX 			; ready for next one
    cmp RCX, '0' 		; valid?
    jb .done
    cmp RCX, '9'
    ja .done
    sub RCX, '0' 		; "convert" character to number
    imul RAX, 10 		; multiply "result so far" by ten
    add RAX, RCX 		; add in current digit
    jmp .top 			; until done
.done:
    ret 

;-------------------------------------------
;Inteiro para String
;Entrada: RAX - valor inteiro
;Saída: Tela
;-------------------------------------------
Int_String:
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