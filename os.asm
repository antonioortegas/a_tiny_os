; All x86 processors start in Real Mode for compatibility reasons, a 16bit mode.
; In Real Mode you use a logical address in the form A:B to address memory. This is translated into a physical address using the equation:
; Physical Address = 16 * A + B (or 0x10 * A + B in hex)
bits 16

; Registers are therefore limited to 16 bit representation, or 64k. Each of this 64k blocks is called a segment.
; The processor has a data segment (DS) register
mov ax, 0x7C0
mov ds, ax

push msg
call print

; do not accept interrupts and halt when done
cli
hlt

msg:
    db "A_tiny_OS", 0

print:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]  ; grab the pointer to the data
    mov bh, 0x00    ; page number 0
    mov ah, 0x0E    ; print character
.char:
    mov al, [si]    ; get the current char from our pointer position
    add si, 1       ; keep incrementing si until we see a null char
    or al, 0
    je .return      ; end if the string is done
    int 0x10        ; else print the char
    jmp .char
.return:
    popa
    mov sp, bp
    pop bp
    ret

; padding to make the file 512 bytes (bootsector size)
times 510-($-$$) db 0
dw 0xAA55