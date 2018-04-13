%% Periodogram example
clear, clc, close all

N_avg = 100;                % number of times to average periodogram. 
% If N_avg = 1, then it corresponds to calling the periodogram only once
L = 1024;                  % sequence length
Nfft = 1024;
b = [1 0 -1];              % filter coefficients

% Window
win = ones(L, 1);        % rectangular
% win = kaiser(L, 6);        % kaiser

U = mean(abs(win).^2)      % average power of the window

%% Theoretical calculations
% Theoretical average of the periodogram
% in average, the periodogram is the PSD x[n], smeared by the deterministic PSD of the window
dw = 2*pi/Nfft;
w = -pi:dw:pi-dw;
w_ext = -2*pi+dw:dw:2*pi-dw;    % extended frequency vector for convolution calculation

% Theoretical PSD
Ptheory = 4*(sin(w)).^2;        % theoretical PSD

% Average periodogram
Win = freqz(win, 1, w_ext);     % frequency response of the window
Pmean = 1/(2*pi*L*U)*conv(Ptheory, abs(Win).^2, 'same')*dw;

%% Periodogram
x = randn(L, N_avg);               % white noise with unit average power. Each column is a different noise realization
y = filter(b, 1, x, [0 0], 1);              % filters each column individually

% Periodogram calculation
% Pw = 1/(L*U)*abs(fft(y.*win, Nfft, 1)).^2; % Calculates FFT of each column of y.*win

% Using Matlab's periodogram function
Pw = 2*pi*periodogram(y, win, w.');          % Calculates periodogram of each column of y individually
% Note: 2*pi corrects for Matlab convention

% Averages N_avg periodograms
Pw = mean(Pw, 2);                 

%% Plot results
figure, hold on, box on
plot(w/pi, 10*log10(Pw), 'Linewidth', 1, 'displayname', 'Periodogram')
plot(w/pi, 10*log10(Ptheory), 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
plot(w/pi, 10*log10(Pmean), '--b', 'Linewidth', 2, 'displayname', 'Theoretical mean periodogram')
axis([0 1 -50 20])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (dB)', 'FontSize', 12)
legend('-dynamiclegend')

figure, hold on, box on
plot(w/pi, Pw, 'Linewidth', 1, 'displayname', 'Periodogram')
plot(w/pi, Ptheory, 'r', 'Linewidth', 2, 'displayname', 'Theoretical PSD')
plot(w/pi, Pmean, '--b', 'Linewidth', 2, 'displayname', 'Theoretical mean periodogram')
xlim([0 1])
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD (linear units)', 'FontSize', 12)
legend('-dynamiclegend')
