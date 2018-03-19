#include <stdio.h>
#include <fstream>

using namespace std;

int main()
{
    unsigned char key_length = 4;
    unsigned char key[] = {97, 98, 99, 100};
    unsigned char sBox[256] = {0};

    unsigned int i = 0; 
    for (i = 0; i <= 255; i++)
    {
        sBox[i] = i;
    }

    // KSA
    unsigned int j = 0;
    for (i = 0; i <= 255; i++) 
    {
        j = (j + sBox[i] + key[i % key_length]) % 256;
        int temp = sBox[i];
        sBox[i] = sBox[j];
        sBox[j] = temp;
        printf("%d\t", j);
    }

    printf("after KSA: \n");
    for (int i = 0; i < 256; i++) {
        printf("%d\t", sBox[i]);
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
        int sk = (sBox[i] + sBox[j]) % 256;
        printf("%d\n", sBox[sk]);
    }
    return 0;
}