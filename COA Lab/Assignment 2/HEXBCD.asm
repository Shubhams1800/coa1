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
menu db 10,10,"1.BCD to HEX",10
db "2.HEX to BCD",10
db "3.Exit",10
db "Please Enter your choice:",10
menulen equ $-menu

msg1 db 10,"Enter BSD number",10
len1 equ $-msg1
msg2 db "The Hexadecimal Equivalent is: ",10
len2 equ $-msg2
msg3 db 10,"Enter Hex number",10
len3 equ $-msg3
msg4 db "The BCD Equivalent is: ",10
len4 equ $-msg4

msg7 db 10,"Please enter correct choice! :",10
len7 equ $-msg7


section .bss

char_buff resb 17
actl resq 1
ans resq 1
x resb 1
cnt resb 1
choice resb 2

section .text

global _start
_start:

print_menu:
WRITE menu,menulen
READ choice,2
cmp byte[choice],31H
je bth
cmp byte[choice],32H
je htb
cmp byte[choice],33H
je exit

WRITE msg7,len7
jmp print_menu

bth: WRITE msg1,len1
READ char_buff,17
dec rax
mov[actl],rax

mov rax,00H
mov rsi,char_buff
mov rbx,0AH

up: mul rbx
mov rdx,00
mov dl, byte[rsi]
sub dl,30H
add rax,rdx

inc rsi
dec qword[actl]
jnz up

mov[ans],rax
WRITE msg2,len2
MOV rbx,[ans]
call display
jmp print_menu


htb:
WRITE msg3,len3
READ char_buff,17
call accept
mov byte[cnt],00
mov rax,rbx


up1: mov rdx,00
mov rbx,0AH
div rbx
push rdx
inc byte[cnt]
cmp rax,00
jnz up1

WRITE msg4,len4
up2: pop rdx
add dl,30H
mov byte[x],dl
WRITE x,01
dec byte[cnt]
jnz up2
jmp print_menu


exit : mov rax,60
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
