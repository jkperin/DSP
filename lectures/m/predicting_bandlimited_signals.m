%% Predicting bandlimited singals
clear, clc, close all

% Believe it or not this generates a real, zero-mean, and approximately 
% band-limited Gaussian noise. The maximum frequency of the PSD of x is pi/2.
N = 1000;
fc = 0.7;
X = randn(1, fc*N) + 1j*rand(1, fc*N);
x = ifft(ifftshift([zeros(1, round((1-fc)*N)) conj(X(end:-1:1)) 0 X zeros(1, round((1-fc)*N-1))]));

%% Design high-pass filter using LS
N = 512;                % number of samples in the frequency domain
L = 31;                 % Filter length (number of coefficients
M = L - 1;              % Filter order 
dw = 2*pi/N;
w = (-pi:dw:pi-dw).'; % frequency vector omega (N x 1)

% Desired frequency response
d = zeros(size(w));     
d(abs(w) >= fc*pi) = 1; % highpass filter

% Weight function. 
% Transition band
Deltaw = 0.29*pi; % transition band
wv  = ones(size(w));
wv(w > fc*pi & w < fc*pi+Deltaw) = 0; % transition band (don't care)
wv(w < -fc*pi & w >= -fc*pi-Deltaw) = 0; % transition band (don't care)
W = diag(wv);

% Calculate matrix Q
% This assumes even symmetry
Q = zeros(N, M+1); % initialized
n = 0:M; % time vector
for i = 1:N % for every frequency wi
    Q(i, :) = exp(-1j*w(i)*n);
end

%% Least-squares algorithm
hls = real(pinv(W*Q)*(W*d)); % hls will not necessarily be symmetric, hence this FIR system is not necessarily linear phase

Hls = freqz(hls, 1, w);

xpred = zeros(1, length(x));
for n = M+1:length(x)
    xpred(n) = -1/hls(1)*sum(hls(2:end).'.*x(n-1:-1:n-M));
end

figure, 
subplot(211), box on, hold on
plot(w/pi, 20*log10(abs(Hls)), 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
set(gca, 'FontSize', 12)
title(sprintf('Least-squares high-pass filter with M = %d', M))

subplot(212), box on, hold on
stem(0:100, x(end-1000:end-900), 'LineWidth', 1, 'DisplayName', 'noise')
stem(0:100, xpred(end-1000:end-900), 'xr', 'MarkerSize', 6, 'DisplayName', 'prediction')
xlabel('n', 'FontSize', 12)
ylabel('Sample', 'FontSize', 12)
set(gca, 'FontSize', 12)
legend('-dynamiclegend')
title('Predictions')

