%% Implementation of feedback loop for noise shaping
clear, clc, close all % clear variables

% Load speech signal
[x, Fs] = audioread('speech_dft.wav');          % Fs is sampling frequency
T = 1/Fs; 

% Define parameters
range_lims = [-1 1];           % range limits                  
B = 4; % quantizer resolution
M = 3; % oversampling factor

% Interpolate to emulate oversampling
xos = interp1(0:length(x)-1, x, (0:(M*(length(x)-1)))/M);

y = zeros(size(xos)); % output of the feedback loop
u = zeros(size(xos)); % signal at the input of H(z)
v = zeros(size(xos)); % signal at the output of H(z)
for n = 2:length(xos)
    % The difference equation corresponding to H(z) is simply y[n] - y[n-1] = x[n]
    
    u(n) = xos(n) - y(n-1); 
    v(n) = u(n) + v(n-1);    
    y(n) = quantizer(v(n), B, range_lims);
end

xq = decimate(y, M);

sound(xq, Fs)       