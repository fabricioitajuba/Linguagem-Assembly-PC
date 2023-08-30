; Este programa executa operações de soma, subtração, multiplicação e divisão
; Autor: Eng. Fabrício de Lima Ribeiro
; 30/08/2023
; utilizando os registradores em 64bits

%include 'biblioteca.inc'

section .data
  msg1  db LF, CR, 'Escolha uma opção:', LF, CR, NULL
  
  msg2  db '1 - Somar', LF, NULL
  msg3  db '2 - Subtrair', LF, NULL
  msg4  db '3 - Multiplicar', LF, NULL
  msg5  db '4 - Dividir', LF, NULL
  msg6  db '5 - Sair', LF, NULL

  msg7  db '## Somar', LF, NULL
  msg8  db '## Subtrair', LF, NULL
  msg9  db '## Multiplicar', LF, NULL
  msg10  db '## Dividir', LF, NULL
  msg11  db '### Fim do Programa ##', LF, NULL

  msg12  db '### Entre com o primeiro número: ', LF, NULL
  msg13  db '### Entre com o segundo número: ', LF, NULL
  msg14  db '### O resultado é: ', LF, NULL
  msg15  db '### Com resto: ', LF, NULL

section .bss
  opc   resb 2  ;Reserva 2 bytes para opção
  val1  resb 7  
  val2  resb 7
  resul resq 1
  resto resq 1  ;Resto da divisão  

section .text
  global _start 

_start:

inicio:
  ;Plota as mensagens
  mov RAX, msg1     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RAX, msg2     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RAX, msg3     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RAX, msg4     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RAX, msg5     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string  
  mov RAX, msg6     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string  

  ;Faz a leitura do teclado
  mov RAX, SYS_READ ;Chamada de leitura
  mov RDI, STD_IN   ;Entrada padrão
  mov RSI, opc      ;Guarda a tecla lida em opc
  mov RDX, 02h      ;lê 2 teclas (a tecla escolhida + Enter)
  syscall

  mov AL, [opc]     ;Guarda o conteúdo de opc em AL
  sub AL, '0'       ;Subtrai 0x30 da string transformando em int

  cmp AL, 1         ;Compara o resultado com 1
  je somar          ;caso seja igual, salta para Plota_msg7
  cmp AL, 2         ;Compara o resultado com 2
  je subtrair       ;caso seja igual, salta para Plota_msg8
  cmp AL, 3         ;Compara o resultado com 3
  je multiplicar    ;caso seja igual, salta para Plota_msg9
  cmp AL, 4         ;Compara o resultado com 4
  je dividir        ;caso seja igual, salta para Plota_msg10  
  cmp AL, 5         ;Compara o resultado com 5
  je sair           ;caso seja igual, salta para sair

  jmp inicio        ;Retorna ao início caso seja uma tecla errada

sair:
  ;Fim do programa
  mov RAX, msg11    	;String a ser impressa
  call Print_String 	;Chama a rotina de impressão da string

  mov RAX, SYS_EXIT	;Sai do programa
  mov RDI, EXIT_SUCESS	;e retorna ao
  syscall		;sistema operacional

; -----------------------------------
; Rotina para somar
; -----------------------------------
somar:
  mov RAX, msg7           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  mov RDX, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  add [resul], RAX        ;Faz a soma

  mov RDX, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro
  add [resul], RAX        ;Faz a soma

  mov RAX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]
  call int_to_string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para subrair
; -----------------------------------
subtrair:
  mov RAX, msg8           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  mov RDX, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  add [resul], RAX        ;Faz a soma        

  mov RDX, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro
  sub [resul], RAX        ;Faz a subtração

  mov RAX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]
  call int_to_string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para multiplicar
; -----------------------------------
multiplicar:
  mov RAX, msg9           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  mov RDX, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  mov [resul], RAX

  mov RDX, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro
  mov RBX, RAX
  
  mov RAX, [resul]
  mul RBX                 ;Faz a multiplicação
  mov [resul], RAX

  mov RAX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]
  call int_to_string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para dividir
; -----------------------------------
dividir:
  mov RAX, msg10          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov DWORD[resul], 0000h

  mov RDX, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  mov [resul], RAX

  mov RDX, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro

  mov RCX, RAX            ;Guarda RAX em RCX (divisor)
  mov RAX, [resul]        ;Guarda result em RAX (dividendo)
  xor RDX, RDX            ;Zera RDX (resto)
  div RCX                 ;Faz a divisão: RAX=RAX/RCX
  mov [resul], RAX        ;Guarda o resultado em result
  mov [resto], RDX        ;Guarda o resto em resto

  ;Imprime o resultado
  mov RAX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov RAX, [resul]
  call int_to_string

  mov RAX, msg15          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov RAX, [resto]
  call int_to_string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Entrada de dados
; -----------------------------------
Entrada_dados:

  mov RAX, msg12     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  
  ;Faz a leitura do teclado
  mov RAX, SYS_READ ;Chamada de leitura
  mov RDI, STD_IN   ;Entrada padrão
  mov RSI, val1     ;Guarda a tecla lida em val1
  mov RDX, 10       ;lê até 10 digitos
  syscall

  mov RAX, msg13     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string

  ;Faz a leitura do teclado
  mov RAX, SYS_READ ;Chamada de leitura
  mov RDI, STD_IN   ;Entrada padrão
  mov RSI, val2     ;Guarda a tecla lida em val2
  mov RDX, 10       ;lê até 10 digitos
  syscall

  ret