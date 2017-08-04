%% Comparison of famous filters
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

%% a) Design filters
N = 8;
wc = pi/2;
Rp = 2;
ws = 1.1*wc;
Rs = 30;
T = 1;

[num_butter, den_butter] = butter(N, wc/pi);
[num_cheby1, den_cheby1] = cheby1(N, Rp, wc/pi);
[num_cheby2, den_cheby2] = cheby2(N, Rs, ws/pi);
[num_ellip, den_ellip] = ellip(N, Rp, Rs, wc/pi);

%
[H_butter, w] = freqz(num_butter, den_butter);
H_cheby1 = freqz(num_cheby1, den_cheby1, w);
H_cheby2 = freqz(num_cheby2, den_cheby2, w);
H_ellip = freqz(num_ellip, den_ellip, w);

% Pole-zero
figure, zplane(num_butter, den_butter)
figure, zplane(num_cheby1, den_cheby1)
figure, zplane(num_cheby2, den_cheby2)
figure, zplane(num_ellip, den_ellip)

figure, hold on, box on
plot(w/pi, 20*log10(abs(H_butter)), 'LineWidth', 2, 'displayName', 'Butterworth')
plot(w/pi, 20*log10(abs(H_cheby1)), 'LineWidth', 2, 'displayName', 'Chebyshev I')
plot(w/pi, 20*log10(abs(H_cheby2)), 'LineWidth', 2, 'displayName', 'Chebyshev II')
plot(w/pi, 20*log10(abs(H_ellip)), 'LineWidth', 2, 'displayName', 'Elliptical')
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
legend('-dynamiclegend')
m = matlab2tikz(gca);
m.write_tables('../figs/data/classic_filters_phase')

%% b) Filter speech
% Load speech signal
[x_orig, Fs] = audioread('speech_dft.wav');          % Fs is sampling frequency
T = 1/Fs;                                       % sampling period

[L, M] = rat(8/22.05); % L is the umpsampling factor and M is the downsampling factor
Fs = 8e3;

x = L*decimate(upsample(x_orig, L), M);
% sound(x, Fs);

y_butter = filter(num_butter, den_butter, x);
y_cheby1 = filter(num_cheby1, den_cheby1, x);
y_cheby2 = filter(num_cheby2, den_cheby2, x);
y_ellip = filter(num_ellip, den_ellip, x);

% sound(y_cheby1, Fs)

h = fir1(21, 0.5);
y_fir = filter(h, 1, x);
sound(y_fir, Fs)


