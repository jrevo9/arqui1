section .data
fibo_msg: db "Fibonacci de ",0
msg_len  equ $-fibo_msg
fibo_equals: db " = ",0
eclen  equ $-fibo_equals
plus : db 2Bh
space : db 20h
equal : db 3Dh
nln: db '\n',0

section .bss
resulta resb 32 
num1 resb 100;
tmp resb 1;

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

_start: 

read num1,100

mov edx, eax
sub edx, 0x1
xor eax, eax
xor ecx, ecx

call _read_number

mov ecx, eax 


call _fibonacci    ;call to fibo

call _exit
;--------------------------------------------------------------------


;edx newest number
;ebx oldest number
;-----------------------------------------------------------------------
_fibonacci:
	cmp ecx, 0
	jz _ifzero	 ; condition to stop recursive call 
	cmp ecx, 1
	jz _ifone    ; condition to stop recursive call
	push ecx
	dec ecx		 ; decremente until ecx its 1
	call _fibonacci    ;recursive call
	pop ecx
	mov eax, edx  ; keep edx in eax, to pass it to ebx after calculates new number
	add edx, ebx  ; calculates new number in edx
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
    mov edx, 0 		;stablish first value of secuence f(0)= 0
    mov ebx, 0
    call print_msg_f
	call _print_fibonacci
	call _print_equals
    call _print_fibonacci ; prints f(0)
   mov [resulta], dword 0xA
    call _print_resulta
	mov edx, 1 		;stablish second value of secuence f(1)=1
	call print_msg_f
	call _print_fibonacci
	call _print_equals
    call _print_fibonacci ; prints f(1)

    mov [resulta], dword 0xA
    call _print_resulta
  ret 
;-----------------------------------------------------------------

;-----------------------------------------------------------------
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
print_space:   mov eax,4
	   		   push dword 1
	   		   push dword space
	   		   push dword 1
	   		   sub esp,4
	   		   int 0x80

	  add esp, 16 ; 4 bytes extra of mac os 
	  pop eax 
	  pop ebx	; return all  vaulues to original state
	  pop ecx
	  pop edx
	ret
;----------------------------------------------------------------

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


;-----------------------------------------------------------------

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


;-----------------------------------------------------------------




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

;-----------------------------------------------------------------
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



;---------------------------------------------------------------------
_exit:    mov eax, 1  
    push dword 0
    sub esp, 4
    int 0X80
;----------------------------------------------------------------------



;-----------------------------------------------------------------
;needs size to read in edx
;use eax to acumulate
;use ecx for count and offset, need to be 0 first call
;use bl as auxiliar
;use num1 as the buffer
;-----------------------------------------------------------------
_read_number:
    cmp ecx,edx
    jz _finish_read
    push edx
	xor edx, edx
	xor bl, bl
	mov edx, 0xA
	mov bl, [num1 + ecx]	;read first byte to bl
	mov [tmp], bl 		; move to a memmory space size of a byte
	push ecx
	mov ecx, dword [tmp] ;move to ecx with proper size
	sub ecx, 0x30		; get the real value of string represetation number
	mul edx	
	add eax, ecx
	pop ecx
	pop edx
	add ecx, 0x1
	call _read_number
 _finish_read:
    ret

