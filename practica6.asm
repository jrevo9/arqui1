;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

header_txt db 10,"Universidad de San Carlos de Guatemala"
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

headerlen equ $ - header_txt
;
calc_header db "Modo Calculadora activado",10,13,
calclen equ $ - calc_header

section .bss 

menuInput:  resb 1 
calcInput:  resb 2 


section .text

Next:
    cmp al, '0'
    je Exit
    jmp Home

global _start

%macro print 2
        mov eax, 4  
        mov ebx, 1   
        mov ecx, %1  
        mov edx, %2  
        int 80h  

%endmacro

_start:
    mov ah, 00
    mov al, 03h
    int 80h
    jmp Home
    call Exit


Home:

    ; Imprimir Header
    ;mov eax, 4  ; Instruccion imprimir en consola
    ;mov ebx, 1 
    ;mov ecx, header_txt 
    ;mov edx, headerlen  
    ;int 80h

    print header_txt, headerlen

    ; Leer input del usuario
    mov eax, 3 
    mov ebx, 0
    mov ecx, menuInput
    mov edx, 1
    int 80h 

    mov al,  byte [menuInput]

    cmp al,'1'
    je CalculatorMode
    jmp Next
    ret

CalculatorMode:
    

    ; Imprimir Instruccion
    mov eax, 4  ; Instruccion imprimir en consola
    mov ebx, 1 
    mov ecx, calc_header ; Fuente 
    mov edx, calclen  ; Tamaño
    int 80h  

    ; Leer input del usuario 
    mov eax, 3 ; Instruccion para leer de consola
    mov ebx, 0 
    mov ecx, calcInput ; Destino
    mov edx, 2 ; Tamaño
    int 80h 

    mov ah, 00
    mov al, 03h
    int 80h

    ;Imprimir el texto ingresado por el usuario
    mov eax, 4  ; Instruccion imprimir en consola
    mov ebx, 1 
    mov ecx, calcInput ; Fuente 
    mov edx, 2 ; Tamaño
    int 80h 

    call Home

Exit:  
 
    ; Instrucciones para cerrar el programa
    mov eax, 1  
    mov ebx, 0 
    int 80h