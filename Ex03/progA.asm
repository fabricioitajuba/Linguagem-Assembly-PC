section .text

global _start

_start:
  mov eax, 1 ;metodo exit
  mov ebx, 2 ;variavel que sera retornada
  int 0x80

