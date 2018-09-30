%% Process noise
clear, clc, close all
[x, Fs] = audioread('guitartune.wav');          % Fs is sampling frequency

[saw1, Fs2] = audioread('electric_saw.wav', [1e3 1e3+length(x)-1]);          % Fs is sampling frequency
saw1 = saw1(:, 1);

SNRdB = 5;
Tmax = 15;
N = round(Fs*Tmax);
x = x(1:N);

saw1 = decimate(saw1, 2);
x = decimate(x, 2);
Fs = Fs/2;

% sound(x, Fs)

x = x - mean(x);
saw1 = saw1 - mean(saw1);

x = 0.9*x;
Ps = var(x);
SNR = 10^(SNRdB/10);
Pn = Ps/SNR;
n = sqrt(Pn)*randn(size(x));
saw1 = sqrt(Pn/var(saw1))*saw1;

c = fir1(6, 0.75);
[bc, ac] = butter(4, 0.5);
bc = [zeros(1, 10) bc];

y = x + filter(bc, ac, n);
ysaw = x + filter(bc, ac, saw1);

% sound(ysaw, Fs);

audiowrite('whitenoise_front_mic.wav', y, Fs);
audiowrite('whitenoise_rear_mic.wav', n, Fs);
audiowrite('saw_noise_front_mic.wav', ysaw, Fs);
audiowrite('saw_noise_rear_mic.wav', saw1, Fs);
save('guitartune_whitenoise')
