

jmp EPM
jmp $
%include "GDT.asm"
%include "print.asm"

EPM:
    call EA20
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp codeseg:SPM
    jmp $

EA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]

%include "CPUID.asm"
%include "simplepaging.asm"

SPM:

    mov ax, dataseg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov [0xb8000], byte 's'
    mov [0xb8002], byte 'a'
    mov [0xb8004], byte 'l'
    mov [0xb8006], byte 'u'
    mov [0xb8008], byte 't'
    call detectcpuid
    call detectlongmode
    call SUIP
    call editgdt
    jmp codeseg:start64bit

[bits 64]
[extern _start]

start64bit:
    mov edi, 0xb8000
    mov rax, 0x1f201f201f201f20
    mov ecx, 500
    rep stosq
    call _start
    jmp $

times 2048-($-$$) db 0