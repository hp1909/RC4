#include "iostream"
#include "fstream"

using namespace std;

int main() 
{
    int numberOfElements = 0;

    ofstream fileOut;
    fileOut.open("output.txt", ios::out);

    fileOut << "hello world" << endl;
    fileOut.close();

    ifstream fileIn;
    fileIn.open("input.txt");

    fileIn >> numberOfElements;

    int* a = new int[numberOfElements];

    for (int i = 0; i < numberOfElements; i++) 
    {
        int temp;
        fileIn >> temp;
        a[i] = temp;
    }

    for (int i = 0; i < numberOfElements; i++) 
    {
        cout << a[i] << "\t";
    }

    cout << endl;
    return 0;
}