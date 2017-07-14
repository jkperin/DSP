%% Template for Homework #3: Problem 3 on quantization and quantization noise shaping
clear, clc, close all % clear variables

% Load speech signal
[x, Fs] = audioread('speech_dft.wav');          % Fs is sampling frequency
T = 1/Fs;                                       % sampling period

%% Important: 
% If your simulations take too long because you're using a slow computer,
% you can uncomment the following line in order to use just part of the 
% speech signal. Specifically, you may use just the first 43000 samples, 
% which correspond to the phrase "The discrete Fourier transform". 
% In my computer, the simulations with the whole signal took < 1 s.
% x = x(1:43e3); % play just part of the speech

%% Your code goes here
sound(x, Fs) % Play speech

% Define parameters
range_lims = [-1 1];           % range limits
B = 4;                         % quantizer resolution

% To be implemented...
% [xq, e] = quantizer(x, B, range_lims); 






