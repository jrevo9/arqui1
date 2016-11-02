;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

file db "hello.txt", 0
report db "report.res", 0
msg db " ", 0
msg2 db "hello.txt", 0
msg2_size equ $ - msg2
current db 0

header_txt: db 10,"Ingrese Opción",10,13,10,13
                db 10,"1. Inicio de Sesión",10,13
                db    "2. Registrar Usuario",10,13,0


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
    mov ecx, lpName ; Fuente 
    mov edx, name_len   ; Tamaño
    call PrintConsole

    ; Abrir el archivo
    ;mov eax, 5  ; Instruccion para abrir
    ;mov ebx, lpName ; nombre del archivo
    ;mov ecx, 0  ; 
    ;int 80h     

    ; Guardar el contenido en el buffer
    ;mov eax, 3  
    ;mov ebx, eax
    ;mov ecx, buffer
    ;mov edx, len  
    ;int 80h     

    ; Imprimir el texto del buffer
    ;mov ecx, buffer ; Fuente (buffer) 
    ;mov edx, len   ; Tamaño
    ;call PrintConsole 


    ; Procesar contenido del buffer
    jmp _start

to_list:
    mov ecx, buffer
   

list_loop:
    cmp byte[ecx], 3bh
    je list_ret

    cmp byte[ecx], 2ch      
    jne move_next
    ;mov byte[ecx], 9
    jmp found_comma

;    inc ecx                 
;    jmp list_loop 

move_next:
    movzx eax,byte[esi]
    ;sub al,'0'
    ;imul ebx,10
    add edx,eax   ; ebx = ebx*10 + eax
    ;mov eax, 4
    ;mov ebx, 1
    ;mov edx, 1            
    ;int 80h  
    inc ecx                 
    jmp list_loop 

found_comma:
    ;mov dword [current], ebx 
    ;mov eax, 4
    ;mov ecx, current
    ;mov ebx, 1
    
    ;mov edx, 10           
    ;int 80h
    ;jmp list_ret  
    inc ecx                 
    jmp list_loop 

mul:    
    ;mov eax, 10
    ;mov edx, eax
    ;mul edx
    ;movzx eax, byte[ecx]
    ;add edx, eax

list_store:
    ;mov ecx, edx
    ;mov edx, 4 ; Tamaño
    ;call PrintConsole 
    ;je list_ret
    ;inc ecx                 
    ;jmp list_loop 

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