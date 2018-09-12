%% Noise canceling problem
clear, clc, close all
 
% Loads signals
[y, Fs] = audioread('saw_noise_front_mic.wav');  % Fs is sampling frequency
[x, Fs] = audioread('saw_noise_rear_mic.wav');  

N = floor(length(y)/2);

% Split signals into training and testing vectors
y_train = y(1:N);
y_test = y(N+1:end);
x_train = x(1:N);
x_test = x(N+1:end);

sound(y_test, Fs);
%%