%% Blackman-Tukey method of estimating the PSD
clear, clc, close all

Q = 2048;                   % sequence length
M = 512;                     % maxLag in autocorrelation estimate
L = 2*M-1;                   % window length 
b = [1 1 1 1 1 1]/6;                % filter coefficients

% Window
% win = ones(L, 1);        % rectangular
win = bartlett(L);        % Bartlett

%% Theoretical calculations
% Theoretical average of the periodogram
% in average, the periodogram is the PSD x[n], smeared by the deterministic PSD of the window
dw = 2*pi/L;
w = -pi:dw:pi-dw;
w_ext = -2*pi:dw:2*pi-dw;

% Theoretical PSD
% Ptheory = 4*(sin(w)).^2;        % theoretical PSD
Ptheory = abs(freqz(b, 1, w)).^2;

% Mean estimate
Win = freqz(win, 1, w_ext);     % frequency response of the window
Win = Win.*exp(1j*w_ext*(M-1)); % window is centered at zero;
Pmean = 1/(2*pi)*conv(Ptheory, Win, 'same')*dw;

%% Blackman-Tukey method
x = randn(Q, 1);             % Generates white noise with unit average power
y = filter(b, 1, x);            % Filter

Pw = blackman_tukey_psd(y, win, M);

%% Plot results
figure, hold on, box on
plot(w/pi, 10*log10(Pw), 'Linewidth', 1, 'displayname', 'Measured')
plot(w/pi, 10*log10(Ptheory), 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
plot(w/pi, 10*log10(Pmean), '--b', 'Linewidth', 2, 'displayname', 'Mean PSD')
axis([0 1 -50 20])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (dB)', 'FontSize', 12)
legend('-dynamiclegend')

figure, hold on, box on
plot(w/pi, Pw, 'Linewidth', 1, 'displayname', 'Measured')
plot(w/pi, Ptheory, 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
plot(w/pi, Pmean, '--b', 'Linewidth', 2, 'displayname', 'Mean PSD')
xlim([0 1])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (linear units)', 'FontSize', 12)
legend('-dynamiclegend')
