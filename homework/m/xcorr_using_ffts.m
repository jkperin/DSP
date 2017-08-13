%% xcorr with FFTs
clear, clc, close all

L = 1000;
x = randn(1, L);
y = filter(ones(1, 5)/5, 1, x);

N = 2*L-1;
cxy = xcorr(x, x);

Cxy = fftshift(ifft(fft(x, N).*conj(fft(x, N))));

figure, hold on
plot(-L+1:L-1, cxy)
plot(-L+1:L-1, Cxy, '--')
