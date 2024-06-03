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
    ; Cambiar los bits de acceso del segmento de datos a solo lectura
    ; Esto se hace modificando el descriptor de segmento correspondiente en la GDT
    ; Por simplicidad, asumiremos que el descriptor de datos está en el índice 0x18 en la GDT

    ; Cargar el selector de segmento de datos
    mov ax, 0x18
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Intentar escribir en el segmento de datos (esto generará una excepción)
    mov dword [my_variable], 42

    ; Código en modo protegido

    ; Salir del programa
    mov eax, 1
    int 0x80

section .data
    my_variable db 0   ; Variable en el segmento de datos (inicializada a 0)