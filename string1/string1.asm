;Plota string em 32bits
section .data
  SYS_WRITE equ 0x4  ; Operacao de escrita
  STD_OUT   equ 0x1  ; Saida padrao
  SYS_EXIT  equ 0x1  ; Codigo de chamada para finalizar
  RET_EXIT  equ 0x0  ; Operacao realizada com Sucesso

  LF      equ 0Ah  ;Line Feed
  CR      equ 0Dh  ;Carriage return
  NULL    equ 00h  ;Caracter nulo

  msg1  db 'Essa é a string!', LF, CR, NULL

section .bss

section .text
  global _start 

_start:
  push EAX
  mov ECX, msg1     ;String a ser impressa
  pop EAX
  call Print_String ;Chama a rotina de impressão da sting

  mov EAX, SYS_EXIT ;Sai do programa
  mov EBX, RET_EXIT ;e retorna ao
  int 80h           ;sistema operacional

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
; Calcular o tamanho da String
; -----------------------------------
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