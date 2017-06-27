%% Moving average output
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

w0 = 0.5*pi;

n = 0:20;
x = cos(w0*n);

y = filter([1 1 1 1]/4, 1, x);

figure
plot(n, x, 'o')
m = matlab2tikz(gca)
m.write('moving_avg4_input.tex')

figure
plot(n, y, 'o')
m = matlab2tikz(gca)
m.write('moving_avg4_output.tex')