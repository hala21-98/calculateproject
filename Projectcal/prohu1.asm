.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
atoi PROTO C strptr:DWORD

include irvine32.inc

.data
A_l=100 ;Array length
string_equ BYTE A_l+1 DUP(?), 0 
s_temp1 BYTE A_l+1 DUP(?), 0  
s_temp2 BYTE A_l+1 DUP(?), 0
s_add BYTE '+' 
s_sub BYTE '-'
s_mul BYTE '*'
s_div BYTE '/'
r_add BYTE '+'
r_mul BYTE '*'
add_result DWORD 0 
mul_result DWORD 1
parse_result DWORD 0 

.code
main PROC 
lea edx,string_equ 
mov ecx,A_l+1 
call ReadString 
call step_add	
mov eax, add_result 
call writeint 
INVOKE ExitProcess,0 
main ENDP

step_mul PROC
MOV mul_result, 1 
xor esi, esi 
xor edi, edi
xor ecx, ecx
lea edx, s_temp2 
L1:
	mov bl, [s_temp1 + esi] 
	CMP bl, 0 ; if bl is 0
	JE End_Cont 
	cmp bl, s_mul 
	JE MUL_Cont 
	cmp bl, s_div
	JE DIV_Cont
	mov [s_temp2 + edi], bl
	inc ecx
	
	Inc_lbl :
inc esi
inc edi
JMP L1

MUL_Cont : 
lea edx, s_temp2
call ParseInteger32
cmp r_mul, '*'
JE MUL_RES
MOV parse_result, EAX
MOV EAX, mul_result
mov edx, 0
IDIV parse_result
MOV mul_result, EAX
JMP Cont_MUL
MUL_RES :
IMUL EAX, mul_result
MOV mul_result, EAX
Cont_MUL : 
MOV r_mul, '*'
MOV edi, -1
mov ecx, 0
push eax
call resetstemp2
pop eax
JMP Inc_lbl
DIV_Cont : 
lea edx, s_temp2
call ParseInteger32
cmp r_mul, '*'
JE MUL_RES2
MOV parse_result, EAX
MOV EAX, mul_result
MOV edx, 0
IDIV parse_result
MOV mul_result, EAX
JMP Cont_DIV
MUL_RES2 :
IMUL EAX, mul_result
MOV mul_result, EAX
Cont_DIV :
MOV r_mul, '/'
MOV edi, -1
mov ecx, 0
push eax
call resetstemp2
pop eax
JMP Inc_lbl
	
	
