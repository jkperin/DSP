%% Butterworth filter
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

b = 0.12093;
a = conv(conv([1 0.364 0.4945], [1 0.9925 0.4945]), [1 1.3385 0.4945]);

[Hs, O] = freqs(b, a);

Tfinal = 30;
dt = 0.25;
t = 0:dt:Tfinal;
H = tf(b, a);
h = impulse(H, t);

figure, hold on
plot(t, h)
%m = matlab2tikz(gca);
%m.write_tables('../figs/data/imp_invar_samples')

T = 1;
n = 0:T:24;
hz = T*interp1(t, h, n);
stem(n, hz)
m = matlab2tikz(gca);

% Frequency response
[Hz, w] = freqz(hz, 1, 300);

figure, hold on, box on
N = 4;
plot(O(1:N:end)*T/pi, 20*log10(abs(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, 20*log10(abs(Hz(1:N:end))), 'displayname', 'Hfir')
axis([0 1 -40 5])
%m = matlab2tikz(gca);
%m.write_tables('../figs/data/imp_invar_FIR_butter_fir_mag')

figure, hold on, box on
plot(O(1:N:end)*T/pi, unwrap(angle(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, unwrap(angle(Hz(1:N:end))), 'displayname', 'Hfir')
axis([0 1 -20 0])
%m = matlab2tikz(gca);
%m.write_tables('../figs/data/imp_invar_FIR_butter_fir_phase')

%% IIR
b1 = [0.2871 -0.4466];
a1 = [1 -1.2971 +0.6949];

b2 = [-2.1428 1.1455];
a2 = [1 -1.0691 0.3699];

b3 = [1.8557 -0.6303];
a3 = [1 -0.9972 +0.2570];

%
[H1, w] = freqz(b1, a1, 300);
H2 = freqz(b2, a2, w);
H3 = freqz(b3, a3, w);

Hiir = H1 + H2 + H3;

figure, hold on, box on
%plot(O(1:N:end)*T/pi, 20*log10(abs(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, 20*log10(abs(Hiir(1:N:end))), 'displayname', 'Hiir')
% m = matlab2tikz(gca);
% m.write_tables('../figs/data/imp_invar_IIR_butter_mag')

figure, hold on, box on
%plot(O(1:N:end)*T/pi, 20*log10(abs(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, unwrap(angle(Hiir(1:N:end))), 'displayname', 'Hiir')
% m = matlab2tikz(gca);
% m.write_tables('../figs/data/imp_invar_IIR_butter_phase')


H1 = tf(b1, a1, T, 'variable', 'z^-1');
H2 = tf(b2, a2, T, 'variable', 'z^-1');
H3 = tf(b3, a3, T, 'variable', 'z^-1');

Hz = H1 + H2 + H3;
[num,den] = tfdata(Hz) 
num = cell2mat(num);
den = cell2mat(den);

figure, zplane(num, den)
m = matlab2tikz(gca, 1);
m.write('../figs/imp_invar_butter_iir_pole_zero.tex')

