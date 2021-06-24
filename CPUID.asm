
detectcpuid:
    pushfd
    pop eax

    mov ecx, eax

    xor eax, 1 << 21

    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    xor eax,ecx
    jz nocpuid
    ret

detectlongmode:
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz nolongmode
    ret

nolongmode:
    hlt

nocpuid:
    hlt ; no cpuid support.