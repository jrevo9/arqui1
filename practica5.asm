;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

file db "hello.txt", 0
report db "report.res", 0
msg db "Arqui 1 top! Assembler", 0
msg2 db "hello.txt", 0
msg2_size equ $ - msg2

header_txt: db 10,"Universidad de San Carlos de Guatemala"
                db 10,"Facultad Ingenieria"
                db 10,"Arquitectura de Computadores y Ensambladores 1"
                db 10,"Primer Semestre 2016"
                db 10,"Seccion B"
                db 10,"Jorge Alberto Rodriguez Mayorga" 
                db 10,"200915030"
                db 10,"Practica 5"
                db 10,""
                db 10,""
                db 10,"Ingrese Path al archivo:"
                db 10,"",10,0


len equ 100
headerlen equ $ - header_txt
textlen equ $ - msg


section .bss 

buffer: resb 100
lpName:  resb 11  
     
name_len equ    $ - lpName


section .text

global _start

_start:

    ; Imprimir Header
    mov ecx, header_txt 
    mov edx, headerlen  
    call PrintConsole   

    ; Leer input del usuario
    mov ecx, lpName
    mov edx, name_len
    call ReadText

    ;Imprimir el texto ingresado por el usuario
    mov ecx, eax ; Fuente 
    mov edx, 1   ; Tamaño
    call PrintConsole

    ; Abrir el archivo
    mov eax, 5  ; Instruccion para abrir
    mov ebx, lpName ; nombre del archivo
    mov ecx, 0  ; 
    int 80h     

    ; Guardar el contenido en el buffer
    mov eax, 3  
    mov ebx, eax
    mov ecx, buffer
    mov edx, len  
    int 80h     

    ; Imprimir el texto del buffer
    mov ecx, buffer ; Fuente (buffer) 
    mov edx, len   ; Tamaño
    call PrintConsole 


    ; Procesar contenido del buffer

to_list:
    mov ecx, buffer

list_loop:
    cmp byte[ecx], 3bh
    je list_ret

    cmp al, 2ch      
    ;jne list_inc

    mov eax, 4
    mov ebx, 1
    mov edx, 1            
    int 80h  

    inc ecx                 
    jmp list_loop 

list_ret:
    
    ; Crear el archivo reporte
    mov eax, 8
    mov ebx, report
    mov ecx, 0700
    mov edx, len
    int 80h


    ; Escribir en el reporte
    mov eax, 4
    mov ebx, eax
    mov edx, len
    mov ecx, buffer
    int 80h

    ; Cerrar el archivo
    mov eax, 6  
    int 80h     

    ; Instrucciones para cerrar el programa
    mov eax, 1  
    mov ebx, 0 
    int 80h

ReadText:
    mov     ebx, 0 
    mov     eax, 3     
    int     80h 
    ret  

PrintConsole:
    mov eax, 4  ; Instruccion imprimir en consola
    mov ebx, 1  
    int 80h     
    ret

FreeMem:
    mov ebx, 1
    mov eax, 45
    int 80h
    ret