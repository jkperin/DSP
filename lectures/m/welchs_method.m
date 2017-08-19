%% Welch's method of estimating the PSD
clear, clc, close all

Ntot = 2048;                  % sequence length
L = 256;                      % window length 
Nfft = 256;                   % FFT size
R = 128;                      % block overlap
b = [1 0 1];                 % filter coefficients

% Window
% win = ones(L, 1);        % rectangular
win = kaiser(L, 6);        % kaiser

U = mean(abs(win).^2)      % average power of the window

%% Theoretical calculations
% Theoretical average of the periodogram
% in average, the periodogram is the PSD x[n], smeared by the deterministic PSD of the window
dw = 2*pi/Nfft;
w = -pi:dw:pi-dw;

% Theoretical PSD
% Ptheory = 4*(sin(w)).^2;        % theoretical PSD
Ptheory = abs(freqz(b, 1, w)).^2;

%% Welch's method
x = randn(Ntot, 1);             % Generates white noise with unit average power
y = filter(b, 1, x);            % Filter

% Calculate Welch's method estimate using function pwelch
Pw = 2*pi*pwelch(y, win, L-R, w);
% Note: by passing the frequency vector w defined from -pi to pi, forces
% matlab to generate two-sided PSD. Therefore, we should multiply by 2*pi
% to obtain Pw as defined in the lecture notes

% Calculate Welch's method estimate using function spectrogram
[s, f, t] = spectrogram(y, win, L-R, w);
Pw_spec = mean(1/(L*U)*abs(s).^2, 2);

%% Plot results
figure, hold on, box on
plot(w/pi, 10*log10(Pw), 'Linewidth', 1, 'displayname', 'Welch from pwelch')
plot(w/pi, 10*log10(Pw_spec), '--', 'Linewidth', 1, 'displayname', 'Welch from spectrogram')
plot(w/pi, 10*log10(Ptheory), 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
axis([0 1 -50 20])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (dB)', 'FontSize', 12)
legend('-dynamiclegend')

figure, hold on, box on
plot(w/pi, Pw, 'Linewidth', 1, 'displayname', 'Welch from pwelch')
plot(w/pi, Pw_spec, '--', 'Linewidth', 1, 'displayname', 'Welch from spectrogram')
plot(w/pi, Ptheory, 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
xlim([0 1])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (linear units)', 'FontSize', 12)
legend('-dynamiclegend')
