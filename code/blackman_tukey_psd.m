function Pw = blackman_tukey_psd(x, window, M)
%% Blackman-Tukey PSD estimator
phi_hat = xcorr(x, x, M-1, 'unbiased'); % unbiased autocorrelation estimator
s = phi_hat.*window; % windowing
s(M:-1:1) = s(M:1:end); % enforce even symmetry
Pw = abs(fftshift(fft(s))); % fft(s) is liner phase. To obtain magnitude we only need to take absolute value

