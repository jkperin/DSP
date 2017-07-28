%% Butterworth filter
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

b = 0.12093;
a = conv(conv([1 0.364 0.4945], [1 0.9925 0.4945]), [1 1.3385 0.4945]);

[Hs, O] = freqs(b, a);

%% Bilinear
T = 2;
[bz, az] = bilinear(b, a, 1/T);
[Hz, w] = freqz(bz, az);

figure, hold on, box on
N = 4;
plot(O(1:N:end)*T/pi, 20*log10(abs(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, 20*log10(abs(Hz(1:N:end))), 'displayname', 'Hbi')
axis([0 1 -40 5])
m = matlab2tikz(gca);
% m.write_tables('../figs/data/bilinear_butter_mag_prewarp')
% m.write_tables('../figs/data/bilinear_butter_mag_T2')

figure, hold on, box on
plot(O(1:N:end)*T/pi, unwrap(angle(Hs(1:N:end))), 'displayname', 'Hc')
plot(w(1:N:end)/pi, unwrap(angle(Hz(1:N:end))), 'displayname', 'Hbi')
axis([0 1 -20 0])
m = matlab2tikz(gca);
% m.write_tables('../figs/data/bilinear_butter_phase_prewarp')
% m.write_tables('../figs/data/bilinear_butter_phase_T2')

figure, zplane(bz, az)
m = matlab2tikz(gca, 1);
m.write('../figs/bilinear_butter_pole_zero.tex')
