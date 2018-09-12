%% Adaptive noise canceling
clear, clc, close all
 
[x, Fs] = audioread('whitenoise_front_mic.wav'); % Fs is sampling frequency
[r, Fs] = audioread('whitenoise_rear_mic.wav');   

L = 50; % number of adaptive filter coefficients

% x = primary input (signal + noise)
% r = reference input (correlated noise measurement)

traceR = L*mean(abs(r).^2);
mu = 0.01*1/traceR;

W = zeros(L, 1);
y = zeros(size(x));
for n = L+1:length(r)
    X = r(n:-1:n-L+1); % row-vector 
    
    y(n) = X.'*W;
    
    d = x(n); % desired response
    e(n) = (d - y(n)); 
    
    W = W + 2*mu*e(n)*X;
end

s_hat = x - y;

sound(s_hat, Fs)