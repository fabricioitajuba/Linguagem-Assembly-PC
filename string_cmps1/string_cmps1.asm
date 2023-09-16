;---------------------------------------------------
;Compara strings
;---------------------------------------------------

section	.data

s1 db 'Hello, world!',0      ;primeira string
lens1 equ $-s1

s2 db 'Hello, world!!',0      ;segunda string
lens2 equ $-s2

msg_eq db 'As strings são iguais!', 0xa
len_eq  equ $-msg_eq

msg_neq db 'As strings não são iguais!'
len_neq equ $-msg_neq

section	.text
   global _start
	
_start:
   mov esi, s1
   mov edi, s2
   mov ecx, lens2
   cld
   repe  cmpsb
   jecxz  equal

   ;Se não igual
   mov eax, 4
   mov ebx, 1
   mov ecx, msg_neq
   mov edx, len_neq
   int 80h
   jmp exit
	
equal:
   mov eax, 4
   mov ebx, 1
   mov ecx, msg_eq
   mov edx, len_eq
   int 80h
	
exit:
   mov eax, 1
   mov ebx, 0
   int 80h
	