;-------------------------------------------------
; Comparação entre programa feito em C e Assembly
; Eng. Fabrício de Lima Ribeiro
; 05/05/2021
;-------------------------------------------------

section .text

global _start

_start:
  mov eax, 1 ;metodo exit
  mov ebx, 2 ;variavel que sera retornada
  int 0x80

