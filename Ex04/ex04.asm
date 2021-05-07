;-----------------------------
;Comparação
;Eng. Fabrício de Lima Ribeiro
;06/05/2021
;----------------------------- 

section .data

  x dd 10 ;dd - define double word - 4 bytes
          ;db - define byte - 1 byte
          ;dw - define word - 2 bytes
          ;dq - define quad word - 4 bytes
          ;dt - define then word - 10 bytes
  y dd 50
  msg1 db "X maior que Y", 0xA
  len1 equ $ - msg1
  msg2 db "Y maior que X", 0xA
  len2 equ $ - msg2

section .text

global _start

_start:
  mov eax, DWORD [x]
  mov ebx, DWORD [y]
  cmp eax, ebx ;comparação
  jge maior    ;je = jg > jge >= jl < jle <= jne !=
  mov edx, len2
  mov ecx, msg2
  jmp final

maior:
  mov edx, len1
  mov ecx, msg1

final:
  mov ebx, 1
  mov eax, 4
  int 0x80
  mov eax, 1
  int 0x80
