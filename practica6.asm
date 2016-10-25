;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

calc_header db "Modo Calculadora activado", 0


header_txt: db 10,"Universidad de San Carlos de Guatemala"
                db 10,"Facultad Ingenieria"
                db 10,"Arquitectura de Computadores y Ensambladores 1"
                db 10,"Primer Semestre 2016"
                db 10,"Seccion B"
                db 10,"Jorge Alberto Rodriguez Mayorga" 
                db 10,"200915030"
                db 10,"Practica 6"
                db 10,""
                db 10,""
                db 10,"Que desea realizar? 1. Calculadora 0. Salir"
                db 10,"",10,0


len equ 100
headerlen equ $ - header_txt
calclen equ $ - calc_header

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
    mov ecx, lpName ; Fuente 
    mov edx, name_len  ; Tamaño
    call PrintConsole

    cmp ecx,1
    je CalculatorMode
    jmp _start

    cmp ecx,0
    je Exit

CalculatorMode:

    mov ecx, calc_header ; Fuente 
    mov edx, calclen  ; Tamaño
    call PrintConsole


 Exit:  
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