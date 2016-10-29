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
calc_header db "Modo Calculadora activado",10,13,10,13,"Ingrese Opcion 1.Operaciones  2.Fibonacci",10,13,0
calclen equ $ - calc_header
;
operations_header db "Menu de operaciones",10,13,10,13,0
opl equ $ - operations_header
;
fibonacci_header db "Ingrese Numero a calcular Fibonacci",10,13,0
fibl equ $ - fibonacci_header
;
operator_msg db 10,13,"Ingrese Operador: ",0
oplen equ $ - operator_msg
;
second_msg db "Ingrese Numero: ",0
secl equ $ - second_msg
;
result db "Resultado: ",0
reslen equ $ - result
;
fibo_msg: db "Fibonacci de ",0
msg_len  equ $-fibo_msg
;
fibo_equals: db " = ",0
eclen  equ $-fibo_equals
;
suma  db "SUM",10,13
resta db "RES",10,13
multi db "MUL",10,13

nln: db 0xA
plus : db 2Bh
star: db 2Ah
dash: db 2Dh
slash: db 2Fh
space : db 20h
equal : db 3Dh

section .bss 

menuInput:  resb 2 
calcInput:  resb 2 
num1 resb 51
num2: resb 100
resulta: resb 1
tmp : resb 1
res : resb 32
tstResult : resb 32


section .text


global _start

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

_start:
    call Home

Home:
    print header_txt, headerlen ; Imprimir Header
    read menuInput, 2           ; Leer input del usuario
    mov al,  byte [menuInput]
    cmp al,'1'
    je CalculatorMode
    jmp Next
ret

Next:
    cmp al, '0'
    je Exit
    jmp Home
ret

Exit:  
    mov eax, 1  
    mov ebx, 0 
    int 80h
ret

CalculatorMode:
    print calc_header, calclen ; Imprimir Instruccion
    read calcInput, 2          ; Leer input del usuario 
    mov al,  byte [calcInput]  ; Comparar operaciones o fibonnacci
    cmp al,'1'
    je Calculator
    cmp al,'2'
    je Fibonacci
    jmp Home


Calculator:
    print second_msg, secl
    
    call _read_num ; stores in eax first operand

_get_Operand:
    push eax    
    print operator_msg, oplen
    read resulta, 2  
    pop eax       
    mov dl, [resulta] ; use dl to compare  operation simbol
    cmp dl, 2Bh ;+
    jz  cll_sum 
    cmp dl, 2Ah ;-
    jz cll_mult
    cmp dl, [dash]
    jz cll_sub
    cmp dl, [slash]
    jz cll_div
_end_calc:

_show_result:
   push eax
   print result, reslen
   pop eax
   ;mov edx, eax
   call _print_number
   call  _print_ln
   jmp _get_Operand

cll_sum : 
   call _addition
   jmp _show_result 
cll_mult : 
   call _multip
   jmp _show_result
cll_sub : 
   call _substraction
   jmp _show_result
cll_div : 
   call _divide
   jmp _show_result

_read_num:
    push edx  ; save edx previus value
    push ecx  ; save ecx previus value
     
    read num1,100

    mov edx, eax     ;count of bytes readed
    sub edx, 0x1     ; remove extra byte readed
    xor eax, eax     ; clean eax
    xor ecx, ecx     ; clean ecx
    call _read_number

    pop ecx
    pop edx
  ret

_addition:
    push eax
    print second_msg, secl
    call _read_num
    mov edx, eax
    pop eax
    add eax, edx
 ret

_multip:
    push eax
    print second_msg, secl
    call _read_num
    mov edx, eax
    pop eax
    mul edx
     
 ret


_substraction:
     push eax
     print second_msg, secl
     call _read_num
     mov edx, eax
     pop eax
     sub eax, edx
 ret


_divide:
     push eax
     print second_msg, secl
     call _read_num
     xor edx,edx 
     mov ecx, eax
     xor eax, eax
     pop eax
     div ecx
 ret


_print_resulta:
        push edx
        push ecx
        push ebx
        push eax

        print resulta, 1

        pop eax
        pop ebx
        pop ecx
        pop edx
 ret

_print_number:
        push edx
        push ecx
        push ebx
        push eax

        cmp eax, 0x0

        jz _ended

        xor  edx, edx
        xor  ecx, ecx
        mov  ecx, 0xA
        div ecx
        push edx
        call _print_number
        pop edx
        add edx, 0x30
        mov [resulta], edx
        call _print_resulta
_ended:     
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

_read_number:
    cmp ecx,edx         
    jz _finish_read 
    push edx        
    xor edx, edx    
    xor bl, bl      
    mov edx, 0xA    
    mov bl, [num1 + ecx]    
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
_finish_read:
 
 ret

Fibonacci:
    print fibonacci_header, fibl
    read num1,50

    mov edx, eax
    sub edx, 0x1
    xor eax, eax
    xor ecx, ecx

    call _read_number

    mov ecx, eax 


    call _fibonacci   

    jmp Home

_fibonacci:
    cmp ecx, 0
    jz _ifzero   
    cmp ecx, 1
    jz _ifone    
    push ecx
    dec ecx      
    call _fibonacci  
    pop ecx
    mov eax, edx  
    add edx, ebx  
    push edx
    mov edx, ecx
    call print_msg_f
    call _print_fibonacci
    call _print_equals
    mov edx, ebx
    call _print_fibonacci
    mov [resulta],dword 0x2B
    call _print_resulta
    mov edx,  eax
    call _print_fibonacci
    mov [resulta],dword 0x3D
    call _print_resulta
    pop edx 
    mov ebx, eax  ; pass to ebx  old  edx, to be teh oldest number
    call _print_fibonacci  ; prints edx 
    mov [resulta], dword 0xA
    call _print_resulta
ret
_ifzero:
    mov edx, 0
    call print_msg_f
    call _print_fibonacci
    call _print_equals
    call _print_fibonacci
   ret
_ifone:
    mov edx, 0      ;stablish first value of secuence f(0)= 0
    mov ebx, 0
    call print_msg_f
    call _print_fibonacci
    call _print_equals
    call _print_fibonacci ; prints f(0)
    mov [resulta], dword 0xA
    call _print_resulta
    mov edx, 1      ;stablish second value of secuence f(1)=1
    call print_msg_f
    call _print_fibonacci
    call _print_equals
    call _print_fibonacci ; prints f(1)

    mov [resulta], dword 0xA
    call _print_resulta
ret 

_print_fibonacci:
   push edx
   push ecx
   push ebx
   push eax
   mov eax, 0x0
   mov eax, edx
   cmp eax,0x0
   jz first_z
   call _print_number
   jmp print_space
first_z: 
    mov [resulta], dword '0'
    call _print_resulta
print_space:   
    mov eax,4
    push dword 1
    push dword space
    push dword 1
    sub esp,4
    int 0x80

    add esp, 16 ; 4 bytes extra of mac os 
    pop eax 
    pop ebx   ; return all  vaulues to original state
    pop ecx
    pop edx
ret

print_msg_f:
    push edx
    push ecx
    push ebx
    push eax

    print fibo_msg, msg_len

    pop eax
    pop ebx
    pop ecx
    pop edx
 ret

_print_equals:
    push edx
    push ecx
    push ebx
    push eax


    print fibo_equals, eclen


    pop eax
    pop ebx
    pop ecx
    pop edx
 ret


