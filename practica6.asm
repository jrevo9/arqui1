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
                db 10,"Que desea realizar? 1.Calculadora 0.Salir"
                db 10,"",10,0

headerlen equ $ - header_txt
;
calc_header db "Modo Calculadora activado",10,13,10,13,"Ingrese Opcion 1.Operaciones  2.Fibonacci",10,13
calclen equ $ - calc_header
;
operations_header db "Menu de operaciones",10,13,10,13
opl equ $ - operations_header
;
fibonacci_header db "Menu Fibinacci",10,13
fibl equ $ - fibonacci_header
;
operator_msg db "Ingrese Operador: "
oplen equ $ - operator_msg
;
second_msg db "Ingrese Numero: "
secl equ $ - second_msg
suma  db "SUM",10,13
resta db "RES",10,13
multi db "MUL",10,13
divi  db "DIV",10,13


section .bss 

menuInput:  resb 1 
calcInput:  resb 2 
num1: resb 2
num2: resb 2
operator: resb 2



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

%macro read 2
        mov eax, 3  
        mov ebx, 0   
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
    print header_txt, headerlen

    ; Leer input del usuario
    read menuInput, 1

    mov al,  byte [menuInput]

    cmp al,'1'
    je CalculatorMode
    jmp Next
    ret

SUM:
    print suma, 3
    jmp Operations

RES:
    print resta, 3
    jmp Operations

MUL:
    print multi, 3
    jmp Operations

DIV:
    print divi, 3
    jmp Operations

Init_Operations:
     print second_msg, secl

    read num1, 2


Operations:
    print operator_msg, oplen

    read operator, 2

    print second_msg, secl

    read num2, 2

    print num1, 2

    print operator, 2

    print num2, 2

    cmp byte[operator], '+'
    je SUM
    cmp byte[operator],'-'
    je RES
    cmp byte[operator],'*'
    je MUL
    cmp byte[operator],'/'
    je DIV

    jmp Operations


Fibonacci:
    print fibonacci_header, fibl
    jmp Home


CalculatorMode:
    
    ; Imprimir Instruccion
    print calc_header, calclen 

    ; Leer input del usuario 
    read calcInput, 2

    ; limpiar 
    mov ah, 00
    mov al, 03h
    int 80h

    ; Comparar operaciones o fibonnacci

    mov al,  byte [calcInput]

    cmp al,'1'
    je Init_Operations

    cmp al,'2'
    je Fibonacci

    ;Imprimir el texto ingresado por el usuario
    print calcInput, 2

    ; Regresar al menu principal
    call Home

Exit:  
 
    ; Instrucciones para cerrar el programa
    mov eax, 1  
    mov ebx, 0 
    int 80h