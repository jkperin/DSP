%% Template for the echo cancelling problem

fs = 8e3;                          % sampling frequency (Hz)
f = 400;                           % sinusoid frequency (Hz)
Tdur = 0.2;                        % pulse duration (s)
x = pulse(f,Tdur,fs);              % Generates a pulse of frequency f, duration Tdur, and sampling frequency fs
x = [x zeros(1, 2*length(x))];     % zero pad for processing
n = 0:length(x)-1;                 % discrete time vector
t = n/fs;                          % continuous time vector

plot(t, x);                        % Plot signal
xlabel('Time (s)') 
ylabel('Amplitude')
title(sprintf('Original pulse: %.2f Hz', f))
sound(x, fs);                      % Play the sound

%% Your code goes here


