%% Plant identification by noise injection
clear, clc, close all

% Coefficients for H(z)
b = 0.05634*conv([1 0.9], [1 -1.0166 0.8]);
a = conv([1 -0.683], [1 -1.4461 0.7957]);

b = 10*ones(1, 5);
a = 1;

figure, zplane(b, a)

sigma_x = 1; % average power of input noise

%% Part (a)
maxLag = 256;
N = 50e3;
x = sigma_x*randn(1, N);
y = filter(b, a, x);
c = xcorr(y, y, maxLag, 'unbiased');

% Plot results
figure, box on
stem(-maxLag:maxLag, c)
xlabel('m', 'FontSize', 12)
ylabel('Empir. autocorrelation function of y[n]', 'FontSize', 12)
set(gca, 'FontSize', 12)
axis([-maxLag maxLag -0.02 max(c)])
%saveas(gca, '../figs/hw04_q3a_emp_xcorr', 'epsc')

%% Part (b)
[C, w] = calc_psd(c);
[H, w] = freqz(b, a, w);

% Plot results
figure, box on, hold on
plot(w/pi, C, 'LineWidth', 2)
plot(w/pi, abs(H).^2, 'LineWidth', 2)
legend('Empirical PSD', 'Theoretical PSD')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('PSD', 'FontSize', 12)
set(gca, 'FontSize', 12)
%saveas(gca, '../figs/hw04_q3b_emp_psd_high_pass', 'epsc')

%% Part (d)
logMag = log(sqrt(C))/sigma_x^2; % Log magnitude ln(|H|)

% Convolution function. 
hHT = sin(w)./(1-cos(w));
hHT(w == 0) = 0; % enforces hHT = 0, when w = 0

% Convolution integral
dw = abs(w(1))-abs(w(2)); % frequency resolution
w2 = -2*pi+dw:dw:2*pi-dw;
hHT = sin(w2)./(1-cos(w2));
hHT(w2 == 0) = 0; % enforces hHT = 0, when w = 0
P = -1/(2*pi)*conv(logMag, hHT, 'same')*dw;

% Plot results
figure, box on, hold on
plot(w/pi, P, 'LineWidth', 2)
plot(w/pi, unwrap(angle(H)), 'LineWidth', 2)
legend('Estimated phase', 'Theoretical phase')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
set(gca, 'FontSize', 12)
axis([-1, 1, -4, 4])
saveas(gca, '../figs/hw04_q3d_phase', 'epsc')
