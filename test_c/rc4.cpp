#include <stdio.h>

int main()
{
    char key_length = 4;
    char key[] = {64, 63, 62, 61};
    char sbox[256] = {0};

    int i = 0; 
    for (i = 0; i < 256; i++)
    {
        sbox[i] = i;
    }

    // KSA
    int j = 0;
    for (i = 0; i < 255; i++) 
    {
        j = j + sbox[i] + key[i];
        int temp = sbox[i];
        sbox[i] = sbox[j];
        sbox[j] = temp;
    }

    // PRGA
    j = 0;
    printf("key value: \n");
    for (i = 0; i < key_length; i++) 
    {
        j = j + sbox[i];
        int temp = sbox[i];
        sbox[i] = sbox[j];
        sbox[j] = temp;
        int sk = sbox[i] + sbox[j];
        printf("%d\n", sk);
    }
    return 0;
}