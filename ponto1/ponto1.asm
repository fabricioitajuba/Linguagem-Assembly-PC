;programa para mover um ponto na tela
;autor: Eng. Fabrício de Lima Ribeiro
;24/09/2023
;
;fonte
;https://git.sr.ht/~queso_fuego/bootsector_games/tree/master/item/snake_game
;para compilar:
;   nasm ponto.asm
;para executar:
;   qemu-system-i386 ponto

org 7C00h

jmp main

;; CONSTANTS
VIDMEM		equ 0B800h
SCREENW		equ 80
SCREENH		equ 25
BGCOLOR		equ 1020h
POINTCOLOR  equ 4020h
TIMER       equ 046Ch

;; VARIABLES
pos_X:		 dw 40
pos_Y:		 dw 12

main:

    ;set up vídeo mode
    mov ah, 00h     
    mov al, 03h     ;text mode 80x25 characters, 16 color VGA
    int 10h

	;; Hide cursor
	inc ah
	mov ch, 25
	int 10h			; int 10h AH 01h set cursor shape; CH starting, CL ending line (CH > max row = 24)

	;; Set up video memory
	mov ax, VIDMEM
	mov es, ax	; ES:DI <- B800:0000

loop:

    ;clear screen to black every cycle
    mov ax, BGCOLOR
    xor di, di
    mov cx, SCREENW*SCREENH
    rep stosw

	;; Draw point
	imul di, [pos_Y], SCREENW*2
	imul dx, [pos_X], 2
	add di, dx
	mov ax, POINTCOLOR
	stosw

		mov ah, 1
		int 16h					; Get keyboard status
		jz exit_press			; If no key was pressed, move on

		xor ah, ah
		int 16h					; Get keystroke, AH = scancode, AL = ascii char entered
		
		cmp al, 'w'
		je w_pressed
		cmp al, 'x'
		je x_pressed
		cmp al, 'a'
		je a_pressed
		cmp al, 'd'
		je d_pressed
        cmp al, 'r'
        je r_pressed

		jmp exit_press

		w_pressed:
            ;; Move up
			mov ax, [pos_Y]
            dec ax
            cmp ax, 0
            jge tst1
            mov ax, 0
            tst1:
                mov [pos_Y], ax
			jmp exit_press

		x_pressed:
            ;; Move down
			mov ax, [pos_Y]
            inc ax
            cmp ax, 24
            jle tst2
            mov ax, 24
            tst2: 
                mov [pos_Y], ax
			jmp exit_press

		a_pressed:
            ;; Move left
			mov ax, [pos_X]
            dec ax
            cmp ax, 0
            jge tst3
            mov ax, 0
            tst3:            
                mov [pos_X], ax
			jmp exit_press

		d_pressed:
            ;; Move right
			mov ax, [pos_X]
            inc ax
            cmp ax, 79
            jle tst4
            mov ax, 79
            tst4: 
                mov [pos_X], ax
			jmp exit_press

		r_pressed:
            ;; Reset
			int 19h     ; Reload bootsector

	exit_press:
		

    call delay_100ms

    jmp loop
    ;jmp $           ;loop infinito

delay_100ms:
    mov bx, [TIMER]
    inc bx
    inc bx
delay:
    cmp [TIMER], bx
    jl delay
    ret

times 510 - ($-$$) db 0

dw 0AA55h