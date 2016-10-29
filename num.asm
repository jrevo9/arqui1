;calculator

section .data

operator_msg db 10,13,"Ingrese Operador: ",0
oplen equ $ - operator_msg
;
second_msg db "Ingrese Numero: ",0
secl equ $ - second_msg
;
result db "Resultado: ",0
reslen equ $ - result

nln: db 0xA
plus : db 2Bh
star: db 2Ah
dash: db 2Dh
slash: db 2Fh

section .bss
last resb 32 
num1 resb 100;
temp resb 1;


section .text


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

global _start
;----------------------------------------------
_start:
	print second_msg, secl
    
  	call _read_num ; stores in eax first operand

_get_Operand:
    push eax	
	print operator_msg, oplen
	read last, 2  
	pop eax		  
	mov dl, [last] ; use dl to compare  operation simbol
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
	sub edx, 0x1	 ; remove extra byte readed
	xor eax, eax     ; clean eax
	xor ecx, ecx	 ; clean ecx
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


_print_last:
		push edx
		push ecx
		push ebx
		push eax

		print last, 1

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
	   	mov [last], edx
	    call _print_last
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
	mov [temp], bl 		
	push ecx			
	mov ecx, dword [temp] 
	sub ecx, 0x30		
	mul edx				
	add eax, ecx		
	pop ecx				
	pop edx				
	add ecx, 0x1		
	call _read_number 
_finish_read:
 
 ret