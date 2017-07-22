function [Phi, w] = calc_psd(phi)
%% Calculate PSD of the autocorrelation function phi
% Input:
% - phi: empirical autocorrelatin function obtained with xcorr
% Outputs:
% - Phi: empirical PSD (fft of phi)
% - w: frequency vector

dw = 2*pi/length(phi);
w = -pi:dw:pi-dw; % frequency vector

phi = phi.*hann(length(phi)).'; % windowing 
Phi = abs(fftshift(fft(phi))); % PSD
