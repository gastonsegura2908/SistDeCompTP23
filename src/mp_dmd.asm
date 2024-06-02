section .text
    global _start

_start:
    ; Código ejecutable aquí

section .data
    my_variable db 42   ; Ejemplo de variable en el segmento de datos

section .bss
    ; Variables sin valores iniciales (se rellenan con ceros)
    ; No ocupan espacio en el archivo objectfile

section .text
    ; Más código ejecutable aquí

section .data
    ; Más datos aquí

section .text
    ; Más código aquí

section .data
    ; Más datos aquí

section .text
    ; Final del programa
    mov eax, 1
    int 0x80