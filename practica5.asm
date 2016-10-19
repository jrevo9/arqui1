;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

file db "./hello.txt", 0

len equ 1024

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