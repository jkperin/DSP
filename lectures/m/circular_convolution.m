%% Calculation of convolution
clear, clc, close all
addpath('C:\Users\Joe\Dropbox\research\codes\f')

triang = @(x, N) (1/N)*(x + N).*double(x <= 0 & x >= -N) + (1/N)*(-x + N).*double(x > 0 & x <= N);
rect = @(x, N) double(x >= 0 & x < N);

N = 5;
Ns = 10;
P = 5;
n1 = 0:Ns-1;
n2 = 0:P-1;

x = zeros(size(n1));
y = zeros(size(n2));
for k = 0
    x = x + triang(n1 + k*Ns-N, N);
    y = y + rect(n2 + k*Ns, N);
end

figure, subplot(311)
stem(n1, x);

subplot(312)
stem(n2, y);

subplot(313), hold on
z =conv(x, y, 'full');
stem(0:length(z)-1, z);

n2 = 0:Ns+4-1;
y2 = ifft(fft(x, Ns+4).*fft(y, Ns+4));
stem(n2, y2, 'x');

% figure, 
% %plot(0:length(z)-1, z)
% plot(n2, y2, 'x');
% m = matlab2tikz(gca);
% m.write('circ_conv.tex')



