%% Hilbert transformer
clear, clc, close all

L = 31;
M = L -1;

n = -M/2:M/2;
hd = 2/pi*((sin(pi*n/2)).^2)./n;
hd(n == 0) = 0;

hwin = hd.*hamming(M+1).';

freqz(hwin, 1)


hpm = firpm(M, [0.1 0.9], [1 1], 'hilbert');
figure, freqz(hpm, 1)