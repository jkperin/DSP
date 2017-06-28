%% Random experiment
clear, clc, close all

%% Moving average filter
h = [1 1 1 1]/4;
chh = conv(h, conj(fliplr(h)));
x = 2*rand(1, 10000) - 1; % noise uniformly distributed between [-1, 1]
y = filter(h, 1, x); % filter using moving average filter

maxLag = 10;
phi_xx = xcorr(x, x, maxLag, 'unbiased'); % estimate autocorrelation
phi_yy = xcorr(y, y, maxLag, 'unbiased'); % estimate autocorrelation

varx = 2^2/12;
phi_xx_theory = zeros(1, 2*maxLag+1);
phi_xx_theory(maxLag+1) = varx;
phi_yy_ideal = conv(phi_xx_theory, chh, 'same');

figure, hold on, box on
stem(-maxLag:maxLag, phi_xx, 'LineWidth', 1.5)
stem(-maxLag:maxLag, phi_xx_theory, 'xr', 'LineWidth', 1.5)
xlabel('m', 'FontSize', 12)
ylabel('\phi_{xx}[m]', 'FontSize', 12)
legend('empirical', 'theory')
set(gca, 'FontSize', 12)
saveas(gca, '../figs/lec2_random_experiment2_phi_xx', 'epsc')

figure, hold on, box on
stem(-maxLag:maxLag, phi_yy, 'LineWidth', 1.5)
stem(-maxLag:maxLag, phi_yy_ideal, 'xr', 'LineWidth', 1.5)
xlabel('m', 'FontSize', 12)
ylabel('\phi_{yy}[m]', 'FontSize', 12)
legend('empirical', 'theory')
set(gca, 'FontSize', 12)
saveas(gca, '../figs/lec2_random_experiment2_phi_yy', 'epsc')

%% Estimate pdf
Nbins = 20;
[counts, centers] = hist(x, Nbins);
x_pdf = Nbins/(centers(end)-centers(1))*counts/sum(counts);
figure, box on
bar(centers, x_pdf)
xlabel('x', 'FontSize', 12)
ylabel('p_x(x)', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/lec2_random_experiment1_hist_x', 'epsc')

[counts, centers] = hist(y, Nbins);
y_pdf = Nbins/(centers(end)-centers(1))*counts/sum(counts);
figure, box on, hold on
bar(centers, y_pdf)
sigma2 = var(y);
xx = linspace(centers(1)*0.8, centers(end)*1/0.8);
plot(xx, 1/sqrt(2*pi*sigma2)*exp(-xx.^2/sigma2), 'r', 'LineWidth', 2)
xlabel('y', 'FontSize', 12)
ylabel('p_y(y)', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/lec2_random_experiment1_hist_y_fit', 'epsc')
