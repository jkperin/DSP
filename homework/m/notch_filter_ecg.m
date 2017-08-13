%% Template for notch filtering of ECG signals
clear, clc, close all

%% Loads ECG signal from file
% This loads the following variables:
% - ecg_clean: ecg_signal without 60 Hz interference. Use this only for
% comparison
% - ecg_60Hz: ECG signal corrupted by 60 Hz interference
% - N: length of the vectors ecg_clean and ecg_60Hz
% - T (in seconds): sampling period of ECG recordings. T = 3 ms.
load('ecg_recording.mat') 
% Note: these signals are real ECG recordings made with standard ECG recorders, 
% leads, and electrodes. The quality is typical of ambulatory ECG recordings.
% The 60 Hz component was introduced artificially for this exercise.
% The complete database can be found online on PhysioNet [1]: 
% http://www.physionet.org/physiobank/database/nstdb/
% This database is discrebed in [2].
% References:
% [1] Goldberger AL, Amaral LAN, Glass L, Hausdorff JM, Ivanov PCh, Mark RG, 
% Mietus JE, Moody GB, Peng C-K, Stanley HE. PhysioBank, PhysioToolkit, and 
% PhysioNet: Components of a New Research Resource for Complex Physiologic 
% Signals. Circulation 101(23):e215-e220 [Circulation Electronic Pages; 
% http://circ.ahajournals.org/content/101/23/e215.full]; 2000 (June 13).
% [2] Moody GB, Muldrow WE, Mark RG. A noise stress test for arrhythmia detectors. 
% Computers in Cardiology 1984; 11:381-384.

t = 0:T:(N-1)*T; % time vector

% Plot signals
figure, box on, hold on
plot(t, ecg_clean, 'k')
plot(t, ecg_60Hz)
xlabel('Time (s)')
ylabel('ECG')
legend('Clean ECG', 'ECG corrupted by 60 Hz')

%% Your code goes here
% a)
lamb = 2*pi*60;
b = 2*pi*5; % there's more than one right answer for this.

% Analog notch filter coefficients
bs = [1 0 lamb^2];
as = [1 b lamb^2];

% b)
% Bilinear transformation with and without frequency pre-warping
[bzw, azw] = bilinear(bs, as, 1/T); % without
[bz, az] = bilinear(bs, as, 1/T, lamb/(2*pi)); % with

% c)
[Hw, w] = freqz(bzw, azw);
H = freqz(bz, az, w);

figure, hold on, box on
plot(w/(2*pi*T), 20*log10(abs(Hw)), 'Linewidth', 2', 'DisplayName', 'W/o frequency pre-warping')
plot(w/(2*pi*T), 20*log10(abs(H)), 'Linewidth', 2', 'DisplayName', 'W/ frequency pre-warping')
xlabel('Frequency (Hz)', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
set(gca, 'xtick', [60])
grid on
set(gca, 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/bilinear_ecg', 'epsc')

% d) 
figure, zplane(bz, az)
saveas(gca, '../figs/zplane_bilinear_ecg', 'epsc')

% e)
ecg_filtered = filter(bz, az, ecg_60Hz);

figure, hold on, box on
plot(t, ecg_60Hz, 'LineWidth', 2, 'DisplayName', 'ECG + 60 Hz')
plot(t, ecg_filtered, 'LineWidth', 2, 'DisplayName', 'Filtered ECG')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/ecg_comparison1', 'epsc')

figure, hold on, box on
plot(t, ecg_clean, 'LineWidth', 2, 'DisplayName', 'Clean ECG')
plot(t, ecg_filtered, '--', 'LineWidth', 2, 'DisplayName', 'Filtered ECG')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/ecg_comparison2', 'epsc')

% f)
% Define filter parameters
L = 53;
M = L-1;
Deltaw1 = 0.018*pi;
Deltaw2 = 0.04*pi;
N = 1000;

% Frequnecy vector
wc = 2*pi*60*T;
w = linspace(0, pi, N);

% Desired response
d = ones(size(w));
d(w >= wc-Deltaw1/2 & w <= wc+Deltaw1/2) = 0;

% Weight function
wv = ones(size(w));
wv(w >= wc-Deltaw1/2-Deltaw2 & w < wc-Deltaw1/2) = 0;
wv(w >= wc+Deltaw1/2 & w < wc+Deltaw1/2+Deltaw2) = 0;

% Plot desired response and window function
figure, hold on
plot(w, d)
plot(w, wv, 'r')
title('desired response and window function')

% Design the filter
hls = firls(M, w(wv ~= 0)/pi, d(wv ~= 0));

% Plot results
Hls = freqz(hls, 1, w);

ecg_fir =filter(hls, 1, ecg_60Hz);

figure, box on
plot(w/(2*pi*T), 20*log10(abs(Hls)), 'LineWidth', 2)
xlabel('Frequency (Hz)', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
set(gca, 'xtick', [60])
saveas(gca, '../figs/ecg_fir_notch', 'epsc')

figure, box on
plot(w/(2*pi*T), unwrap(angle(Hls)), 'LineWidth', 2)
xlabel('Frequency (Hz)', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
set(gca, 'xtick', [60])
saveas(gca, '../figs/ecg_fir_notch_phase', 'epsc')

figure, hold on, box on
plot(t, ecg_clean, 'LineWidth', 2, 'DisplayName', 'Clean ECG')
plot(t, ecg_fir, '--', 'LineWidth', 2, 'DisplayName', 'Filtered ECG')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/ecg_fir_comparison1', 'epsc')

figure, hold on, box on
plot(t, ecg_clean, 'LineWidth', 2, 'DisplayName', 'Clean ECG')
plot(t, circshift(ecg_fir, [0, -M/2]), '--', 'LineWidth', 2, 'DisplayName', 'Filtered ECG')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/ecg_fir_comparison2', 'epsc')
