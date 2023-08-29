;Este programa executa operações de soma, subtração, multiplicação e divisão
;27/08/2023

%include 'biblioteca.inc'

section .data
  msg14  db '### O resultado é: ', LF, CR, NULL
  msg15  db LF, '### Com resto: ', LF, CR, NULL
  nl  db LF, NULL

section .bss
  opc   resb 2  ;Reserva 2 bytes para opção
  val1s resb 2  
  val2s resb 2
  val1i resq 1  
  val2i resq 1
  resul resq 1
  resto resq 1  ;Resto da divisão  

section .text
  global _start 

_start:

  mov dword[val1s], '45'   ;Acrecenta xx (string) na posição val1
  mov dword[val2s], '10'   ;Acrecenta xx (string) na posição val2

  ;Executa os calculos
  ;mov DWORD[resul], 00h

  lea ESI, [val1s]         ;pega o endereço de val1
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  mov [val1i], EAX        

  lea ESI, [val2s]         ;pega o endereço de val2
  mov ECX, 0x2            ;números de caracteres da string
  call string_to_int      ;converte de string para inteiro
  mov [val2i], EAX

  mov EAX, [val1i]        ;Guarda result em EAX (dividendo)
  ;mov EAX, 45
  mov ECX, [val2i]        ;Guarda EAX em ECX (divisor)
  ;mov ECX, 10
  mov EDX, 0              ;Zera EDX (resto)
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

  mov ECX, nl             ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string

  ;Fim do programa
  mov EAX, SYS_EXIT     ;Sai do programa
  mov EBX, EXIT_SUCESS  ;e retorna ao
  int 80h               ;sistema operacional
