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
