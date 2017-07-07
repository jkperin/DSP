%% Example of reconstruction with an ideal lowpass filter
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')


x = linspace(-10,10, 101);
y = @(x) cos(x/2) - sin(x) + cos(x/2-pi/4) - sin(x/4-deg2rad(154));
t = linspace(-10,10, 21);
T = abs(t(1)-t(2));
ys = y(t);

figure, hold on, box on
plot(x, y(x), 'DisplayName', 'original')
plot(t, ys, 'o', 'DisplayName', 'sampled')
f = zeros(length(ys), length(x));
for n = 1:length(ys)
    f(n, :) = ys(n)*sinc(x-t(n)*T);
    plot(x, f(n, :), 'DisplayName', sprintf('f%d', n))
end

plot(x, sum(f, 1), 'r', 'DisplayName', 'interp')
m = matlab2tikz(gca);
m.write('recontruction_ideal_lpf.tex')
