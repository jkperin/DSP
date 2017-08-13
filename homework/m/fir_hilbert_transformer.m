%% Hilbert transformer
clear, clc, close all

% Define parameters
L = 31;
M = L -1;

%% a) Window method
n = -M/2:M/2;
hd = 2/pi*((sin(pi*n/2)).^2)./n;
hd(n == 0) = 0; % enforce value at 0

% window by Hamming window
hwin = hd.*hamming(M+1).';

[Hwin, w] = freqz(hwin, 1, 'whole');

figure, box on
plot(w/pi, abs(Hwin).^2, 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
saveas(gca, '../figs/hilbert_win_mag', 'epsc')

figure, box on
plot(w/pi, unwrap(angle(Hwin)), 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
saveas(gca, '../figs/hilbert_win_phase', 'epsc')

%% b) Parks-McClellan method
hpm = firpm(M, [0.1 0.9], [1 1], 'hilbert');
figure, freqz(hpm, 1)

[Hpm, w] = freqz(hpm, 1, 'whole');

figure, box on
plot(w/pi, abs(Hpm).^2, 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
saveas(gca, '../figs/hilbert_pm_mag', 'epsc')

figure, box on
plot(w/pi, unwrap(angle(Hpm)), 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
saveas(gca, '../figs/hilbert_pm_phase', 'epsc')

%% c) Least-squares method
hls = firls(M, [0.1 0.9], [1 1], 'hilbert');

[Hls, w] = freqz(hls, 1, 'whole');

figure, box on
plot(w/pi, abs(Hls).^2, 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
saveas(gca, '../figs/hilbert_ls_mag', 'epsc')

figure, box on
plot(w/pi, unwrap(angle(Hls)), 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
saveas(gca, '../figs/hilbert_ls_phase', 'epsc')