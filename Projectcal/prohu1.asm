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
	
	