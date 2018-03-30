%--------------------------------------------------------------------------
%   NAME:   rc4.m
%   Author: Hoang Phuc Nguyen - intern
%   Date:   19th Mar, 2018
%   Description: Use this script to test simulation result made by modelsim
%--------------------------------------------------------------------------


a = '../data/output.txt';
fileOut  = fopen(a, 'w');
fileIn   = fopen('../data/input.txt', 'w');

% A = fscanf(fileIn, '%x')'
keyLength = length;
% keyLength = A(1)
% key = A(2:A(1) + 1)

fprintf(fileIn, "%x\n", length);
key = randi(255, length, 1);

for i=1:length
   fprintf(fileIn, "%x\n", key(i)); 
end

for i = 0:255
   sBox(i + 1) = i;
end

j = 0;

for i = 0:255
   j = mod(j + sBox(i + 1) + key(mod(i, keyLength) + 1), 256)
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
    fprintf(fileOut, "%x\n", Ckey(n + 1));
    n = n + 1;
end