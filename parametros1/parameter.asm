; Name:     get_argv.asm
; Assemble: nasm -f elf32 get_argv.asm
; Link:     ld -m elf_i386 -o get_argv get_argv.o
; Run:      ./get_argv arg1 arg2 arg3

SECTION  .data
    LineFeed    dw  10
    nullstr     db '(null)',0
    argcstr     db 'argc = '
    argcstr1    db '---------------',0
    argvstr     db 'argv['
    argvstr1    db '---------------',0
    argvstr2    db '] = ',0

SECTION .text
global  _start
_start:

    push    ebp
    mov     ebp, esp

    mov eax, [ebp + 4]          ; argc
    mov edi, argcstr1
    call EAX_to_DEC             ; Convert EAX to a string pointed by EDI

    mov esi, argcstr
    call PrintString
    mov esi, LineFeed
    call PrintString

    xor ecx, ecx

    .J1:
    mov eax, ecx
    mov edi, argvstr1
    call EAX_to_DEC             ; Convert EAX to a string pointed by EDI

    mov esi, argvstr
    call PrintString
    mov esi, argvstr2
    call PrintString
    mov esi, [ebp+8+4*ecx]      ; argv[ECX]
    call PrintString
    test esi, esi
    jz .J2
    mov esi, LineFeed
    call PrintString
    add ecx, 1
    jmp .J1
    .J2:

    .exit:
    mov esi, LineFeed
    call PrintString

    mov     esp, ebp
    pop     ebp

    mov     eax, 1              ; SYS_EXIT
    xor     ebx, ebx            ; Exit code = 0 = no error
    int     0x80                ; Call Linux

PrintString:                    ; ARG: ESI Pointer to ASCIZ string
    pusha
    test esi, esi
    jne .J0
    mov esi, nullstr
    .J0:
    mov eax, 4                  ; SYS_WRITE
    mov ebx, 1                  ; STDOUT
    mov ecx, esi
    xor edx, edx                ; Count of bytes to send
    .J1:
    cmp byte [esi], 0           ; Look for the terminating null
    je .J2
    add edx, 1
    add esi, 1
    jmp .J1
    .J2:
    int 0x80                    ; Call Linux
    popa
    ret

EAX_to_DEC:                     ; ARG: EAX integer, EDI pointer to string buffer
    push ebx
    push ecx
    push edx

    mov ebx, 10                 ; Divisor = 10
    xor ecx, ecx                ; ECX=0 (digit counter)
    .J1:                        ; First Loop: store the remainders
    xor edx, edx                ; Don't forget it!
    div ebx                     ; EDX:EAX / EBX = EAX remainder EDX
    push dx                     ; Push the digit in DL (LIFO)
    add cl, 1                   ; = inc cl (digit counter)
    or eax, eax                 ; AX == 0?
    jnz .J1                     ; No: once more
    mov ebx, ecx                ; Store count of digits
    .J2:                        ; Second loop: load the remainders in reversed order
    pop ax                      ; get back pushed digits
    or al, 00110000b            ; to ASCII
    mov [edi], al               ; Store AL to [EDI] (EDI is a pointer to a buffer)
    add edi, 1                  ; = inc edi
    loop .J2                    ; until there are no digits left
    mov byte [edi], 0           ; ASCIIZ terminator (0)
    mov eax, ebx                ; Restore Count of digits

    pop edx
    pop ecx
    pop ebx
    ret                         ; RET: EAX length of string (w/o last null)