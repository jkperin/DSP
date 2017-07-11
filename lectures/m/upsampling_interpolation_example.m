%% Example of reconstruction with an ideal lowpass filter
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')
%cos(deg(#1/2)) - sin(deg(#1)) + cos(deg(#1/2)-45) - sin(deg(#1/4)-154)
y = @(x) cos(x/2) - sin(x) + cos(x/2-pi/4) - sin(x/4-deg2rad(154));
Ts = 0.5*pi;
tmax = 20;
t = -tmax:Ts:tmax;
x = linspace(t(1), t(end), 201);

ys = y(t(1:2:end));
N = 5;
tint = -N:N; 

hsinc = sinc(tint/2);
hlin = [1/2 1 1/2];
hZOH = [1 1];

figure, hold on, box on
plot(x, y(x), 'DisplayName', 'original')
plot(t(1:2:end), ys, 'o', 'DisplayName', 'sampled')

ysinc = filter(hsinc, 1, upsample(ys, 2));
ysinc = circshift(ysinc, [0 -round(grpdelay(hsinc, 1, 1))]);
plot(t, ysinc(1:length(t)), 'r', 'DisplayName', 'sinc')

ylin = filter(hlin, 1, upsample(ys, 2));
ylin = circshift(ylin, [0 -round(grpdelay(hlin, 1, 1))]);
plot(t, ylin(1:length(t)), 'r', 'DisplayName', 'linear')

yZOH = filter(hZOH, 1, upsample(ys, 2));
plot(t, yZOH(1:length(t)), 'r', 'DisplayName', 'ZOH')

m = matlab2tikz(gca);
m.write('interp_05.tex')