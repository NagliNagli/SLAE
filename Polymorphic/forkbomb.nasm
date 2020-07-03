section .text

    global _start

_start:
	xor eax, eax
	inc eax
	inc eax
        push eax
   	pop eax
      	int 0x80
        jmp short _start
