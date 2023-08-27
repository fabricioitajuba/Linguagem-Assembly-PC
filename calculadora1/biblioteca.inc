; -------------------------------------
; Biblioteca para os registradores E
; -------------------------------------
segment .data
  LF            equ 0Ah    ; Line Feed (pula linha e retorna a primeira posição)
  CR            equ 0Dh    ; Carriage return (pula uma linha em branco)
  NULL      	  equ 00h    ; Caracter nulo
  EXIT_SUCESS   equ 00h    ; Operação com Sucesso
  SYS_EXIT      equ 01h    ; Codigo de chamada para finalizar

  STD_IN        equ 00h    ; System.in
  STD_OUT       equ 01h    ; System.out
  STD_ERR       equ 02h    ; System.err

  SYS_READ      equ 03h    ; read
  SYS_WRITE     equ 04h    ; print

  READ_FILE     equ 03h    ; ler o arquivo
  WRITE_FILE    equ 04h    ; escrever no arquivo
  OPEN_FILE     equ 05h    ; abrir o arquivo
  CLOSE_FILE    equ 06h    ; fechar o arquivo
  CREATE_FILE   equ 08h    ; criar o arquivo
  SEEK_FILE     equ 13h    ; posicionar no arquivo
  
  OPEN_READ     equ 00h    ; Arquivo para leitura
  OPEN_WRITE    equ 01h    ; Arquivo para escrita
  OPEN_RW       equ 02h    ; Arquivo para leitura/escrita
  OPEN_CREATE   equ 40h    ; Se arquivo não existe, cria
  OPEN_APPEND   equ 400h   ; Arquivo para adição

  SEEK_SET      equ 00h    ; Inicio do Arquivo
  SEEK_CUR      equ 01h    ; Posição do Cursor
  SEEK_END      equ 02h    ; Final do Arquivo

segment .bss
  BUFFER: resb 0xA

segment .text

; -----------------------------------
; Plota String
; -----------------------------------
Print_String:
  call Size_String
  mov EAX, SYS_WRITE
  mov EBX, STD_OUT
  int 80h
  ret  

; -----------------------------------
; Calcula o tamanho da String
; Entrada: valor da String em ECX
; Saida: tamanho da String em EDX
; -----------------------------------
Size_String:
 mov EDX, ECX
proxchar:
 cmp byte[EDX], NULL
 jz terminei
 inc EDX
 jmp proxchar
terminei:
 sub EDX, ECX
 ret

 ; -----------------------------------------
; Converte String para Inteiro
; Entrada: ESI (valor conv) ECX (tamanho)
; Saida..: EAX com o valor
; -----------------------------------------
string_to_int:
  xor EBX, EBX          ;Zera EBX
.prox_digito:
  movzx EAX, byte[ESI]  ;mode todos os bytes de ESI para EAX
  inc ESI
  sub AL, '0'           ;subtrai 0x30 de AL resultando: apenas o numero
  imul EBX, 10          ;multiplica EBX por 10
  add EBX, EAX          ;EBX = EBX + EAX
  loop .prox_digito     ;while (--ECX)
terminei_S2I:
  mov EAX, EBX
  ret

; -----------------------------------------
; Converte Inteiro para String
; Entrada: EAX (valor conv) ESI (valor buffer)
; Saida..: EAX com o valor
; -----------------------------------------
int_to_string:
  lea ESI, [BUFFER]     ;transfere o conteudo de BUFFER para ESI e zera BUFFER
  add ESI, 0x9
  mov byte[ESI], 0x0    ;adiciona 0x30 transformando em ASCII
  mov EBX, 0xA
.prox_digito:
  XOR edx, edx
  div EBX
  add DL, '0'
  dec ESI
  mov [ESI], DL
  test EAX, EAX         ;EAX == 0
  jnz .prox_digito
terminei_I2S:
  mov EAX, ESI
  ret 