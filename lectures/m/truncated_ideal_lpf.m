%% Plot frequency response of truncated sinc 
clear, clc, close all

% addpath('C:\Users\Joe\Dropbox\research\codes\f\')
addpath('D:\Jose\Dropbox\research\codes\f')

wc = pi/2;
w = linspace(-pi, pi, 200);

M = 7;
X1 = zeros(size(w));
for n = -M:M
    X1 = X1 + wc/pi*sinc(wc/pi*n)*exp(-1j*w*n);
end

M = 19;
X2 = zeros(size(w));
for n = -M:M
    X2 = X2 + wc/pi*sinc(wc/pi*n)*exp(-1j*w*n);
end

figure, hold on
%plot(w, real(X1))
plot(w, real(X2))

m = matlab2tikz(gca);
m.write('ideal_lpf_truncated.tex')
