%% Speech de-noising problem
clear, clc, close all

Nruns = 20; % number of independent runs to average learning curve
L = 101; % number of adaptive filter coefficients
[x, Fs] = noisy_speech(10);

% b)
var_x = mean(abs(x).^2);
traceR = L*var_x;
mu_max = 1/traceR;
mu = 0.1*mu_max;

y = zeros(size(x));
e = zeros(length(x), Nruns);
for l = 1:Nruns
    W = [1; zeros(L-1, 1)];
    [x, Fs] = noisy_speech(10);
    
    for n = L+1:length(x)
        d = x(n); % desired response
        X = x(n-1 + (0:-1:-L+1)); % input to adaptive filter
        y(n) = W.'*X;
        e(n, l) = (d - y(n));
        W = W + 2*mu*e(n, l)*X;
    end
end

MSE = mean(abs(e).^2, 2);

figure, plot(MSE)