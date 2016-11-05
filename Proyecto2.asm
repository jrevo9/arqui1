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
error4 db "Error!! El usuario ya existe.",10,13
error4_len equ $ - error4
error5 db "Error!! No se ha ingresado funcion.",10,13
error5_len: equ $-error5

alert1 db "Sesión Iniciada Exitosamente!",10,13
alert1_len equ $ - alert1
alert2 db "Usuario Creado con Exito!",10,13
alert2_len equ $ - alert2

msg1:  db "Coeficiente  ",0
msg1_len: equ $-msg1

x4_txt: db "xˆ4 ",0 
x3_txt: db "xˆ3 ",0 
x2_txt: db "xˆ2 ",0 
x1_txt: db "x ",0
x_txt: db "C ",0

tmpUser db ""
comma : db 2ch
dotcom : db 3bh
plus : db 2Bh
space : db 20h
equal : db 3Dh
nln: db  0xA
star: db 2Ah
dash: db 2Dh
slash: db 2Fh
dot: db 2Eh
_eof: db 0x0
_op: db 2Bh
sx4 db 2Bh
sx3 db 2Bh
sx2 db 2Bh
sx1 db 2Bh
sx0 db 2Bh


section .bss 

userInput resb 32
buffer resb 100
user resb 6
pass resb 6
buf resb 1
us resb 1
pas resb 1
login resb 1 ; 0 login 1 register
vx0 resb 4
vx3 resb 4
vx2 resb 4
vx1 resb 4
vx4 resb 4
buff1 resb 100
tmp resb 1



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
    jz _proceed
    jmp _login

_wrong_pass:
    mov ecx, 0
    print error2, error2_len
    jmp _login

_proceed:
    print alert1, alert1_len 
    call _secondary_menu

_secondary_menu:
   
    print secmenu, secmenu_len
    
    ; Leer input del usuario
    read userInput, 2

    mov dl, byte [userInput]
    cmp dl, '1'
    jz  _get_function
    cmp dl, '2'
    jz  _function_requested
    cmp dl, '3'
    jz  _derivate_requested
    cmp dl, '4'
    jz  _integrate_requested
    cmp dl, '5'
    ;jz  _exit
    cmp dl, '6'
    jz  _initApp

    call _secondary_menu

_get_function:
       
    call _print_msg1 
    print x1_txt, 1
    call print_space
    call print_space
    call print_space
    call _read_input_number
    mov [vx1], eax
    xor ebx, ebx
    mov bl , byte [_op]
    mov [sx1], bl

    xor eax, eax
    xor ebx,ebx
    call _print_msg1 
    print x2_txt, 4
    call print_space
    xor eax, eax
    xor ebx,ebx
    xor edx,edx
    xor ecx, ecx
    call _read_input_number
    mov [vx2], eax
    xor ebx, ebx
    mov bl , byte [_op]
    mov [sx2], bl

    call _print_msg1 
    print x3_txt, 4
    call print_space
    xor eax, eax
    xor ebx,ebx
    xor edx,edx
    xor ecx, ecx
    call _read_input_number
    mov [vx3], eax
    xor ebx, ebx
    mov bl , byte [_op]
    mov [sx3], bl

    xor eax, eax
    xor ebx,ebx
    call _print_msg1 
    print x4_txt, 4
    call print_space
    call _read_input_number
    mov [vx4], eax
    xor ebx, ebx
    mov bl , byte [_op]
    mov [sx4], bl

    call _print_msg1 
    print x_txt, 3
    call print_space
    xor eax, eax
    call _read_input_number
    mov [vx0], eax
    xor ebx, ebx
    mov bl , byte [_op]
    mov [sx0], bl
    xor ebx, ebx
    mov bl, 0x1
    mov [_eof],bl

jmp _secondary_menu

_print_function:
    
    mov eax, [vx1]
    cmp eax, 0x0
    jz write_x0
    xor ebx,ebx
    mov bl, byte [sx1]
    cmp bl, [dash]
    jnz write_x1
    push eax
    print sx1,1
    pop eax

    write_x1:
    call _print_number
    print x1_txt,3
    call print_space

    write_x2:   
    mov eax, [vx2]
    cmp eax, 0x0
    jz write_x1
    push eax
    print sx2,1
    pop eax
    call _print_number
    print x2_txt,4
    call print_space

    write_x3:
    mov eax, [vx3]
    cmp eax, 0x0
    jz write_x2
    push eax
    print sx3,1
    pop eax
    call _print_number
    print x3_txt,4
    call print_space

    write_x4:
    mov eax, [vx4]
    cmp eax, 0x0
    jz  write_x3
    push eax
    print sx4,1
    pop eax
    call _print_number
    print x4_txt,4
    call print_space

    write_x0:
    mov eax, [vx0]
    cmp eax, 0x0
    jz end_print
    push eax
    print sx0,1
    pop eax
    call _print_number

