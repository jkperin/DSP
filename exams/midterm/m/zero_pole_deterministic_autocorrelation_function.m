%% Zero-pole diagram of deterministic autocorrelation function
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

b = conv([1 -1.25*exp(1j*3*pi/4)], [1 -1.25*exp(-1j*3*pi/4)]);
a = conv([1 -0.8*exp(1j*pi/4)], [1 -0.8*exp(-1j*pi/4)]);
b = sum(a)/sum(b)*b;

figure, zplane(b, a)
m = matlab2tikz(gca, 1);
m.write('zplane.tex')

[H, w] = freqz(b, a);
figure
plot(w/pi, 20*log10(abs(H)))
m = matlab2tikz(gca);
m.write('mag.tex')

z = roots(b)
p = roots(a)

1./conj(z)
1./conj(p)

b2 = conv(conv([1 -1.25*exp(1j*3*pi/4)], [1 -1.25*exp(-1j*3*pi/4)]), ...
    conv([1 -1/1.25*exp(-1j*3*pi/4)], [1 -1/1.25*exp(1j*3*pi/4)]));

a2 = conv(conv([1 -0.8*exp(1j*pi/4)], [1 -0.8*exp(-1j*pi/4)]),...
    conv([1 -1/0.8*exp(-1j*pi/4)], [1 -1/0.8*exp(1j*pi/4)]));
b2 = sum(a2)/sum(b2)*b2;

figure, zplane(b2, a2)

H2 = freqz(b2, a2, w)

figure(2), hold on
plot(w/pi, 10*log10(abs(H2)), '--r')