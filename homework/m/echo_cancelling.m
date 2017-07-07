%% Template for the echo cancelling problem
clear, clc, close all

fs = 8e3;                          % sampling frequency (Hz)
f = 400;                           % sinusoid frequency (Hz)
Tdur = 0.2;                        % pulse duration (s)
x = pulse(f,Tdur,fs);              % Generates a pulse of frequency f, duration Tdur, and sampling frequency fs
x = [x zeros(1, 2*length(x))];     % zero pad for processing
n = 0:length(x)-1;                 % discrete-time vector
t = n/fs;                          % continuous-time vector

plot(t, x);                 % Plot signal
xlabel('Time (s)') 
ylabel('Amplitude')
title('Original pulse: 400-Hz sinusoid, 200-ms Hann window')
sound(x, fs);               % Play the sound

%% Your code goes here
alpha = 0.5;
Techo = 0.1;
N = Techo*fs;

% Echo generation system 1
a1 = 1;
b1 = zeros(1, N+1); % b1 has N+1 coefficients
b1(1) = 1;
b1(N+1) = alpha;

y1 = filter(b1, a1, x);
figure
plot(t, y1);                 % Plot signal
xlabel('Time (s)', 'FontSize', 12) 
ylabel('Amplitude', 'FontSize', 12)
saveas(gca, '../figs/hw01q2_echoed1', 'epsc')
sound(y1, fs);               % Play the sound

% Echo generation system 2
a2 = zeros(1, N+1);         % a1 has N+1 coefficients
a2(1) = 1;                  
a2(N+1) = -alpha;
b2 = 1;

y2 = filter(b2, a2, x);
figure
plot(t, y2);                 % Plot signal
xlabel('Time (s)', 'FontSize', 12) 
ylabel('Amplitude', 'FontSize', 12)
saveas(gca, '../figs/hw01q2_echoed2', 'epsc')
sound(y2, fs);               % Play the sound

%% Echo cancellation
% System 1
xrec1 = filter(a1, b1, y1); % We just need to switch the coefficients (a1, b1)
figure
plot(t, xrec1);                 % Plot signal
xlabel('Time (s)', 'FontSize', 12) 
ylabel('Amplitude', 'FontSize', 12)
saveas(gca, '../figs/hw01q2_echoed_rec1', 'epsc')
sound(xrec1, fs);               % Play the sound

% System 2
xrec2 = filter(a2, b2, y2);
figure
plot(t, xrec2);                 % Plot signal
xlabel('Time (s)', 'FontSize', 12) 
ylabel('Amplitude', 'FontSize', 12)
saveas(gca, '../figs/hw01q2_echoed_rec2', 'epsc')
sound(xrec1, fs);               % Play the sound


