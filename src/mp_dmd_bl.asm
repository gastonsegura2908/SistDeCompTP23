section .text
    global _start

_start:
    ; Deshabilitar interrupciones
    cli

    ; Configurar la GDT (Tabla de Descriptores Globales)
    mov eax, gdt_end - gdt_start - 1
    shl eax, 16
    mov ax, gdt_start
    lgdt [eax]

    ; Cambiar al modo protegido
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:modo_protegido

modo_protegido:
    ; Configurar el descriptor de código
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Configurar el descriptor de datos como solo lectura
    mov ax, 0x18
    mov ss, ax

    ; Intentar escribir en una dirección de memoria dentro del segmento de datos
    mov dword [0x1000], 0xDEADBEEF  ; Esto generará una excepción GPF

    ; Salir del programa
    hlt

section .data
gdt_start:
    ; Descriptor de código (base = 0, límite = 4 GB, acceso = 0x9A)
    dw 0xFFFF  ; Límite (16 bits más bajos)
    dw 0x0000  ; Base (16 bits más bajos)
    db 0x00    ; Base (8 bits siguientes)
    db 0x9A    ; Tipo de descriptor (código ejecutable, acceso presente, nivel de privilegio 0)
    db 0xCF    ; Límite (4 bits más altos) y atributos (granularidad, tamaño de operando)

    ; Descriptor de datos (base = 0, límite = 4 GB, acceso = 0x92, solo lectura)
    dw 0xFFFF  ; Límite (16 bits más bajos)
    dw 0x0000  ; Base (16 bits más bajos)
    db 0x00    ; Base (8 bits siguientes)
    db 0x92    ; Tipo de descriptor (datos, acceso presente, nivel de privilegio 0)
    db 0xCF    ; Límite (4 bits más altos) y atributos (granularidad, tamaño de operando)

gdt_end: