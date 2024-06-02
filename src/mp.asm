section .text
    global _start

_start:
    ; Cargar el descriptor de segmento de código
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Habilitar el bit PE (modo protegido) en el registro CR0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Saltar al código en modo protegido
    jmp 0x08:protected_mode

protected_mode:
    ; Tu código en modo protegido aquí

    ; Salir del programa
    mov eax, 1
    int 0x80