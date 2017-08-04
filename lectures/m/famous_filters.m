%% Comparison of famous filters
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

N = 6;
wc = pi/2;
Rp = 1;
ws = 1.15*wc;
Rs = 30;
T = 1;

[num_butter, den_butter] = butter(N, wc/pi);
[num_cheby1, den_cheby1] = cheby1(N, Rp, wc/pi);
[num_cheby2, den_cheby2] = cheby2(N, Rs, ws/pi);
[num_ellip, den_ellip] = ellip(N, Rp, Rs, wc/pi);

%
wc2wo = 1.621597623980423;
wow = wc2wo*wc;
[nums, dens] = besself(N, wow); % design prototype in CT with frequency prewarped           
[num_bessel, den_bessel] = bilinear(nums, dens, 1/T, wc/(2*pi));

%
[H_butter, w] = freqz(num_butter, den_butter);
H_cheby1 = freqz(num_cheby1, den_cheby1, w);
H_cheby2 = freqz(num_cheby2, den_cheby2, w);
H_ellip = freqz(num_ellip, den_ellip, w);
H_bessel = freqz(num_bessel, den_bessel, w);

% Pole-zero
figure, zplane(num_butter, den_butter)
figure, zplane(num_cheby1, den_cheby1)
figure, zplane(num_cheby2, den_cheby2)
figure, zplane(num_ellip, den_ellip)
figure, zplane(num_bessel, den_bessel)

figure, hold on, box on
plot(w/pi, 20*log10(abs(H_butter)), 'LineWidth', 2, 'displayName', 'Butterworth')
plot(w/pi, 20*log10(abs(H_cheby1)), 'LineWidth', 2, 'displayName', 'Chebyshev I')
plot(w/pi, 20*log10(abs(H_cheby2)), 'LineWidth', 2, 'displayName', 'Chebyshev II')
plot(w/pi, 20*log10(abs(H_ellip)), 'LineWidth', 2, 'displayName', 'Elliptical')
plot(w/pi, 20*log10(abs(H_bessel)), 'LineWidth', 2, 'displayName', 'Bessel')
plot([0 1], [-3 -3], '--k')
axis([0 1 -40 0])
legend('-dynamiclegend')
m = matlab2tikz(gca);
m.write_tables('../figs/data/classic_filters_mag')


figure, hold on, box on
plot(w/pi, unwrap(angle(H_butter)), 'LineWidth', 2, 'displayName', 'Butterworth')
plot(w/pi, unwrap(angle(H_cheby1)), 'LineWidth', 2, 'displayName', 'Chebyshev I')
plot(w/pi, unwrap(angle(H_cheby2)), 'LineWidth', 2, 'displayName', 'Chebyshev II')
plot(w/pi, unwrap(angle(H_ellip)), 'LineWidth', 2, 'displayName', 'Elliptical')
plot(w/pi, unwrap(angle(H_bessel)), 'LineWidth', 2, 'displayName', 'Bessel')
legend('-dynamiclegend')
m = matlab2tikz(gca);
m.write_tables('../figs/data/classic_filters_phase')
