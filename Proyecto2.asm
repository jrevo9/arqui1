;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

header_txt: db 10,"Ingrese Opción",10,13,
                db 10,"1. Inicio de Sesión",10,13
                db    "2. Registrar Usuario",10,13,0
                db    "3. Salir",10,13,0

headerlen equ $ - header_txt
userTXT db "Usuario: "
userTXT_len equ $ - userTXT
passTXT db "Contraseña: "
passTXT_len equ $ - passTXT

secmenu db "Menu Secundario ",10,13,10,13
secmenu_len equ $ - secmenu

path db "users.txt",0
len equ $ - path
error1 db "ERROR!! Usuario NO encontrado.",10,13
error1_len equ $ - error1
error2 db "ERROR!! Contraseña incorrecta.",10,13
error2_len equ $ - error2
error3 db "WUJUUUU!! Usuario encontrado.",10,13
error3_len equ $ - error3
error4 db "Error! El usuario ya existe.",10,13
error4_len equ $ - error4
error5 db "WUJUUUU!! Usuario encontrado.",10,13
error5_len equ $ - error5

alert1 db "Sesión Iniciada Exitosamente!",10,13
alert1_len equ $ - alert1
alert2 db "Usuario Creado con Exito!",10,13
alert2_len equ $ - alert2

tmpUser db ""
comma : db 2ch
dotcom : db 3bh



section .bss 

userInput resb 2
buffer resb 100
user resb 6
pass resb 6
buf resb 1
us resb 1
pas resb 1
login resb 1 ; 0 login 1 register



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

%macro openfile 2
    mov eax, 5
    mov ebx, %1
    mov ecx, 02001Q
    mov edx, %2
    int 80h

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
    cmp dl, '2'
    jz  _register

    cmp dl, '3'
    jz  _exit

    call _initApp

ret

_login:
    print userTXT, userTXT_len
    read user, 6
    
    print passTXT, passTXT_len
    read pass, 6

    mov bl, 0
    mov [login], bl
    call _validateUser
    ;call _validatePass

ret

_register:
    print userTXT, userTXT_len
    read user, 6
    
    print passTXT, passTXT_len
    read pass, 6

    mov bl, 1
    mov [login], bl
    call _validateUser

    call _initApp

ret

_registerUser:

    openfile path, len
    
    ; Escribir usuario
    mov ebx, eax
    mov eax, 4
    mov edx, 5
    mov ecx, user
    int 80h

    openfile path, len

    ; Escribir coma
    mov ebx, eax
    mov eax, 4
    mov edx, 1
    mov ecx, comma
    int 80h

    openfile path, len

    ; Escribir password
    mov ebx, eax
    mov eax, 4
    mov edx, 5
    mov ecx, pass
    int 80h

    openfile path, len

    ; Escribir punto y coma
    mov ebx, eax
    mov eax, 4
    mov edx, 1
    mov ecx, dotcom
    int 80h

    ; Cerrar el archivo
    mov eax, 6  
    int 80h     

    jmp _userCreated

ret


_validateUser:
    mov eax, 5  
    mov ebx, path
    mov ecx, 0   
    int 80h

    mov eax, 3  
    mov ebx, eax
    mov ecx, buffer
    mov edx, 100 
    int 80h 

    mov eax, 0
    mov ecx, 0
    mov dl, 1
    call _compare
ret


; eax como contador del buffer
; ecx como contador de user
; dl flag

_compare:
    xor bl, bl
    mov bl, [buffer + eax]
    mov [buf], bl
    xor bl, bl

    mov bl, [user + ecx]
    mov [us], bl
    xor bl, bl

    mov bl, [buf]

    cmp bl, 0x0A
    je _finish_compare

    ;push edx
    ;push ecx
    ;push ebx
    ;push eax
    ;print buf, 1
    ;print us, 1
    ;pop eax
    ;pop ebx
    ;pop ecx
    ;pop edx

    cmp bl, ','
    je _found_comma

    cmp bl, ';'
    je _found_dot

    cmp bl, [us]
    je _compare_user
    jmp _compare_next
    

_finish_compare:
    mov ecx, 0
    mov eax, 0
    cmp dl, 0
    je _foundUser
    jmp _notfoundUser

_compare_next:
    add eax, 0x1
    add ecx, 0x1
    mov dl, 1
    jmp _compare

_compare_user:
    add eax, 0x1
    add ecx, 0x1
    mov dl, 0
    jmp _compare

 _found_comma:
    mov ecx, 0
    cmp bl, 1
    je _validatePass
    add eax, 7
    cmp dl, 0
    je _foundUser
    jmp _compare

_found_dot:
    add eax, 1
    mov ecx, 0
    jmp _compare

_foundUser:
    push edx
    push ecx
    push ebx
    push eax
    xor bl, bl
    mov bl, [login]
    cmp bl, 1
    je _user_notCreated
    print alert1, alert1_len
    pop eax
    pop ebx
    pop ecx
    pop edx
    
    jmp _secondary_menu

_notfoundUser:
    push edx
    push ecx
    push ebx
    push eax
    xor bl, bl
    mov bl, [login]
    cmp bl, 1
    je _registerUser
    print error1, error1_len
    pop eax
    pop ebx
    pop ecx
    pop edx 

    jmp _initApp

_userCreated:
    push edx
    push ecx
    push ebx
    push eax
    print alert2, alert2_len
    pop eax
    pop ebx
    pop ecx
    pop edx
    
    jmp _initApp

_user_notCreated:
    push edx
    push ecx
    push ebx
    push eax
    print error4, error4_len
    pop eax
    pop ebx
    pop ecx
    pop edx
    
    jmp _register


_validatePass:
    ;print ebx, 1

ret

_secondary_menu:
print secmenu, secmenu_len


_exit:  
    mov eax, 1  
    mov ebx, 0 
    int 80h