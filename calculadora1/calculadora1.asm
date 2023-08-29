;Este programa executa operações de soma, subtração, multiplicação e divisão
;27/08/2023

%include 'biblioteca.inc'

section .data
  msg1  db LF, CR, 'Escolha uma opção:', LF, CR, NULL
  
  msg2  db '1 - Somar', LF, CR, NULL
  msg3  db '2 - Subtrair', LF, CR, NULL
  msg4  db '3 - Multiplicar', LF, CR, NULL
  msg5  db '4 - Dividir', LF, CR, NULL
  msg6  db '5 - Sair', LF, CR, NULL

  msg7  db '## Somar', LF, CR, NULL
  msg8  db '## Subtrair', LF, CR, NULL
  msg9  db '## Multiplicar', LF, CR, NULL
  msg10  db '## Dividir', LF, CR, NULL
  msg11  db '### Fim do Programa ##', LF, CR, NULL

  msg12  db '### Entre com o primeiro número: ', LF, CR, NULL
  msg13  db '### Entre com o segundo número: ', LF, CR, NULL
  msg14  db '### O resultado é: ', LF, CR, NULL
  msg15  db LF, '### Com resto: ', LF, CR, NULL

section .bss
  opc   resb 2  ;Reserva 2 bytes para opção
  val1  resw 1  
  val2  resw 1
  resul resq 1
  resto resq 1  ;Resto da divisão  

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
  mov ECX, msg6     ;String a ser impressa
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
  je somar          ;caso seja igual, salta para Plota_msg7
  cmp ah, 2         ;Compara o resultado com 2
  je subtrair       ;caso seja igual, salta para Plota_msg8
  cmp ah, 3         ;Compara o resultado com 3
  je multiplicar    ;caso seja igual, salta para Plota_msg9
  cmp ah, 4         ;Compara o resultado com 4
  je dividir        ;caso seja igual, salta para Plota_msg10  
  cmp ah, 5         ;Compara o resultado com 5
  je sair           ;caso seja igual, salta para sair

  jmp inicio        ;Retorna ao início caso seja uma tecla errada

sair:
  ;Fim do programa
  mov ECX, msg11    ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string

  mov EAX, SYS_EXIT     ;Sai do programa
  mov EBX, EXIT_SUCESS  ;e retorna ao
  int 80h               ;sistema operacional

; -----------------------------------
; Rotina para somar
; -----------------------------------
somar:
  mov ECX, msg7           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  lea ESI, [val1]         ;pega o endereço de val1
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  add [resul], EAX        ;Faz a soma

  lea ESI, [val2]         ;pega o endereço de val2
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  add [resul], EAX        

  mov ECX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov EAX, [resul]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para subrair
; -----------------------------------
subtrair:
  mov ECX, msg8           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  lea ESI, [val1]         ;pega o endereço de val1
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  add [resul], EAX        

  lea ESI, [val2]         ;pega o endereço de val2
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  sub [resul], EAX        ;Faz a subtração

  mov ECX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov EAX, [resul]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para multiplicar
; -----------------------------------
multiplicar:
  mov ECX, msg9           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  lea ESI, [val1]         ;pega o endereço de val1
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro

  mov [resul], EAX        

  lea ESI, [val2]         ;pega o endereço de val2
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro

  mov EBX, [resul]
  mul EBX                 ;Faz a multiplicação
  mov [resul], EAX

  mov ECX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov EAX, [resul]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para dividir
; -----------------------------------
dividir:
  mov ECX, msg10          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  lea ESI, [val1]         ;pega o endereço de val1
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro

  mov [resul], EAX        

  lea ESI, [val2]         ;pega o endereço de val2
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro

  mov ECX, EAX            ;Guarda EAX em ECX (divisor)
  mov EAX, [resul]        ;Guarda result em EAX (dividendo)
  xor EDX, EDX            ;Zera EDX (resto)
  div ECX                 ;Faz a divisão: EAX=EAX/ECX
  mov [resul], EAX        ;Guarda o resultado em result
  mov [resto], EDX        ;Guarda o resto em resto

  ;Imprime o resultado
  mov ECX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov EAX, [resul]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  mov ECX, msg15          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov EAX, [resto]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Entrada de dados
; -----------------------------------
Entrada_dados:

  mov ECX, msg12     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  
  ;Faz a leitura do teclado
  mov EAX, SYS_READ ;Chamada de leitura
  mov EBX, STD_IN   ;Entrada padrão
  mov ECX, val1     ;Guarda a tecla lida em val1
  mov EDX, 03h      ;lê 2 teclas (a tecla escolhida + Enter)
  int 80h

  mov ECX, msg13     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string

  ;Faz a leitura do teclado
  mov EAX, SYS_READ ;Chamada de leitura
  mov EBX, STD_IN   ;Entrada padrão
  mov ECX, val2     ;Guarda a tecla lida em val2
  mov EDX, 03h      ;lê 2 teclas (a tecla escolhida + Enter)
  int 80h

  ret