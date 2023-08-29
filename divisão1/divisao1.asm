;Este programa executa operações de soma, subtração, multiplicação e divisão
;27/08/2023

%include 'biblioteca.inc'

section .data
  msg14  db '### O resultado é: ', LF, CR, NULL
  msg15  db LF, '### Com resto: ', LF, CR, NULL
  nl  db LF, NULL

section .bss

  AnInt1 resq 1
  AnInt2 resq 1

section .text
  global _start 

_start:

  mov EAX, 45		  ;Guarda em EAX (dividendo)
  mov ECX, 10             ;Guarda em ECX (divisor)
  mov EDX, 0              ;Zera EDX (resto)
  div ECX                 ;Faz a divisão: EAX=EAX/ECX
  mov [AnInt1], EAX       ;Guarda o resultado em result
  mov [AnInt2], EDX       ;Guarda o resto em resto

  ;Imprime o resultado
  mov ECX, msg14          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov EAX, [AnInt1]
  call int_to_string
  mov ECX, EAX
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h

  mov ECX, msg15          ;String a ser impressa
  call Print_String       ;Chama a rotina de impressão da string
  mov EAX, [AnInt2]
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
