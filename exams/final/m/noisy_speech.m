function [x, Fs] = noisy_speech(SNR)
%% Add noise to speech signal to produce noisy speech signal with specified SNR

if not(exist('SNR', 'var'))
    SNR = 10;
end

% [s, Fs] = audioread('speech_dft.wav');
t = 0:2^14-1;
s = cos(2*pi*0.1*t).';
Fs = 1;

Ps = mean(abs(s).^2); % average power of s
r = sqrt(Ps/SNR)*randn(size(s)); % noise

x = s + r; % noisy speech