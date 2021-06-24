
[org 0x7c00]

    ; note(pitust): you may not need it here tbh
    mov [BOOT_DISK], dl

    mov ah, 0x42
    mov si, boot_dap
    int 0x13
    jc diskreadFailed

    mov bp, 0x7c00
    mov sp, bp

    jmp 0x7e00


%include "print.asm"

BOOT_DISK:
    db 0

diskreadErrorString:
    db "disk read failed",0

diskreadFailed:
    mov bx, diskreadErrorString
    call PrintString
    
    jmp $

boot_dap:
    db 0x10 ; dap size
    db 0x00 ; unused
    dw (bin_end - bin_start + 511) / 512 ; number of sectors
    dw 0x7e00 ; offset of destination
    dw 0x0000 ; segment of destination
    dq 1 ; start from second sector
times 510-($-$$) db 0


dw 0xaa55
bin_start:
incbin "kernel.bin"
bin_end: