%--------------------------------------------------------------------------
%   NAME:   rc4.m
%   Author: Hoang Phuc Nguyen - intern
%   Date:   19th Mar, 2018
%   Description: Use this script to test simulation result made by modelsim
%--------------------------------------------------------------------------

clear all
clc
fileOut  = fopen('../output.txt', 'w');

keyLength = 4;
key = [97 98 99 100];

for i = 0:255
   sBox(i + 1) = i;
end

j = 0;

for i = 0:255
   j = mod(j + sBox(i + 1) + key(mod(i, keyLength) + 1), 256);
   temp = sBox(i + 1);
   sBox(i + 1) = sBox(j + 1);
   sBox(j + 1) = temp;
end

sBox

n = 0;
j = 0;

for i = 1: keyLength
    j = mod(j + sBox(i + 1), 256);
    temp = sBox(i + 1);
    sBox(i + 1) = sBox(j + 1);
    sBox(j + 1) = temp;
    k = mod(sBox(i + 1) + sBox(j + 1), 256);
    Ckey(n + 1) = sBox(k + 1);
    fprintf(fileOut, "%d\n", Ckey(n + 1));
    n = n + 1;
end