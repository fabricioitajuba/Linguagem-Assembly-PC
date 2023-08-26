; ---------------------------------------
; Este programa possui um menu de opções
; Autor: Eng. Fabrício de Lima Ribeiro
; Data: 26/08/2023
; ---------------------------------------

section .data
  SYS_WRITE equ 0x4  ; Operacao de escrita
  SYS_READ  equ 0x3  ; Operacao de leitura
  STD_IN    equ 0x0  ; Entrada padrao
  STD_OUT   equ 0x1  ; Saida padrao
  SYS_EXIT  equ 0x1  ; Codigo de chamada para finalizar
  RET_EXIT  equ 0x0  ; Operacao realizada com Sucesso

  LF        equ 0Ah  ;Line Feed
  CR        equ 0Dh  ;Carriage return
  NULL      equ 00h  ;Caracter nulo

  msg1  db LF, CR, 'Escolha uma opção:', LF, CR, NULL
  
  msg2  db '1 - Vai para opção 1', LF, CR, NULL
  msg3  db '2 - Vai para opção 2', LF, CR, NULL
  msg4  db '3 - Vai para opção 3', LF, CR, NULL
  msg5  db '4 - Sair do programa', LF, CR, NULL
  
  msg6  db 'Opção 1', LF, CR, NULL
  msg7  db 'Opção 2', LF, CR, NULL
  msg8  db 'Opção 3', LF, CR, NULL
  msg9  db '### Fim do Programa ##', LF, CR, NULL

section .bss
  opc resb 2        ;Reserva 2 bytes

section .text
  global _start 

_start:

inicio:
  ;Plota as mensagens
  mov ECX, msg1     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov ECX, msg2     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov ECX, msg3     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov ECX, msg4     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov ECX, msg5     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string  

  ;Faz a leitura do teclado
  mov EAX, SYS_READ ;Chamada de leitura
  mov EBX, STD_IN   ;Entrada padrão
  mov ECX, opc      ;Guarda a tecla lida em opc
  mov EDX, 02h      ;lê 2 teclas (a tecla escolhida + Enter)
  int 80h

  mov ah, [opc]     ;Guarda o conteúdo de opc em ah
  sub ah, '0'       ;Subtrai 0x30 da string transformando em int

  cmp ah, 1         ;Compara o resultado com 1
  je Plota_msg6     ;caso seja igual, salta para Plota_msg6
  cmp ah, 2         ;Compara o resultado com 2
  je Plota_msg7     ;caso seja igual, salta para Plota_msg7
  cmp ah, 3         ;Compara o resultado com 3
  je Plota_msg8     ;caso seja igual, salta para Plota_msg8
  cmp ah, 4         ;Compara o resultado com 4
  je sair           ;caso seja igual, salta para sair
  jmp inicio        ;Retorna ao início caso seja uma tecla errada

sair:
  ;Fim do programa
  mov ECX, msg9     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string

  mov EAX, SYS_EXIT ;Sai do programa
  mov EBX, RET_EXIT ;e retorna ao
  int 80h           ;sistema operacional

; -----------------------------------
; Plota msg6
; -----------------------------------
Plota_msg6:
  mov ECX, msg6     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  ;jmp sair         ;Sai do programa
  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Plota msg7
; -----------------------------------
Plota_msg7:
  mov ECX, msg7     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  ;jmp sair         ;Sai do programa
  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Plota msg8
; -----------------------------------
Plota_msg8:
  mov ECX, msg8     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  ;jmp sair         ;Sai do programa
  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Plota String
; -----------------------------------
Print_String:
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h
  ret  

; -----------------------------------
; Calcula o tamanho da String
; Entrada: valor da String em ECX
; Saida: tamanho da String em EDX
; -----------------------------------
Size_String:
 mov EDX, ECX
proxchar:
 cmp byte[EDX], NULL
 jz terminei
 inc EDX
 jmp proxchar
terminei:
 sub EDX, ECX
 ret 