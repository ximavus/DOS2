[org 0x7c00]
mainloop:
   mov si, prompt
   call print
 
   mov di, buffer
   call get_string
 
   cmp byte [buffer], 0
   je mainloop
 
   mov si, buffer
   mov di, cmd_help  ; The code for calling the help command
   call strcmp
   jc .help

   mov si, buffer
   mov di, cmd_quit ; The code for calling the quit command
   call strcmp
   jc .quit

   mov si, buffer
   mov di, cmd_graph ; The code for calling the graph command
   call strcmp
   jc .graph

   mov si, buffer
   add si, 4
   mov byte [si], 0
   sub si, 4
   mov di, cmd_echo ; The code for calling the echo command
   call strcmp
   jc .echo

   mov si, buffer
   mov di, cmd_cls ; The code for calling the cls command
   call strcmp
   jc .cls

   mov si, buffer
   mov di, cmd_info ; The code for calling the info command
   call strcmp
   jc .info

   mov si, badcmd
   call print ; Not a command!
   jmp mainloop
 
 .graph:
    mov ah, 0
    mov al, 0x13
    int 0x10
    mov ebx, 0xA0000
    .loop:
	xor ax, ax
	int 0x1A
	ror dx, 2
	add dx, cx
	mov word[ebx], dx
	inc ebx
	cmp ebx, 0xAFA00
	jng .loop
    mov cx, 0x0f
    mov dx, 0x4240
    mov ah, 0x86
    int 0x15
    mov ah, 0
    mov al, 0x3
    int 0x10
    jmp mainloop
 .cls:
    mov ah, 0x0
    mov al, 0x03
    int 0x10
    jmp mainloop
 .help:
   mov si, msg_help
   call print
   jmp mainloop
 .quit:
   mov ax, 0x5307
   mov bx, 0x0001
   mov cx, 0x0003
   int 0x15 ; Much easier than the last time I tried to make a poweroff function! Thank you BIOS!
   jmp mainloop
 .info:
   mov si, msg_info
   call print
   jmp mainloop
 .echo:
   mov si, buffer
   add si, 5
   call print
   mov al, 0x0d
   int 0x10
   mov al, 0x0a
   int 0x10
   jmp mainloop

bufsiz equ 30
badcmd db "!", 0x0D, 0x0A, 0
prompt db "> ", 0
cmd_cls db "cls", 0
cmd_help db "help", 0
cmd_quit db "quit", 0
cmd_graph db "graph", 0
cmd_info db "info", 0
cmd_echo db "echo", 0
cmd_run db "run", 0
msg_info db "A 512-byte OS. More info on github.com/ximavus/DOS2", 0x0A, 0x0D, 0
msg_help db "echo, graph, cls, help, quit, info", 0x0D, 0x0A, 0
buffer times bufsiz db 0

print:
   lodsb
   or al, al
   jz .done
   mov ah, 14
   int 0x10
   jmp print
   .done:
      ret
 
get_string:
   xor cl, cl
 .loop:
   mov ah, 0
   int 0x16
   cmp al, 0x08
   je .backspace
   cmp al, 0x0D
   je .done
   cmp cl, bufsiz-1
   je .loop 
   mov ah, 0x0e
   int 0x10
   stosb
   inc cl
   jmp .loop
 
 .backspace:
   or cl, 0
   jz .loop
   dec di
   mov byte [di], 0
   dec cl
   mov ah, 0x0E
   mov al, 0x08
   int 0x10
   mov al, ' '
   int 0x10
   mov al, 0x08
   int 0x10
   jmp .loop
 
 .done:
   mov al, 0
   stosb
   mov ah, 0x0e
   mov al, 0x0d
   int 0x10
   mov al, 0x0a
   int 0x10
   ret
 
 strcmp:
 .loop:
   mov al, [si]
   mov bl, [di]
   cmp al, bl
   jne .notequal
   cmp al, 0
   je .done
   inc di
   inc si
   jmp .loop
 .notequal:
   clc
   ret
 .done: 	
   stc
   ret
times 510-($-$$) db 0
dw 0xaa55
