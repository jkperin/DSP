%% Problem 1
clear, clc, close all

a1 = [1 -0.5 0.2 0.3];
b1 = [1 0.5 0.1 0.5];

[z,p,k] = tf2zpk(b1,a1) 

freqz(b1, a1)
saveas(gca, '../figs/hw01q1c_freqz2', 'epsc')

fvtool(b1, a1)

%
a2 = 1;
b2 = [1 -0.5 0.5];

[z,p,k] = tf2zpk(b2,a2) 

fvtool(b2, a2)

freqz(b2, a2)
saveas(gca, '../figs/hw01q1c_freqz1', 'epsc')