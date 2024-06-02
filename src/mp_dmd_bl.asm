; Definición de los selectores de segmento de código y datos
.equ CODE_SEG, 0x08
.equ DATA_SEG, 0x10

.code16
    ; Desactivar interrupciones
    cli
    
    ; Cargar la GDT
    lgdt gdt_descriptor
    
    ; Configurar el registro CR0 para activar el modo protegido
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    
    ; Saltar al modo protegido
    jmp CODE_SEG:protected_mode

gdt_start:
    ; Descriptor nulo
    gdt_null:
        .long 0x0
        .long 0x0

    ; Descriptor de código
    gdt_code:
        .word 0xffff                    ; Límite del segmento (16 bits bajos)
        .word 0x0000                    ; Base del segmento (16 bits bajos)
        .byte 0x00                      ; Base del segmento (8 bits medios)
        .byte 0b10011010                ; Flags: Presente, DPL=0, Código, Ejecutable, Leer
        .byte 0b11001111                ; Flags: Granularidad (4 KB), 32-bit, Límite (4 bits altos)
        .byte 0x00                      ; Base del segmento (8 bits altos)

    ; Descriptor de datos (solo lectura)
    gdt_data:
        .word 0xffff                    ; Límite del segmento (16 bits bajos)
        .word 0x0000                    ; Base del segmento (16 bits bajos)
        .byte 0x10                      ; Base del segmento (8 bits medios)
        .byte 0b10010000                ; Flags: Presente, DPL=0, Datos, Solo Lectura
        .byte 0b11001111                ; Flags: Granularidad (4 KB), 32-bit, Límite (4 bits altos)
        .byte 0x00                      ; Base del segmento (8 bits altos)

    gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1       ; Límite de la GDT (tamaño - 1)
    .long gdt_start                     ; Dirección base de la GDT

.code32
protected_mode:
    ; Inicializar los registros de segmento
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; Inicializar el puntero de pila
    mov esp, 0x7000
    
    ; Comprobar si estamos en modo protegido
    mov eax, cr0
    test eax, 0x1
    jnz protected_mode_detected
    jmp not_in_protected_mode

protected_mode_detected:
    ; Llamar a la función para imprimir un mensaje
    call print_message

    ; Intentar escribir en el segmento de datos de solo lectura
    mov dword [0x00100000], 0xDEADBEEF  ; Esto debería causar una excepción

    jmp continue_execution

not_in_protected_mode:
    ; Si no estamos en modo protegido, detener el sistema
    hlt

continue_execution:
    ; Continuar la ejecución del programa (puedes agregar más código aquí)
    hlt

print_message:
    mov ecx, message
    mov eax, 10
    
    ; Calcular la dirección de memoria de la VGA
    mov edx, 160
    mul edx
    lea edx, [eax + 0xb8000]
    mov ah, 0x0f

print_loop:
    mov al, [ecx]
    cmp al, 0
    je print_end
    mov [edx], ax
    add ecx, 1
    add edx, 2
    jmp print_loop

print_end:
    ret

message:
    .asciz "Successfully switched to protected mode."