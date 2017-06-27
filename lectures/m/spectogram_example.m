%% Record data 
clear, clc, close all

% [y, Fs] = audioread('dft_speech44100.wav');
[y, Fs] = audioread('speech_dft.wav');
dt = 1/Fs;
t = 0:dt:(length(y)-1)*dt;
Twindow = 20e-3;
window = floor(Twindow*Fs);
sound(y, Fs)

figure(1), subplot(211)
plot(t, y)
axis([0 5 -1 1])
set(gca, 'xtick', [])
ylabel('Amplitude', 'FontSize', 10)
set(gca, 'FontSize', 10)

figure(1), subplot(212), box on
spectrogram(y, window, round(window/2), [], Fs, 'yaxis');
colormap jet
axis([0 5 0 12])
set(gca, 'box', 'on')
set(gca, 'xtick', 0:5)
pbaspect([4 1 1])
cbh = findobj( 0, 'tag', 'Colorbar' ), % and 
delete( cbh )
xlabel('Time (secs)', 'FontSize', 10)
ylabel('Frequency (kHz)', 'FontSize', 10)
set(gca, 'FontSize', 10)
p1 = get(gca, 'position');
set(gca, 'position', p1 + [0 0.13 0 0])

% Adjust figure 1
figure(1), subplot(211)
p2 = get(gca, 'position')
set(gca, 'position', [p2(1:2) p1(3:4)])
pbaspect([4 1 1])
     
saveas(gca, '../figs/speech_spectogram', 'epsc')
 
%
[s, f, t] = spectrogram(y, window, round(window/2), [], Fs, 'yaxis');

%
figure
imagesc(20*log10(abs(flipud(s)).^2))
colormap jet
figure
imagesc(20*log10(abs(flipud(s(:, 45)))))
colormap jet
ylabel('Frequency (kHz)', 'FontSize', 10)
pbaspect([1 15 1])
set(gca, 'xtick', [])
set(gca, 'ytick', [])
saveas(gca, '../figs/speech_spectogram_strip', 'epsc')

%
% [y, Fs] = audioread('dft_speech44100.wav');
% Twindow = 20e-3;
% window = floor(Twindow*Fs);
% spectrogram(y(5000:end-5000), window, round(window/2), [], Fs, 'yaxis');
% pbaspect([2 1 1])
% cbh = findobj( 0, 'tag', 'Colorbar' ), % and 
% delete( cbh )
% saveas(gca, '../figs/speech_spectogram_44k', 'epsc')