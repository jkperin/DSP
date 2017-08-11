%% Windowing of sinusoidal signals
% beta controls the side-lobe area Asl (leakage)
% Increasing the window length improves resolution
% Increasing the FFT size does not improve resolution
clear, clc

Nfft = 512;                  % FFT size
Lwin = 256;                  % Window length
% If window length is smaller than Nfft, the signal will be zero-padded

n = 0:Lwin-1;

w0 = pi/3;
w1 = 1.1*w0;
x = cos(w0*n) + 0.5*cos(w1*n);

% Window
beta = 6; % beta = 0 means rectangular window
win = kaiser(Lwin, beta).';

% Windowing
v = x.*win;

% Spectrum analysis
% Define frequency vector
dw = 2*pi/Nfft;
w = -pi:dw:pi-dw;

V = fftshift(fft(v, Nfft));

%
figure(1), hold on, box on
plot(w/pi, abs(V), 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('|V(e^{j\omega}|', 'FontSize', 12)

