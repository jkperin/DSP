%% Process ECG
clear, clc, close all

load('118e00m.mat')

N = 1000;
tstart = 1100;
val = val(1, tstart:tstart+N-1); % - val(2, 1:N);

dt = 3e-3;
t = 0:dt:(N-1)*dt;
fs =1/dt;
df = fs/N;
f = -fs/2:df:fs/2-df;

P = mean(abs(val(1, :)).^2);
SNRdB = 20;
SNR = 10^(SNRdB/10);

sigma2 = P/SNR;

w = 2*rand(1, N/40)-1;
w = interp1(1:40:N, w, 1:N);
i60 = sqrt(2*sigma2).*sin(2*pi*60*t + 2*pi*rand(1));

xclean = val;
x = val + i60;
% figure, hold on,
% plot(x)
% plot(xclean)
% figure, plot(f, 20*log10(abs(fftshift(fft(x - mean(x))))))

%% Save in file
ecg_clean = xclean;
ecg_60Hz = x;
T = dt;
save('ecg_recording.mat', 'ecg_clean', 'ecg_60Hz', 'T', 'N')

