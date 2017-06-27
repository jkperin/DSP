%% Plot digital waveform
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\mpam')
addpath('C:\Users\Joe\Dropbox\research\codes\f')

%% Pulse shape
ros = 11;
pulse_shape = select_pulse_shape('rect', ros);
% pulse_shape = select_pulse_shape('rrc', sim.ros.txDSP, 0.5, 6);

%% M-PAM
% PAM(M, bit rate, leve spacing : {'equally-spaced', 'optimized'}, pulse
% shape: struct containing properties of pulse shape 
mpam = PAM(2, 1, 'equally-spaced', pulse_shape);

Nsymb = 100;
dataTX = randi([0 1], [1, Nsymb]);
dataTX(1:6) = [0 1 0 1 1 0];
x = mpam.signal(dataTX);

% Plot
figure
plot(x(1:6*ros))
m = matlab2tikz(gca);
m.write('tx_waveform.tex')

F = ClassFilter('two-pole', 0.5/ros, 1);
y = F.filter(x);

figure
plot(y(1:6*ros))
m = matlab2tikz(gca);
m.write('rx_waveform.tex')

F = ClassFilter('two-pole', 0.1/ros, 1);
y = F.filter(x);

figure
plot(y(1:6*ros))
m = matlab2tikz(gca);
m.write('rx_waveform_bad.tex')

% figure
% eyediagram(x, 2*ros)

