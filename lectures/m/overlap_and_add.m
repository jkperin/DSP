%% Overalp and add
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

triang = @(x, N) (1/N)*(x + N).*double(x <= 0 & x >= -N) + (1/N)*(-x + N).*double(x > 0 & x <= N);

N = 51;
n = 0:N-1;
M = 10;
M2 = M/2;
L = 15;

h = triang(-M2:M2, M2);

rng(0);
x = sin(n*(2*pi/20)) + filter(1/3*ones(1, 10), 1, (rand(size(n))-0.5));

figure, subplot(611)
stem(0:length(h)-1, h)
axis([0 50 -1 1])

subplot(612)
stem(0:N-1, x)
axis([0 50 -2 2])

subplot(613)
y1 = conv(h, x(1:L), 'full');
stem(0:length(y1)-1, y1)
L2 = length(y1);
axis([0 50 -10 10])

subplot(614)
y2 = conv(h, x(L+1:2*L), 'full');
stem(L:L+length(y2)-1, y2)
axis([0 50 -10 10])

subplot(615)
y3 = conv(h, x(2*L+1:3*L), 'full');
stem(2*L:2*L+length(y2)-1, y3)
axis([0 50 -10 10])

subplot(616), hold on
ytot1 = conv(h, x, 'full');
stem(0:length(ytot1)-1, ytot1)

y1 = [y1 zeros(1, N-length(y1))];
y2 = [zeros(1, L) y2 zeros(1, N-length(y2)-L)];
y3 = [zeros(1, 2*L) y3(1:N-2*L)];
ytot = y1 + y2 + y3;
stem(0:length(ytot)-1, ytot, 'x')
axis([0 50 -10 10])

%
figure, hold on, box on
plot(0:N-1, x, 'DisplayName', 'x')
plot(0:length(y1)-1, y1, 'DisplayName', 'y1')
plot(0:length(y2)-1, y2, 'DisplayName', 'y2')
plot(0:length(y1)-1, y1+y2, 'DisplayName', 'y1+y2')
plot(0:length(y2)-1, y2, 'DisplayName', 'y2')
plot(0:length(y3)-1, y3, 'DisplayName', 'y3')
plot(0:length(ytot1)-1, ytot1, 'DisplayName', 'ytot')

m = matlab2tikz(gca);
m.write('overlap_add_add.tex')
