[org 0x7C00]
[bits 16]
VIDEOBUFFER EQU 0xA000

section .text
    ; segments
    mov ax, 0x00
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
	mov bp, sp

    ; video mode 200*320*256
    mov ax, 13h
    int 10h

    ; variables
    
    yCord: dw 0x00
    xCord: dw 0x00

    appleX: dw 0x60
    appleY: dw 0x60

    dir: dw 0x01
    key: dw 0x00

    mov bx, [appleX]
    mov ax, [appleY]
    mov cl, 4
    call draw_pixel

a:
    ; half a second delay
    ; (500milion microseconds)
    mov     CX, 03h
    mov     DX, 4240h
    mov     AH, 86h
    int     15h

    mov dx, [dir]
    cmp dx, 1
    je one
    cmp dx, 2
    je two
    cmp dx, 3
    je three
zero:
    mov ax, [yCord]
    dec ax
    mov [yCord], ax
    jmp end
one:
    mov ax, [yCord]
    inc ax
    mov [yCord], ax
    jmp end
two:
    mov ax, [xCord]
    dec ax
    mov [xCord], ax
    jmp end
three:
    mov ax, [xCord]
    inc ax
    mov [xCord], ax
    jmp end
end:
    mov ax, [yCord]
    mov bx, [xCord]
    call check_dead

    mov ax, [yCord]
    mov bx, [xCord]
    mov cl, 15
    call draw_pixel

    mov al, 0
    mov ah, 1
    int 16h

    mov [key], al
    jnz change_direction
    jmp a
change_direction:
    ; delete the keystoke
    mov al, 0
    mov ah, 0
    int 16h

    mov al, [key]

    cmp al, 'w'
    je is_w
    cmp al, 's'
    je is_s
    cmp al, 'a'
    je is_a
    cmp al, 'd'
    je is_d
    jmp a
is_w:
    mov ax, 0
    mov [dir], ax
    jmp a
is_s:
    mov ax, 1
    mov [dir], ax
    jmp a
is_a:
    mov ax, 2
    mov [dir], ax
    jmp a
is_d:
    mov ax, 3
    mov [dir], ax
    jmp a
    jmp $
get_key:
    mov ah, 1
    int 16h
    ret
check_dead: ; AX - Y, BX - X
    imul ax, 320
    add ax, bx
    mov di, ax
    mov ax, 0xA000
    mov es, ax
    mov cl, byte[es:di]
    cmp cl, 0
    jne dead
    ret
draw_pixel: ; AX - Y, BX - X
    imul ax, 320
    add ax, bx
    mov di, ax
    mov ax, 0xA000
    mov es, ax
    mov byte[es:di], cl
    ret
dead: ; CL - C
    mov ax, 0xA000
    mov es, ax
    cmp cl, 4
    je won
    jmp lose
won:
    mov cl, 2
    mov di, 0
    mov dx, 64000
    jmp loop1
lose:
    mov cl, 4
    mov di, 0
    mov dx, 64000
    jmp loop1
loop1:
    mov byte[es:di], cl
    inc di
    cmp dx, di
    jne loop1
    cli
    hlt
    times 510-($-$$) db 0
	dw 0xAA55
