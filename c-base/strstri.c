
char* strstri(char * inBuffer, char * inSearchStr)
{
    char*  currBuffPointer = inBuffer;

    while (*currBuffPointer != 0x00)
    {
        char* compareOne = currBuffPointer;
        char* compareTwo = inSearchStr;
        //统一转换为小写字符
        while (tolower(*compareOne) == tolower(*compareTwo))
        {
            compareOne++;
            compareTwo++;
            if (*compareTwo == 0x00)
            {
                return (char*) currBuffPointer;
            }

        }
        currBuffPointer++; 
    }
    return NULL;
}
