%% convolve gaussian with rectangular function
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

x = linspace(-5, 5, 51);
% x = -5:5;
dx = abs(x(1)-x(2));

y = 1/sqrt(2*pi)*exp(-x.^2/2);
r = zeros(size(x));
r(x >= -0.5 & x <= 0.5) = 1;

y2 = dx*conv(y, r, 'same');

figure, plot(x, y2, x, y);
% m = matlab2tikz(gca);
% m.write('gauss_conv_rect.tex')