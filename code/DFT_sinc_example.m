%% N-point DFT of truncated sinc
clear, clc, close all

% Define variables
N = 20;                     % number of samples in DFT
n = 0:N-1;                  % discrete-time vector
dwd = 2*pi/N;               % frequency spacing of samples of DFT
wd = 0:dwd:(N-1)*dwd;       % frequency vector of DFT
x_N = 1/2*sinc((n-N/2)/2);

% Plot sampled sinc in time domain
figure, stem(n, x_N)

% 
dw = 10e-3;                 % frequency spacing for DTFT calculation
w = 0:dw:2*pi-dw;           % frequency vector for DTFT calculation

% Ideal DTFT of sinc function i.e., ideal lowpass filter
X = ones(size(w));   
X(w > pi*0.5 & w < 1.5*pi) = 0; % 1 everywhere except from 0.5pi to 1.5pi
X = X.*exp(-1j*w*N/2);          % phase shift, as sinc is delay by N/2

% Window function
win = hamming(N).';         % Hamming window. Try other windows
win = ones(size(x_N));      % rectangular window

% As in the plant identification problem in HW4, we need to expand the 
% frequency vector in order to account for the periodicity of DTFT. With
% this expanded vector the numerical integration will be correct from 0 to 2pi.
w2 = 0:dw:4*pi-dw;      
Win = freqz(win, 1, w2); % frequency response of the window at frequencies w2

% Calculate DTFT of xN[n] i.e., convolution of ideal lowpass filter and
% window
X_N = 1/(2*pi)*conv(X, Win, 'same')*dw;

% Plot reults
figure, hold on, box on
plot(w/pi, abs(X_N), 'LineWidth', 2, 'DisplayName', 'DTFT');
stem(wd/pi, abs(fft(x_N.*win)), 'LineWidth', 2, 'DisplayName', 'DFT');
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (linear units)')
legend('-dynamiclegend')