function x = pulse(f,Tdur,fs)
% Sinusoid multiplied by a Hann window function.
% f sinsusoid frequency (Hz)
% Tdur duration (s)
% fs sampling frequency (Hz)
nmax = floor(Tdur*fs);                  % duration (samples)               
n = 1:nmax;                             % discrete time index
x = hann(nmax).'.* cos(2*pi*f*n/fs);    % waveform samples
