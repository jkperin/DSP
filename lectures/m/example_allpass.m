%% All-pass example
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

b = conv(conv(conv([0.75 1], [-0.5 1]), [-0.8*exp(-1j*pi/4) 1]), [-0.8*exp(1j*pi/4) 1]);
a = conv(conv(conv([1 0.75], [1 -0.5]), [1 -0.8*exp(-1j*pi/4)]), [1 -0.8*exp(1j*pi/4)]);

zplane(b, a)

[H, w] = freqz(b, a, 50);

figure, plot(w/pi, rad2deg(unwrap(angle(H))))
m = matlab2tikz(gca);
m.write('phase_resp.tex')