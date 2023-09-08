; Este programa executa operações de soma, subtração, multiplicação e divisão
; Autor: Eng. Fabrício de Lima Ribeiro
; 07/09/2023
; utilizando os registradores em 64bits
; Com as rotinas print_string e int_string melhorada

%include 'biblioteca.inc'

section .data
  msg1  db LF, LF, 'Escolha uma opção:', LF, NULL
  
  msg2  db '1 - Somar', LF, NULL
  msg3  db '2 - Subtrair', LF, NULL
  msg4  db '3 - Multiplicar', LF, NULL
  msg5  db '4 - Dividir', LF, NULL
  msg6  db '5 - Sair', LF, NULL
  msg6a  db '- Opção: ', NULL

  msg7  db LF, '## Somar ##', NULL
  msg8  db LF, '## Subtrair ##', LF, NULL
  msg9  db LF, '## Multiplicar ##', LF, NULL
  msg10  db LF, '## Dividir ##', LF, NULL
  msg11  db LF, '### Fim do Programa ##', LF, NULL

  msg12  db LF, '- Entre com o primeiro número: ', NULL
  msg13  db LF, '- Entre com o segundo número: ', NULL
  msg14  db LF, '- O resultado é: ', NULL
  msg15  db LF, LF, '- Com resto: ', NULL

section .bss
  opc   resb 2      ;Reserva 2 bytes para opção
  val1  resb 7  
  val2  resb 7
  resul resq 1
  resto resq 1      ;Resto da divisão  
  buffer resb 10    ;Buffer utilizado na conversão de int para string

section .text
  global _start 

_start:

inicio:
  ;Plota as mensagens
  mov RSI, msg1     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RSI, msg2     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RSI, msg3     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RSI, msg4     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  mov RSI, msg5     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string  
  mov RSI, msg6     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string  
  mov RSI, msg6a    ;String a ser impressa
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
  mov RSI, msg11    	;String a ser impressa
  call Print_String 	;Chama a rotina de impressão da string

  mov RAX, SYS_EXIT	;Sai do programa
  mov RDI, EXIT_SUCESS	;e retorna ao
  syscall		;sistema operacional

; -----------------------------------
; Rotina para somar
; -----------------------------------
somar:
  mov RSI, msg7           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados      ;Chama a rotina para pegar os valores

  mov RSI, val1		        ;pega o endereço de val1
  call String_Int	        ;converte de string para inteiro
  mov [resul], RAX        ;guarda o resultado em resul

  mov RSI, val2		        ;pega o endereço de val2
  call String_Int	        ;converte de string para inteiro
  add [resul], RAX        ;Faz a soma

  mov RSI, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]        ;Pega o valor inteiro e move para RAX
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call int_to_string      ;Converte de inteiro para string
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call Print_String       ;Converte de inteiro para string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para subrair
; -----------------------------------
subtrair:
  mov RSI, msg8           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov RSI, val1		        ;pega o endereço de val1
  call String_Int	        ;converte de string para inteiro
  mov [resul], RAX        ;Faz a soma        

  mov RSI, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro
  sub [resul], RAX        ;Faz a subtração

  mov RSI, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]        ;Pega o valor inteiro e move para RAX
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call int_to_string      ;Converte de inteiro para string
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call Print_String       ;Converte de inteiro para string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para multiplicar
; -----------------------------------
multiplicar:
  mov RSI, msg9           ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov RSI, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  mov [resul], RAX

  mov RSI, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro
  mov RBX, RAX
  
  mov RAX, [resul]
  mul RBX                 ;Faz a multiplicação
  mov [resul], RAX

  mov RSI, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Imprime o resultado
  mov RAX, [resul]        ;Pega o valor inteiro e move para RAX
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call int_to_string      ;Converte de inteiro para string
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call Print_String       ;Converte de inteiro para string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Rotina para dividir
; -----------------------------------
dividir:
  mov RSI, msg10          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  call Entrada_dados

  mov RSI, val1		  ;pega o endereço de val1
  call String_Int	  ;converte de string para inteiro
  mov [resul], RAX

  mov RSI, val2		  ;pega o endereço de val2
  call String_Int	  ;converte de string para inteiro

  mov RCX, RAX            ;Guarda RAX em RCX (divisor)
  mov RAX, [resul]        ;Guarda result em RAX (dividendo)
  xor RDX, RDX            ;Zera RDX (resto)
  div RCX                 ;Faz a divisão: RAX=RAX/RCX
  mov [resul], RAX        ;Guarda o resultado em result
  mov [resto], RDX        ;Guarda o resto em resto

  ;Imprime o resultado
  mov RSI, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  mov RAX, [resul]        ;Pega o valor inteiro e move para RAX
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call int_to_string      ;Converte de inteiro para string
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call Print_String       ;Converte de inteiro para string

  mov RSI, msg15          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  mov RAX, [resto]        ;Pega o valor inteiro e move para RAX
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call int_to_string      ;Converte de inteiro para string
  mov RSI, buffer         ;Armazena o endereço inicial de buffer
  call Print_String       ;Converte de inteiro para string

  jmp inicio        ;Vai para o início do programa

; -----------------------------------
; Entrada de dados
; -----------------------------------
Entrada_dados:

  mov RSI, msg12     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string
  
  ;Faz a leitura do teclado
  mov RAX, SYS_READ ;Chamada de leitura
  mov RDI, STD_IN   ;Entrada padrão
  mov RSI, val1     ;Guarda a tecla lida em val1
  mov RDX, 10       ;lê até 10 digitos
  syscall

  mov RSI, msg13     ;String a ser impressa
  call Print_String ;Chama a rotina de impressão da string

  ;Faz a leitura do teclado
  mov RAX, SYS_READ ;Chamada de leitura
  mov RDI, STD_IN   ;Entrada padrão
  mov RSI, val2     ;Guarda a tecla lida em val2
  mov RDX, 10       ;lê até 10 digitos
  syscall

  ret