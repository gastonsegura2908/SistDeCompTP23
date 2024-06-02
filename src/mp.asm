section .text
global _start

_start:
; Deshabilitar las interrupciones
cli

; Configurar la GDT (Tabla de Descriptores Globales)
mov eax, gdt_end - gdt_start - 1
shl eax, 16
mov ax, gdt_start
lgdt [eax]

; Cambiar al Modo Protegido
mov eax, cr0
or eax, 0x1
mov cr0, eax
jmp 0x08:modo_protegido

modo_protegido:
; Configurar otros segmentos y tablas de paginación

; Código en modo protegido continúa desde aca

; Salir del programa
hlt

section .data
gdt_start:
; Descriptores de segmento (código, datos, etc.)

gdt_end: