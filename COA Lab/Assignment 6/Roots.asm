
extern printf, scanf

%macro PRINT 2
push rbp
mov rax, 0
mov rdi, %1
mov rsi, %2
call printf
pop rbp
%endmacro

%macro SCAN 2
push rbp
mov rax, 0
mov rdi, %1
mov rsi, %2
call scanf
pop rbp
%endmacro

%macro PRINTFLOAT 2
push rbp
mov rax, 1
mov rdi, %1
movsd xmm0, %2
call printf
pop rbp
%endmacro

section .data
msg1 db "Enter the value of a, b and c = ", 10, 0
len1 equ $-msg1
msg2 db "Roots are = ",10, 0
len2 equ $-msg1
m1 db "%lf", 0
m2 db "%s", 0
space db "", 10
splen equ $-space

section .bss
a resb 8
b resb 8
c resb 8
r1 resb 8
r2 resb 8
t1 resb 8
t2 resb 8
t3 resb 8
t4 resb 8
temp resw 1

section .text
global main
main:
PRINT m2, msg1
SCAN m1, a
SCAN m1, b
SCAN m1, c
PRINT m2, msg2

finit
fld qword[b]
fmul st0, st0
fstp qword[t1]		;b^2

fld qword[a]
fmul qword[c]
mov word[temp], 4
fimul word[temp]
fstp qword[t2]		;4ac

fld qword[t1]
fsub qword[t2]
fstp qword[t4]		;b^2 - 4ac

fld qword[t4]
fabs
fsqrt
fstp qword[t1]		;sqrt(b^2 - 4ac)

fld qword[b]
fchs
fstp qword[t2]		;-b

fld qword[a]
mov word[temp], 2
fimul word[temp]
fstp qword[t3]		;2a

cmp qword[t4], 00
je equal_roots

fld qword[t2]
fadd qword[t1]
fdiv qword[t3]
fstp qword[r1]

equal_roots:
fld qword[t2]
fsub qword[t1]
fdiv qword[t3]
fstp qword[r2]

PRINTFLOAT m1, [r1]
PRINT m2, space
PRINTFLOAT m1, [r2]
PRINT m2, space

mov rax, 00
ret
