
;Name - Mohit Jaiswal
;Batch - A3
;Roll No. - 57
;Practical no. - 4

%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 02
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
	msg1 db 10," Enter 1st String : ",10
	len1 equ $-msg1
	msg2 db " Enter 2nd String : ",10
	len2 equ $-msg2
	msg3 db " Wrong Choice !!! ",10
	len3 equ $-msg3
	msg4 db " Length is : ",10
	len4 equ $-msg4
	msg5 db " Copied string is : ",10
	len5 equ $-msg5
	msg6 db " Concatinated string is : ",10
	len6 equ $-msg6
	msg7 db " Reversed string is : ",10
	len7 equ $-msg7
	msg8 db " Strings are Equal !! ",10
	len8 equ $-msg8
	msg9 db " Strings are not Equal !! ",10
	len9 equ $-msg9
	msg10 db " String is Palindrome ",10
	len10 equ $-msg10
	msg11 db " String is not Palindrome ",10
	len11 equ $-msg11
	msg12 db " Substring is Present ",10
	len12 equ $-msg12
	msg13 db " Substring is not present ",10
	len13 equ $-msg13
	
	menu db 10,"*********** MENU ***********",10
	     db " 1. String Length ",10
	     db " 2. String Copy ",10
	     db " 3. String Concatination ",10
	     db " 4. String Reverse ",10
	     db " 5. String Compare ",10
	     db " 6. Check Palindrome ",10
	     db " 7. Substring Occurence ",10
	     db " 8. Exit ",10
	     db " Enter your Choice : ",10
	len equ $-menu
	
section .bss
	str1 resb 20
	str2 resb 20
	str3 resb 40
	l1 resq 1
	l2 resq 1
	l3 resq 1
	char_buff resb 16
	choice resb 02
	
section .text
	global _start
	
_start:WRITE msg1,len1
	READ str1,20
	dec rax
	mov [l1],rax
	
printmenu:WRITE menu,len
	READ choice,02
	
	cmp byte[choice],31H
	je strlen
	cmp byte[choice],32H
	je strcpy
	cmp byte[choice],33H
	je strcati
	cmp byte[choice],34H
	je strrev
	cmp byte[choice],35H
	je strcmpa
	cmp byte[choice],36H
	je strpal
	cmp byte[choice],37H
	je strsub
	cmp byte[choice],38H
	je exit
	
	WRITE msg3,len3
	jmp printmenu
	
strlen:WRITE msg4,len4
	mov rbx,[l1]
	call display
	jmp printmenu
	
strcpy:mov rsi,str1
	mov rdi,str2
	mov rcx,[l1]
	cld
	rep movsb
	WRITE msg5,len5
	WRITE str2,qword[l1]
	jmp printmenu
	
strcati:WRITE msg2,len2
	READ str2,20
	dec rax
	mov [l2],rax
	mov rsi,str1
	mov rdi,str3
	mov rcx,[l1]
	cld
	rep movsb
	mov rsi,str2
	mov rcx,[l2]
	rep movsb
	mov rbx,[l1]
	add rbx,[l2]
	mov [l3],rbx
	WRITE msg6,len6
	WRITE str3,qword[l3]
	jmp printmenu
	
strrev:mov rsi,str1
	mov rdi,str2
	add rdi,[l1]
	dec rdi
	
	mov rcx,[l1]
	
    up:mov bl,byte[rsi]
    	mov byte[rdi],bl
    	inc rsi
    	dec rdi
    	dec rcx
    	jnz up
    	
    	WRITE msg7,len7
    	WRITE str2,qword[l1]
    	jmp printmenu
    	
strcmpa:WRITE msg2,len2
	READ str2,20
	dec rax
	mov [l2],rax
	
	mov rbx,[l1]
	cmp rbx,[l2]
	jne notequal
	
	mov rsi,str1
	mov rdi,str2
	mov rcx,[l1]
	cld
	repe cmpsb
	jne notequal
	WRITE msg8,len8
	jmp printmenu
	
notequal:WRITE msg9,len9
	jmp printmenu
	
strpal:mov rsi,str1
	mov rdi,str2
	add rdi,[l1]
	dec rdi
	
	mov rcx,[l1]
    up3:mov bl,byte[rsi]
    	mov byte[rdi],bl
    	inc rdi
    	dec rdi
    	dec rcx
    	jnz up3
    	
    	mov [l2],rax
    	
    	mov rsi,str1
    	mov rdi,str2
    	mov rcx,[l1]
    	cld
    	repe cmpsb
    	jne not_equal
    	WRITE msg10,len10
    	jmp printmenu
    	
not_equal:WRITE msg11,len11
	jmp printmenu
    	
    	
strsub:WRITE msg2,len2
	READ str2,20
	dec rax
	mov [l2],rax
	
	mov rsi,str1
	mov rdi,str2
	mov rbx,[l1]
	mov rcx,[l2]
	mov dh,byte[rdi]
	
   up1:mov dl,byte[rsi]
   	cmp dl,byte[rdi]
   	je same
   	cmp byte[rsi],dh
   	je skip
   	inc rsi
   	dec rbx
   	
  skip:mov rdi,str2
  	mov rdx,[l2]
  	jmp skip1
  	
 same:inc rsi
 	inc rdi
 	dec rbx
 	dec rcx
 	
skip1:cmp rcx,00
	je present
	cmp rbx,00
	je notpresent
	jmp up1
	
present:WRITE msg12,len12
	jmp printmenu
	
notpresent:WRITE msg13,len13
	jmp printmenu
	
   exit:mov rax,60
	mov rdi,00
	syscall
	
display:mov rsi,char_buff
	mov rcx,16
	
   up2:rol rbx,04H
   	mov dl,bl
   	and dl,0FH
   	cmp dl,09H
   	jbe add30
   	add dl,07H
   	
 add30:add dl,30H
 	mov byte[rsi],dl
 	inc rsi
 	dec rcx
 	jnz up2
 	WRITE char_buff,16
 	ret
  	

