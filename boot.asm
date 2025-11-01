 org 0x7C00   ; add 0x7C00 to label addresses
   mov ah, 0
   mov al, 3
   int 0x10
   mov ax, 0  ; set up segments
   mov ds, ax
   mov es, ax
   mov ss, ax     ; setup stack
   mov sp, 0x7C00 ; stack grows downwards from 0x7C00
   mov bp, sp
   mov si, welcome
   call print_string
 
 mainloop:
   mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0  ; blank line?
   je mainloop       ; yes, ignore it
 
   mov si, buffer
   mov di, cmd_help  ; "help" command
   call strcmp
   jc .help
 
   mov si, buffer
   mov di, cmd_desc
   call strcmp
   jc .desc

   mov si, buffer
   mov di, cmd_quit
   call strcmp
   jc .quit

   mov si, buffer
   call isecho
   jc .echo

   mov si,badcommand
   call print_string 
   jmp mainloop
 
 .help:
   mov si, msg_help
   call print_string
   jmp mainloop
 .desc:
   mov si, msg_desc
   call print_string
   jmp mainloop
 .quit:
   mov ax, 0x5307
   mov bx, 0x0001
   mov cx, 0x0003
   int 0x15
   jmp mainloop
 .echo:
   mov si, buffer
   add si, 5
   call print_string
   mov al, 0x0d
   int 0x10
   mov al, 0x0a
   int 0x10
   jmp mainloop
 
 welcome db "MiniCMD v0.2!", 0x0D, 0x0A, 0
 badcommand db "!", 0x0D, 0x0A, 0
 prompt db "> ", 0
 cmd_help db "help", 0
 cmd_desc db "desc", 0
 cmd_quit db "quit", 0
 msg_help db "help, desc (prints desc), quit (turn off), echo (print str)", 0x0D, 0x0A, 0
 msg_desc db "DOS-like OS", 0x0D, 0x0A, 0
 buffer times 64 db 0
 
 ; ================
 ; calls start here
 ; ================
 
 print_string:
   lodsb
   or al, al
   jz .done
   mov ah, 0x0e
   int 0x10
   jmp print_string
 .done:
   ret
 
 get_string:
   xor cl, cl
 
 .loop:
   mov ah, 0
   int 0x16   ; wait for keypress
 
   cmp al, 0x08    ; backspace pressed?
   je .backspace   ; yes, handle it
 
   cmp al, 0x0D  ; enter pressed?
   je .done      ; yes, we're done
 
   cmp cl, 0x3F  ; 63 chars inputted?
   je .loop      ; yes, only let in backspace and enter
 
   mov ah, 0x0E
   int 0x10      ; print out character
 
   stosb  ; put character in buffer
   inc cl
   jmp .loop
 
 .backspace:
   cmp cl, 0	; beginning of string?
   je .loop	; yes, ignore the key
 
   dec di
   mov byte [di], 0	; delete character
   dec cl		; decrement counter as well
 
   mov ah, 0x0E
   mov al, 0x08
   int 10h		; backspace on the screen
 
   mov al, ' '
   int 10h		; blank character out
 
   mov al, 0x08
   int 10h		; backspace again
 
   jmp .loop	; go to the main loop
 
 .done:
   mov al, 0	; null terminator
   stosb
 
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10		; newline
 
   ret

 isecho:
  cmp byte [si], 'e'
  jne .notequal
  inc si
  cmp byte [si], 'c'
  jne .notequal
  inc si
  cmp byte [si], 'h'
  jne .notequal
  inc si
  cmp byte [si], 'o'
  jne .notequal
  inc si
  cmp byte [si], ' '
  jne .notequal
  jmp .equal
  .notequal:
    clc
    ret
  .equal:
    stc
    ret
 
 strcmp:
 .loop:
   mov al, [si]   ; grab a byte from SI
   mov bl, [di]   ; grab a byte from DI
   cmp al, bl     ; are they equal?
   jne .notequal  ; nope, we're done.
 
   cmp al, 0  ; are both bytes (they were equal before) null?
   je .done   ; yes, we're done.
 
   inc di     ; increment DI
   inc si     ; increment SI
   jmp .loop  ; loop!
 
 .notequal:
   clc  ; not equal, clear the carry flag
   ret
 
 .done: 	
   stc  ; equal, set the carry flag
   ret
 
   times 510-($-$$) db 0
   dw 0AA55h ; some BIOSes require this signature
