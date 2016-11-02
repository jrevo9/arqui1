;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

header_txt: db 10,"Ingrese Opción",10,13,
                db 10,"1. Inicio de Sesión",10,13
                db    "2. Registrar Usuario",10,13,0

headerlen equ $ - header_txt
userTXT db "Usuario: "
userTXT_len equ $ - userTXT
passTXT db "Contraseña: "
passTXT_len equ $ - passTXT



section .bss 

userInput resb 2
user resb 6
pass resb 6


section .text

global _start

_start:

%macro print 2
        mov eax, 4  
        mov ebx, 1   
        mov ecx, %1  
        mov edx, %2  
        sub esp ,4 
        int 80h  
        add esp, 4

%endmacro

%macro read 2
        mov eax, 3  
        mov ebx, 0   
        mov ecx, %1  
        mov edx, %2 
        sub esp ,4 
        int 80h  
        add esp, 4
%endmacro


call _initApp
call _exit

_initApp:

    ; Imprimir Header
    print header_txt, headerlen 

    ; Leer input del usuario
    read userInput, 2

    mov dl, byte [userInput]
    cmp dl, '1'
    jz  _login
ret

_login:
    print userTXT, userTXT_len
    read user, 6
    call _validateUser
    print passTXT, passTXT_len
    read pass, 6
    call _validatePass

    print user, 5
    print pass, 5


_validateUser:

ret

_validatePass:

ret

_exit:  
    mov eax, 1  
    mov ebx, 0 
    int 80h