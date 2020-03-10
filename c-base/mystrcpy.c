#include <stdio.h>
char *mystrcpy(char *dest,const char *src)
{
    char *p=dest;
    while(*dest++ = *src++);
    return p;
}

char *mystrcat(char *dest,const char *src)
{
    char *p=dest;
    while(*dest++);
    dest--;

    while(*dest++=*src++);
    return p;
}

int main()
{
    char a[128]="asdfg";
    char *b="123";
    printf("%s",mystrcpy(a,b));
    printf("%s",mystrcat(a,b));
    getchar();
}