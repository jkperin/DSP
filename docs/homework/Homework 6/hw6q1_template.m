%% Noise canceling
clear, clc, close all
 
[s, Fs] = audioread('guitartune.wav'); % Fs is sampling frequency

Nruns = 20; % number of independent runs to average learning curve
var_r = 2e-3; % variance of white Gaussian noise

L = 49; % adaptive filter order. L+1 coefficients

% H(z) filter coefficients 
% Although H(z) is "unknown", for developing your answers you can use this
% filter. It is a eighth-order IIR Chebyshev type II filter with bandwidth
% 0.55*Fs. Chebyshev type II filters have constant gain at the passband, 
% but they exhibit ripples in the stopband. 
[hb, ha] = cheby2(6, 30, 0.55);
hb = [zeros(1, 20) hb]; % Add a delay of 20 samples to H(z)
% Hint: for filtering, use the function filter, e.g., output = filter(hb, ha, input)

%% Your solutions go here
% Matlab hints: 
% - The function randn() generates zero-mean, unit-variance,
% Gaussian-distributed numbers
% - Fixed filters can be easily implement using the function filter()
% - Adaptive filters are can be implemented in a for loop
% - To plot the coefficients of an FIR filter, use the function impz
% (impulse response)
% - To plot the magnitude and phase response, use the function freqz()
% - To play a signal use the function sound(x, Fs). Don't forget to include
% the sampling frequency when calling sound, otherwise Matlab will assume 
% Fs = 8 kHz, which is not the correct value.
sound(s, Fs) % example