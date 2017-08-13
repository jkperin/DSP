%% Homework 4, problem 6
clear, clc, close all

b = 0.05634*conv([1 1], [1 -1.0166 1]);
a = conv([1 -0.683], [1 -1.4461 0.7957]);

zplane(b, a)
saveas(gca, '../figs/hw04q6_zplane', 'epsc')

B = 6;

bh = 2^(-B)*round(2^B*a);
ah = 2^(-B)*round(2^B*b);

figure, hold on, box on
plot(roots(b),'ok'); plot(roots(a),'xk')
plot(roots(bh),'or'); plot(roots(ah),'xr')
w = linspace(0, 2*pi);
plot(cos(w), sin(w), 'k')
axis equal
saveas(gca, '../figs/hw04q6_zplane_quant', 'epsc')

[H, w] =freqz(b, a);
Hq =freqz(b, a, w);

figure, hold on, box on
plot(w/pi, 20*log10(abs(H)), 'LineWidth', 2)
plot(w/pi, 20*log10(abs(Hq)), '--', 'LineWidth', 2)
legend('Unquantized', 'Quantized')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/hw04q6_mag', 'epsc')