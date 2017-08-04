%% Linear equalization
clear, clc, close all

c = [0.4032    0.3992    0.1976];

% 
hc = impz(1, c);

M = 8;
h = hc(1:M+1);

BER = simple_channel(h)



% Calculate matrix Q
% This assumes even symmetry
N = 100;
w = linspace(-pi, pi).';
d = freqz(1, c, w);

Q = zeros(N, M+1); % initialized
n = 0:M; % time vector
for i = 1:N % for every frequency wi
    Q(i, :) = exp(-1j*w(i)*n);
end


hls = pinv(Q)*d;

BER = simple_channel(hls)


sum(abs(hls).^2)