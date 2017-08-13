%% Comparison of famous filters
clear, clc, close all

%% a) Design filters
N = 8;                      % filter order
wc = pi/2;                  % cutoff frequency wc = 2pi*4/16 = pi/2
Rp = 1;                     % pass-band ripple
ws = 1.1*wc;                % stopband edge frequency to achieve wc = 4 kHz
Rs = 30;                    % stopband attenuation
T = 1/16e3;                 % sampling period

% Design filters
[num_butter, den_butter] = butter(N, wc/pi);
[num_cheby1, den_cheby1] = cheby1(N, Rp, wc/pi);
[num_cheby2, den_cheby2] = cheby2(N, Rs, ws/pi);
[num_ellip, den_ellip] = ellip(N, Rp, Rs, wc/pi);

% Frequency response
[H_butter, w] = freqz(num_butter, den_butter);
H_cheby1 = freqz(num_cheby1, den_cheby1, w);
H_cheby2 = freqz(num_cheby2, den_cheby2, w);
H_ellip = freqz(num_ellip, den_ellip, w);

% Pole-zero
figure, zplane(num_butter, den_butter)
figure, zplane(num_cheby1, den_cheby1)
figure, zplane(num_cheby2, den_cheby2)
figure, zplane(num_ellip, den_ellip)

% Plot results
figure, hold on, box on
plot(w/(2*pi*T)*1e-3, 20*log10(abs(H_butter)),...
    'LineWidth', 2, 'displayName', 'Butterworth')
plot(w/(2*pi*T)*1e-3, 20*log10(abs(H_cheby1)),...
    'LineWidth', 2, 'displayName', 'Chebyshev I')
plot(w/(2*pi*T)*1e-3, 20*log10(abs(H_cheby2)),...
    'LineWidth', 2, 'displayName', 'Chebyshev II')
plot(w/(2*pi*T)*1e-3, 20*log10(abs(H_ellip)),...
'LineWidth', 2, 'displayName', 'Elliptic')
plot([0 1e-3/T], [-3 -3], '--k', 'DisplayName', '-3 dB')
xlabel('Frequency (kHz)')
ylabel('Magnitude (dB)')
axis([0 0.5e-3/T -40 0])
legend('-dynamiclegend')
saveas(gca, '../figs/classic_filters_mag', 'epsc')

figure, hold on, box on
plot(w/(2*pi*T)*1e-3, unwrap(angle(H_butter)),...
    'LineWidth', 2, 'displayName', 'Butterworth')
plot(w/(2*pi*T)*1e-3, unwrap(angle(H_cheby1)),...
    'LineWidth', 2, 'displayName', 'Chebyshev I')
plot(w/(2*pi*T)*1e-3, unwrap(angle(H_cheby2)),...
    'LineWidth', 2, 'displayName', 'Chebyshev II')
plot(w/(2*pi*T)*1e-3, unwrap(angle(H_ellip)),...
    'LineWidth', 2, 'displayName', 'Elliptic')
legend('-dynamiclegend', 'Location', 'SouthWest')
xlabel('Frequency (kHz)')
ylabel('Magnitude (dB)')
axis([0 0.5e-3/T -12 0])
saveas(gca, '../figs/classic_filters_phase', 'epsc')

%% b) Filter speech
% Load speech signal
[x_orig, Fs] = audioread('speech_dft.wav');          % Fs is sampling frequency
T = 1/Fs;                                            % sampling period

% Express 16/22.05 as fraction L/M
[L, M] = rat(16/22.05); % L is the umpsampling factor and M is the downsampling factor
       
%% Upsampling followed by decimation.
% Note that the lowpass filter between the upsampling and downsampling 
% stages must have gain L. However, the lowpass filter prior to 
% downsampling in decimation (and in the decimate function) has gain 1.
% Therefore, we must scale the result by L
% For more details, refer to slide 30 of lecture notes 4.
x = L*decimate(upsample(x_orig, L), M);
Fs = 16e3;  % Sampling rate after upsampling/decimation

y_butter = filter(num_butter, den_butter, x);
y_cheby1 = filter(num_cheby1, den_cheby1, x);
y_cheby2 = filter(num_cheby2, den_cheby2, x);
y_ellip = filter(num_ellip, den_ellip, x);

sound(y_ellip, Fs) % play sound after filtering


