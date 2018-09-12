%% Noise canceling
clear, clc, close all
 
[y, Fs] = audioread('saw_noise_front_mic.wav'); % Fs is sampling frequency
[x, Fs] = audioread('saw_noise_rear_mic.wav');   

N = floor(length(y)/2);

y_train = y(1:N);
y_val = y(N+1:end);
x_train = x(1:N);
x_val = x(N+1:end);

%% c) Estimate x[n] PSD
M = 512;
L = 2*M-1;
window = bartlett(L);
dw = 2*pi/L;        % Nfft = L;
w = -pi:dw:pi-dw;

Pxx = blackman_tukey_psd(x_train, window, M);

% Plot results
figure, box on, hold on
plot(w/pi, 10*log10(Pxx), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
saveas(gca, '../figs/noise_cancel_x_psd', 'epsc')

%% d) Estimate cross-correlation 
% unbiased autocorrelation estimator
phi_yx_hat = xcorr(y_train, x_train, M-1, 'unbiased');  
s = phi_yx_hat.*window; % windowing
Phi_yx_hat = fftshift(fft(ifftshift(s))); 
% Note: ifftshift ensures that Phi_yx_hat is not phase shifted due to FFT 
% indexing. Using abs() or real() would result in incorrect estimates

% Plot results
figure, box on, hold on
plot(w/pi, 10*log10(abs(Phi_yx_hat)), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
saveas(gca, '../figs/noise_cancel_cross_psd', 'epsc')

%% e)
Hest = Phi_yx_hat./Pxx;

% Plot results
figure, box on, hold on
plot(w/pi, 20*log10(abs(Hest)), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
saveas(gca, '../figs/noise_cancel_Hest', 'epsc')

%% f) Filter design
M = 49;

% Calculate matrix Q
% This assumes even symmetry
Q = zeros(length(w), M+1); % initialized
n = 0:M; % time vector
for i = 1:length(w) % for every frequency wi
    Q(i, :) = exp(-1j*w(i)*n);
end

% Least-squares algorithm
d = Hest;
hls = real(pinv(Q)*d); % real() removes imaginary part due to numerical errors
Hls = freqz(hls, 1, w);

% Plot results
figure, box on, hold on
plot(w/pi, 20*log10(abs(Hest)), 'r', 'LineWidth', 2)
plot(w/pi, 20*log10(abs(Hls)), 'k', 'LineWidth', 2)
legend('Desired response', 'FIR filter of order 50')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
saveas(gca, '../figs/noise_cancel_Hfir', 'epsc')

%% g)
y_clean = y_val - filter(hls, 1, x_val);
sound(y_clean, Fs)
