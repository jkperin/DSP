%% Spectrogram
clear, clc, close all
addpath('C:\Users\Joe\Dropbox\research\codes\f')

[y, Fs] = audioread('speech_dft.wav');
y = decimate(y, 2);
Fs = Fs/2;
y = y(3600:5800);

% n = 0:2000-1;
% y = cos(150e-6*pi*n.^2).*double(n <= 550);
% y = y + cos(0.5*pi*n).*double(n > 550 & n <= 1100);
% y = y + cos(0.25*pi*n).*double(n > 1100);

dt = 1/Fs;
t = 0:dt:(length(y)-1)*dt;
Twindow = 20e-3;
Nwindow = floor(Twindow*Fs);

figure, plot(t*1e3, y);
% m = matlab2tikz(gca);
% m.write_tables('../figs/data/speech_sample')

Nfft = 700;
R = 500; %round(50e-3/dt);

df = 1/(dt*Nfft);
f = -Fs/2:df:Fs/2-df;
f = f*1e-3;
Y1 = abs(fftshift(fft(y(1:Nfft))));


[s, f, t] = spectrogram(y, kaiser(Nfft, 6), Nfft-R, Nfft, 'yaxis');

figure, hold on, box on
for k= 1:4
    plot(Fs/2e3*f/pi, 20*log10(abs(s(:, k))), 'displayname', sprintf('k=%d', k))
end
m = matlab2tikz(gca);
% m.write_tables('../figs/data/speech_spectrogram_dft', 'same x')

for k =1:4
    figure, box on
    imagesc(20*log10(abs(flipud(s(:, 1:k)))))
    a = axis;
    axis([0.5 4.5 a(3:4)])
    set(gca, 'xtick', 1:4)
    set(gca, 'xticklabels', 50:50:200)
    set(gca, 'ytick', (0:64:350)+64/2)
    set(gca, 'yticklabels', fliplr(0:1:5.5))
    colormap jet
    pbaspect([4 1 1])
    ylabel('Frequency (kHz)', 'FontSize', 10)
    xlabel('Time (ms)', 'FontSize', 10)
%     saveas(gca, ['../figs/spectrogram_demo_pt' num2str(k)], 'epsc')
end
