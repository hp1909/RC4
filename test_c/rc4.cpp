#include <stdio.h>

int main()
{
    unsigned char key_length = 4;
    unsigned char key[] = {64, 63, 62, 61};
    unsigned char sBox[256] = {0};

    unsigned char i = 0; 
    for (i = 0; i <= 255; i++)
    {
        sBox[i] = i;
    }

    // KSA
    unsigned char j = 0;
    for (i = 0; i <= 255; i++) 
    {
        j = (j + sBox[i] + key[i]) % 256;
        int temp = sBox[i];
        sBox[i] = sBox[j];
        sBox[j] = temp;
    }

    // PRGA
    j = 0;
    printf("key value: \n");
    for (i = 0; i < key_length; i++) 
    {
        j = j + sBox[i];
        int temp = sBox[i];
        sBox[i] = sBox[j];
        sBox[j] = temp;
        int sk = sBox[i] + sBox[j];
        printf("%d\n", sk);
    }
    return 0;
}