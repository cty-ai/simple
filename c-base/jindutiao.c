#include<stdio.h>
#include<unistd.h>
int main()
{
    int i = 0;
    char bar[70];
    const char *lable = "-\\|/";
    while (i <= 50)
    {
        printf("[%-50s][%d%%][%c]\r\r", bar, i*2, lable[i % 4]);
        fflush(stdout);
        bar[i] = '=';
                i++;
        bar[i] = 0;
        usleep(1000000);
    }
    printf("\n");
    return 0;
}
