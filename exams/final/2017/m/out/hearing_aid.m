%% Hearing aid problem 
clear, clc, close all

T = 1/22.05e3;     % sampling time in seconds
f = 1e3*[0.1 0.5 1 2 3 4 5 6 7 8 9 10]; % in Hz
A = [0 0 0 -10 -12 -17 -22 -29 -34 -39 -47 -50]; % in dB

figure, plot(f, A)


%%