;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

file db "./hello.txt", 0
report db "./report.txt", 0
msg db "Arqui 1 top! Assembler", 0

len equ 1024

textlen equ $ - msg

section .bss 

buffer: resb 1024


section .text

global _start

_start:
    
    ; Abrir el archivo
    mov ebx, file ; nombre del archivo
    mov eax, 5  ; Instruccion para abrir
    mov ecx, 0  ; 
    int 80h     

    ; Guardare el contenido en el buffer
    mov eax, 3  
    mov ebx, eax
    mov ecx, buffer 
    mov edx, len    
    int 80h     

    ; Crear el archivo reporte
    mov eax, 8
    mov ebx, report
    mov ecx, 0700
    mov edx, len
    int 80h

    ; Escribir en el reporte
    mov ebx, eax
    mov eax, 4
    mov ecx, msg
    mov edx, textlen
    int 80h
    mov eax, 6
    int 80h

    ; Imprimir el texto del buffer
    mov eax, 4  ; Instruccion imprimir en consola
    mov ebx, 1  ; 
    mov ecx, buffer ; Fuente (buffer) 
    mov edx, len    ; Tamaño
    int 80h     

    ; Cerrar el archivo
    mov eax, 6  
    int 80h     

    ; Instrucciones para cerrar el programa
    mov eax, 1  
    mov ebx, 0 
    int 80h