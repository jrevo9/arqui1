;Jorge Alberto Rodriguez Mayorga
;200915030
section .data

header_txt: db 10,"Ingrese Opción:",10,13,
                db 10,"1. Inicio de Sesión",10,13
                db    "2. Registrar Usuario",10,13,0
                db    "3. Salir",10,13,0

headerlen equ $ - header_txt
userTXT db "Usuario: "
userTXT_len equ $ - userTXT
passTXT db "Contraseña: "
passTXT_len equ $ - passTXT

secmenu db "Menu Secundario ",10,13,
                db 10,"1. Ingresar Funcion",10,13
                db    "2. Imprimir Funcion Ingresada",10,13,0
                db    "3. Derivada de la Funcion",10,13,0
                db    "4. Integral de la Funcion",10,13,0
                db    "5. Encontrar ceros (Newton)",10,13,0
                db    "6. Salir",10,13,0
secmenu_len equ $ - secmenu

path db "users.txt",0
len equ $ - path
error1 db "ERROR!! Usuario NO encontrado.",10,13
error1_len equ $ - error1
error2 db "ERROR!! Contraseña incorrecta.",10,13
error2_len equ $ - error2
error3 db "Error!! La contraseña solo pueden ser numeros.",10,13
error3_len equ $ - error3
error4 db "Error! El usuario ya existe.",10,13
error4_len equ $ - error4
error5 db "validating password syntax",10,13
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
    add eax, 1
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
    cmp bl, 1            ; 
    je _user_notCreated 
    mov ecx, 0   
    cmp bl, 0            ; Comparar si el password es el mismo <Hacer Login>
    je _validatePass
    pop ebx
    
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
    cmp bl, 1                   ; validar si ingreso un password de numeros
    je _validate_pass_syntax 
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


_validate_pass_syntax:

    cmp ecx, 5
    jz _exit_validation

    xor bl, bl
    mov bl, [pass + ecx]
    add bl, '0'

    cmp bl, 0
    jl _error_on_syntax
    cmp bl, 9
    jb _error_on_syntax

    ;print error5, error5_len
    add ecx, 1
    jmp _validate_pass_syntax 

_exit_validation:
    jmp _registerUser

_error_on_syntax:
    print error3, error3_len
    jmp _register

_error_on_syntax_login:
    print error3, error3_len
    jmp _login


_validatePass:
    cmp ecx, 5
    jz _finish_validation

    xor bl, bl
    mov bl, [buffer + eax]
    mov [buf], bl
    xor bl, bl

    mov bl, [pass + ecx]
    mov [pas], bl
    xor bl, bl

    mov bl, [pas]

    ;push edx
    ;push ecx
    ;push ebx
    ;push eax
    ;print buf, 1
    ;print pas, 1
    ;pop eax
    ;pop ebx
    ;pop ecx
    ;pop edx
    add bl, '0'
    cmp bl, 0
    jl _error_on_syntax_login
    cmp bl, 9
    jb _error_on_syntax_login

    mov bl, [pas]

    cmp bl, [buf]
    jnz _wrong_pass
    jmp _compare_pass
ret

_compare_pass:
    add eax, 0x1
    add ecx, 0x1
    mov dl, 1
    jmp _validatePass

ret

_finish_validation:
    cmp dl, 1
    jz _secondary_menu
    jmp _login

_wrong_pass:
    mov ecx, 0
    mov eax, 0
    mov dl, 0 
    print error2, error2_len
    jmp _login

_secondary_menu:
    print alert1, alert1_len 
    print secmenu, secmenu_len
    
    ; Leer input del usuario
    read userInput, 2

    mov dl, byte [userInput]
    cmp dl, '1'
    ;jz  _login
    cmp dl, '2'
    ;jz  _register
    cmp dl, '3'
    jz  _login
    cmp dl, '4'
    ;jz  _register
    cmp dl, '5'
    ;jz  _exit
    cmp dl, '6'
    jz  _initApp

    call _secondary_menu



_exit:  
    mov eax, 1  
    mov ebx, 0 
    int 80h