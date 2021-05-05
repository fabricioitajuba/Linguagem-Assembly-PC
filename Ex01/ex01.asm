;------------------------------
;Programa Hello Word
;04/05/2021
;Eng. Fabrício de Lima Ribeiro
;------------------------------

segment .data
  msg db "Hello world!", 0xA, 0xD
  len equ $ - msg

segment .text

global _start

_start:
  mov edx, len
  mov ecx, msg
  mov ebx, 1
  mov eax, 4
  int 0x80

; saída
  mov eax, 1
  mov ebx, 0
  int 0x80

