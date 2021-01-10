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
	
End_Cont :
lea edx, s_temp2
call ParseInteger32
cmp r_mul, '*'
JE MUL_RES3
MOV parse_result, EAX
MOV EAX, mul_result
mov edx, 0
IDIV parse_result
MOV mul_result, EAX
JMP Cont_F
MUL_RES3 :
IMUL EAX, mul_result
MOV mul_result, EAX
Cont_F :
push eax
call resetstemp2
pop eax
ret
step_mul ENDP

step_add PROC
xor esi, esi
xor edi, edi
L1 :
mov cl, [edx + esi]
CMP cl, 0
JE End_Cont
cmp cl, s_add
JE ADD_Cont
cmp cl, s_sub
JE SUB_Cont
mov[s_temp1 + edi], cl
Inc_lbl :
inc esi
inc edi
JMP L1

ADD_Cont :
push esi
push edi
push edx
push ecx
call step_mul
pop ecx
pop edx
pop edi
pop esi
cmp r_add, '+'
JE ADD_RES
MOV EAX, mul_result
SUB add_result, EAX
JMP Cont_ADD	

ADD_RES :
MOV EAX, mul_result
ADD add_result, EAX
Cont_ADD :
MOV edi, -1
push eax
call resetstemp1
pop eax
JMP Inc_lbl
SUB_Cont :
push esi
push edi
push edx
push ecx
call step_mul
pop ecx
pop edx
pop edi
pop esi
cmp r_add, '+'
JE ADD_RES2
MOV EAX, mul_result
SUB add_result, EAX
JMP Cont_SUB
ADD_RES2 :
MOV EAX, mul_result
ADD add_result, EAX
Cont_SUB :
MOV r_add, '-'
MOV edi, -1
push eax
call resetstemp1
pop eax
JMP Inc_lbl

End_Cont : 
push esi
push edi
push edx
push ecx
call step_mul
pop ecx
pop edx
pop edi
pop esi
cmp r_add, '+'
JE ADD_RES3
MOV EAX, mul_result
SUB add_result, EAX

[6:46 PM, 1/10/2021] Nada Gamal: ADD_RES :
MOV EAX, mul_result
ADD add_result, EAX
Cont_ADD :
MOV edi, -1
push eax
call resetstemp1
pop eax
JMP Inc_lbl
SUB_Cont :
push esi
push edi
push edx
push ecx
call step_mul
pop ecx
pop edx
pop edi
pop esi
cmp r_add, '+'
JE ADD_RES2
MOV EAX, mul_result
SUB add_result, EAX
JMP Cont_SUB
ADD_RES2 :
MOV EAX, mul_result
ADD add_result, EAX
Cont_SUB :
MOV r_add, '-'
MOV edi, -1
push eax
call resetstemp1
pop eax
JMP Inc_lbl

End_Cont : 
push esi
push edi
push edx
push ecx
call step_mul
pop ecx
pop edx
pop edi
pop esi
cmp r_add, '+'
JE ADD_RES3
MOV EAX, mul_result
SUB add_result, EAX
[6:51 PM, 1/10/2021] Nada Gamal: JMP Cont_F2                           
ADD_RES3 :
MOV EAX, mul_result
ADD add_result, EAX
Cont_F2 :
push eax
call resetstemp1
pop eax
ret
step_add ENDP

resetstemp1 PROC
mov eax, 0
L1:
cmp eax, A_l + 1
JG Finish 
MOV[s_temp1 + eax], 0
inc eax
JMP L1
Finish :
ret
resetstemp1 ENDP

resetstemp2 PROC
mov eax, 0
L1 :
	cmp eax, A_l + 1
	JG Finish
	MOV[s_temp2 + eax], 0
	inc eax
	JMP L1
	Finish :
ret
resetstemp2 ENDP
END main
