
;Name - Mohit Jaiswal
;Roll No. - 57
;PRN No. - 202101040048
;Practical No. 3 - Multiplication using Successive Addition, Shift and Add Method

%macro WRITE 02
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 02
mov rax,00
mov rdi,00
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
menu db 10,10,"1.Successive Addition method",10
db "2.Shift addition method",10
db "3.Exit",10
db "Please Enter your choice:",10
menulen equ $-menu

msg1 db 10,"Enter 2 numbers to multiply",10
len1 equ $-msg1
msg2 db "The Multiplication is: ",10
len2 equ $-msg2
msg7 db 10,"Please enter correct choice! :",10
len7 equ $-msg7


section .bss

char_buff resb 17
actl resq 1
m resq 1
n resq 1
c resq 1
a resq 1
b resq 1
q resq 1
x resb 1
choice resb 2

section .text

global _start
_start:

WRITE msg1,len1

READ char_buff,17
call accept
mov [m],rbx

READ char_buff,17
call accept
mov [n],rbx

print_menu:
WRITE menu,menulen
READ choice,2
cmp byte[choice],31H
je succadd
cmp byte[choice],32H
je shiftadd
cmp byte[choice],33H
je exit

WRITE msg7,len7
jmp print_menu

succadd:
mov rcx,[m]
mov rbx,00
up: add rbx,[n]
dec rcx
jnz up
mov [c],rbx
WRITE msg2,len2
mov rbx,[c]
call display
jmp print_menu

shiftadd:
mov qword[a],0
mov rax,[m]
mov [b],rax
mov rax,[n]
mov [q],rax
mov byte[x],64

up5: mov rbx,[q]
and rbx,01
jz shiftaq
mov rbx,[b]
add[a],rbx

shiftaq : shr qword[q],01
mov rbx,[a]
and rbx,01
jz shifta
mov rbx,1
ror rbx,1
or qword[q],rbx

shifta: shr qword[a],01
dec byte[x]
jnz up5

WRITE msg2,len2
mov rbx,[a]
call display
mov rbx,[q]
call display

jmp print_menu

exit :
mov rax,60
mov rdi,00
syscall

accept : dec rax
mov [actl],rax
mov rbx,00
mov rsi,char_buff

up3:shl rbx,04H
mov rdx,00H
mov dl,byte[rsi]
cmp dl,39H
jbe sub301
sub dl,07H

sub301: sub dl, 30H
add rbx,rdx
inc rsi
dec qword[actl]
jnz up3
ret

display :
mov rsi,char_buff
mov rcx,16
up4: rol rbx,04H
mov dl,bl
and dl,0fH
cmp dl ,9
jbe add30
add dl,7
add30:add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up4
WRITE char_buff,16
ret
