#include <stdio.h>
#include <iostream>
#include <fstream>

using namespace std;

int main()
{
    ifstream fileIn;
    ofstream fileOut;
    int keyLength = 0;
    
    // read file from input.txt
    fileIn.open("input.txt");

    fileIn >> keyLength;
    cout << "key length: " << keyLength << endl;

    int *key = new int[keyLength];
    for (int i = 0; i < keyLength; i++)
    {
        int temp;
        fileIn >> temp;
        cout << temp << endl;
        key[i] = temp;
    }
    fileIn.close();

    fileOut.open("output.txt", ios::out);
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
        j = (j + sBox[i] + key[i % keyLength]) % 256;
        int temp = sBox[i];
        sBox[i] = sBox[j];
        sBox[j] = temp;
        printf("%d\t", j);
        fileOut << (int)j << "\t";
        if (i % 10 == 0) 
        {
            fileOut << endl;
        }
    }
    fileOut << endl;

    printf("after KSA: \n");
    fileOut << "after KSA:" << endl;
    for (int i = 0; i < 256; i++) {
        printf("%d\t", sBox[i]);
        fileOut << (int)sBox[i] << "\t";
        if (i % 10 == 0) 
        {
           fileOut << endl;
        }
    }

    fileOut << endl;
    // PRGA
    j = 0;
    printf("key value: \n");
    fileOut << "Key value: " << endl;
    for (i = 1; i < keyLength + 1; i++) 
    {
        j = (j + sBox[i]) % 256;
        int temp = sBox[i];
        sBox[i] = sBox[j];
        sBox[j] = temp;
        int sk = (sBox[i] + sBox[j]) % 256;
        printf("%d\n", sBox[sk]);
        fileOut << (int)sBox[sk] << endl;
        if (i % 10 == 0) 
        {
            fileOut << endl;
        }
    }
    fileOut.close();
    return 0;
}