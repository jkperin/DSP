clear, clc, close all

%addpath('C:\Users\Joe\Dropbox\research\codes\f')

k = 1:4;
ck = 0.95*exp(1j*(0.15*pi+0.02*pi*k));
z = [0.98*exp(1j*0.8*pi) 0.98*exp(-1j*0.8*pi) 1./ck 1./ck 1./conj(ck) 1./conj(ck)].';
p = [0.8*exp(1j*0.4*pi) 0.8*exp(-1j*0.4*pi) ck ck conj(ck) conj(ck)].';

zplane(z, p)

%m = matlab2tikz(gca, true);
% m.write('../figs/group_delay_example.tex')

b = conv([1 -0.98*exp(1j*0.8*pi)], [1, -0.98*exp(-1j*0.8*pi)]);
for k =1:length(ck)
%     b = conv(conv(b, [conj(ck(k)) -1]), [ck(k) -1]);
%     b = conv(conv(b, [conj(ck(k)) -1]), [ck(k) -1]);
    e = conv([abs(ck(k)).^2 -2*real(ck(k)) 1], [abs(ck(k)).^2 -2*real(ck(k)) 1]);
    b = conv(b, e);
end

a = conv([1 -0.8*exp(1j*0.4*pi)], [1, -0.8*exp(-1j*0.4*pi)]);
for k = 1:length(ck)
%     a = conv(conv(a, [1 -conj(ck(k))]), [1 -ck(k)]);
%     a = conv(conv(a, [1 -conj(ck(k))]), [1 -ck(k)]);
    a = conv(a, [1 -2*real(ck(k)) abs(ck(k))^2]);
    a = conv(a, [1 -2*real(ck(k)) abs(ck(k))^2]);
end


% [b, a] = zp2tf(z, p, prod(abs(ck).^2));
% b = b(end:-1:1);
% a = a(end:-1:1);
b = b/3;
[z2, p2] = tf2zpk(b, a)

figure
zplane(z2, p2)

figure
[H, w] = freqz(b, a, 100, 'whole');

H = fftshift(H);
w = linspace(-pi, pi, 100);

figure, plot(w/pi, abs(H))
figure, plot(w/pi, deg2rad(unwrap(angle(H))))

