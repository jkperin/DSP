%% N-point DFT of cosine
clear, clc, close all

% Define variables
N = 21;                     % number of samples in DFT
n = 0:N-1;                  % discrete-time vector
dwd = 2*pi/N;               % frequency spacing of samples of DFT
wd = 0:dwd:(N-1)*dwd;       % frequency vector of DFT
w0 = 0.5*pi;
x_N = cos(w0*n);

% Plot sampled sinc in time domain
figure, stem(n, x_N)

% 
dw = 10e-3;                 % frequency spacing for DTFT calculation
w = 0:dw:2*pi-dw;           % frequency vector for DTFT calculation

% Window function
win = hamming(N).';         % Hamming window. Try other windows
% win = ones(size(x_N));      % rectangular window

% As in the plant identification problem in HW4, we need to expand the 
% frequency vector in order to account for the periodicity of DTFT. With
% this expanded vector the numerical integration will be correct from 0 to 2pi.
w2 = 0:dw:2*pi-dw;      
Win1 = 0.5*freqz(win, 1, w2-w0); % frequency response of the window at frequencies w2
Win2 = 0.5*freqz(win, 1, w2+w0); % frequency response of the window at frequencies w2
X_N = Win1 + Win2;

% Plot reults
figure, hold on, box on
plot(w/pi, abs(X_N), 'LineWidth', 2, 'DisplayName', 'DTFT');
stem(wd/pi, abs(fft(x_N.*win)), 'LineWidth', 2, 'DisplayName', 'DFT');
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (linear units)')
legend('-dynamiclegend')

% addpath('D:\Jose\Dropbox\research\codes\f')
% m = matlab2tikz(gca);
% m.write_tables('../figs/data/dft_cosine_N=21')