end_print:
    call _print_ln

jmp _secondary_menu

_print_derivate:
    xor ebx,ebx
    mov bl, byte [sx2]
    cmp bl, [dash]
    jnz write_x2_d
    push eax
    print sx2,1
    pop eax

    write_x2_d:
    mov eax, [vx2]
    cmp eax, 0x0
    jz write_x1_d 
    mov ecx, 0x2
    mul ecx
    call _print_number
    print x1_txt,3
    call print_space

    write_x3_d:
    mov eax, [vx3]
    cmp eax, 0x0
    jz write_x2_d
    push eax
    print sx3,1
    pop eax
    mov ecx, 0x3
    mul ecx
    call _print_number
    print x2_txt,4
    call print_space

    write_x4_d:
    mov eax, [vx4]
    cmp eax, 0x0
    jz  write_x3_d
    push eax
    print sx4,1
    pop eax
    mov ecx, 0x4
    mul ecx
    call _print_number
    print x3_txt,4
    call print_space

    write_x1_d: 
    mov eax, [vx1]
    cmp eax, 0x0
    jz end_print_d
    push eax
    print sx1,1
    pop eax
    call _print_number
    call print_space

    

    end_print_d:

    call _print_ln

jmp _secondary_menu


_print_integrate:

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    mov eax, [vx0]
    cmp eax, 0x0
    jz  print_x1
    push eax
    push edx
    print sx0, 1
    pop edx
    pop eax

    call _print_number

    call print_space
    print x1_txt,3
    

    print_x1:
    mov eax, [vx1]
    cmp eax, 0x0
    jz end_print_integrate
    push eax
    print sx1, 1
    pop eax
    mov eax, [vx1]
    mov ecx, 0x2
    div ecx

    call _print_number

    cmp edx,0x0
    jz no_dec_x1
    mov eax, edx
    mov ebx, 0x3E8
    mul ebx
    div ecx
    print dot, 1
    no_dec_x1:
    call _print_number
    print x2_txt,4

    end_print_integrate:

    print plus, 1
    print x_txt,2
    call _print_ln

jmp _secondary_menu

_function_requested:
    xor ecx, ecx
    mov cl, byte [_eof]
    cmp cl, 0x0
    jz _no_function_entered
    jmp _print_function


_derivate_requested:
    xor ecx, ecx
    mov cl, byte [_eof]
    cmp cl, 0x0
    jz _no_function_entered
    jmp _print_derivate

_integrate_requested:
    xor ecx, ecx
    mov cl, byte [_eof]
    cmp cl, 0x0
    jz _no_function_entered
    jmp _print_integrate
     

_no_function_entered:
    print error5, error5_len
    jmp _secondary_menu

_print_number:
    push edx
    push ecx
    push ebx
    push eax

    cmp eax, 0x0

    jz zero

    xor  edx, edx
    xor  ecx, ecx
    mov  ecx, 0xA
    div ecx
    push edx
    call _print_number
    pop edx
    add edx, '0'
    mov [userInput], edx
    call _print_userInput
zero:       
    pop eax
    pop ebx
    pop ecx
    pop edx
ret

_print_userInput:
    push edx
    push ecx
    push ebx
    push eax

    print userInput, 1

    pop eax
    pop ebx
    pop ecx
    pop edx
ret

_print_ln:
    push edx
    push ecx
    push ebx
    push eax
    print nln,0x1
    pop eax
    pop ebx
    pop ecx
    pop edx
ret


print_space:   

    push edx
    push ecx
    push ebx
    push eax

    print space, 1

    pop eax
    pop ebx
    pop ecx
    pop edx
ret


_print_msg1: 
    push edx
    push ecx
    push ebx
    push eax
    
    print msg1, msg1_len

    pop eax
    pop ebx
    pop ecx
    pop edx
 
ret

_read_number:
    cmp ecx,edx         
    jz end_read
    push edx        
    xor edx, edx    
    xor bl, bl      
    mov edx, 0xA    
    mov bl, [buff1 + ecx]   
    mov [tmp], bl       
    push ecx            
    mov ecx, dword [tmp] 
    sub ecx, 0x30       
    mul edx             
    add eax, ecx        
    pop ecx             
    pop edx             
    add ecx, 0x1        
    call _read_number 
end_read:
ret

_read_input_number:
    push edx  
    push ecx  
    mov  byte [_op], 2Bh
    read buff1,100
    mov edx, eax    
    
    mov edx, eax    
    sub edx, 0x1     

    xor ecx, ecx    
    mov al, [buff1] 
    cmp al, [dash]
    jnz  positive
    mov [_op], al
    add ecx, 0x1
    jmp continue

positive:
    cmp al, [plus]
    jnz continue
    add ecx,0x1

continue:
    xor eax, eax     ; clean eax
    call _read_number

    pop ecx
    pop edx
ret

_exit:  
    mov eax, 1  
    mov ebx, 0 
    int 80h