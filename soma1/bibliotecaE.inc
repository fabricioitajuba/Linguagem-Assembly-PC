; -------------------------------------
; Biblioteca para os registradores E
; -------------------------------------
segment .data
  LF            equ 0xA    ; Line Feed
  NULL          equ 0xD    ; Final da String
  EXIT_SUCESS   equ 0x0    ; Operação com Sucesso
  SYS_EXIT      equ 0x1    ; Codigo de chamada para finalizar

  STD_IN         equ 0x0    ; System.in
  STD_OUT        equ 0x1    ; System.out
  STD_ERR        equ 0x2    ; System.err

  SYS_READ      equ 0x3    ; read
  SYS_WRITE     equ 0x4    ; print

  READ_FILE     equ 0x3    ; ler o arquivo
  WRITE_FILE    equ 0x4    ; escrever no arquivo
  OPEN_FILE     equ 0x5    ; abrir o arquivo
  CLOSE_FILE    equ 0x6    ; fechar o arquivo
  CREATE_FILE   equ 0x8    ; criar o arquivo
  SEEK_FILE     equ 0x13   ; posicionar no arquivo

  SYS_CALL      equ 0x80   ; inteiro final

  OPEN_READ     equ 0x0    ; Arquivo para leitura
  OPEN_WRITE    equ 0x1    ; Arquivo para escrita
  OPEN_RW       equ 0x2    ; Arquivo para leitura/escrita
  OPEN_CREATE   equ 0x40   ; Se arquivo não existe, cria
  OPEN_APPEND   equ 0x400  ; Arquivo para adição

  SEEK_SET      equ 0x0    ; Inicio do Arquivo
  SEEK_CUR      equ 0x1    ; Posição do Cursor
  SEEK_END      equ 0x2    ; Final do Arquivo

segment .bss
  BUFFER: resb 0xA

segment .text

; -----------------------------------------
; Converte String para Inteiro
; Entrada: ESI (valor conv) ECX (tamanho)
; Saida..: EAX com o valor
; -----------------------------------------
string_to_int:
  xor EBX, EBX ;Zera EBX
.prox_digito:
  movzx EAX, byte[ESI] ;mode todos os bytes de ESI para EAX
  inc ESI
  sub AL, '0' ;subtrai 0x30 de AL resultando: apenas o numero
  imul EBX, 10       ; multiplica EBX por 10
  add EBX, EAX       ; EBX = EBX + EAX
  loop .prox_digito  ; while (--ECX)
terminei_S2I:
  mov EAX, EBX
  ret

; -----------------------------------------
; Converte Inteiro para String
; Entrada: EAX (valor conv) ESI (valor buffer)
; Saida..: EAX com o valor
; -----------------------------------------
int_to_string:
  lea ESI, [BUFFER] ;transfere o conteudo de BUFFER para ESI e zera BUFFER
  add ESI, 0x9
  mov byte[ESI], 0x0 ;adiciona 0x30 transformando em ASCII
  mov EBX, 0xA
.prox_digito:
  XOR edx, edx
  div EBX
  add DL, '0'
  dec ESI
  mov [ESI], DL
  test EAX, EAX     ; EAX == 0
  jnz .prox_digito
terminei_I2S:
  mov EAX, ESI
  ret 

; -----------------------------------------
; Achar o tamanho total da String
; Entrada: ECX (valor String)
; Saida..: EDX com o valor
; -----------------------------------------
tamStr:
  mov EDX, ECX
.prox_digito:
  cmp byte[EDX], byte 0
  jz terminei
  inc EDX
  jmp .prox_digito
terminei:
  sub EDX, ECX
  ret    
