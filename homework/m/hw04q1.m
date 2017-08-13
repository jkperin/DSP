%% Problem 1
clear, clc, close all

b = conv(conv([1 -exp(1j*pi/3)], [1 -exp(-1j*pi/3)]), [1 1/0.85]);
a = conv(conv([1 -0.9*exp(1j*pi/3)], [1 -0.9*exp(-1j*pi/3)]), [1 0.85]);

%% a)
zplane(b, a) % b and a must be row vectors
saveas(gca, '../figs/hw4q1a_pole_zero', 'epsc')

%% b)
figure, freqz(b, a)
saveas(gca, '../figs/hw4q1b_mag_phase', 'epsc')

%% c)
figure, grpdelay(b, a)
saveas(gca, '../figs/hw4q1b_grpdelay', 'epsc')