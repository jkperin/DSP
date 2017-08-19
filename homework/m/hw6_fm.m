%% Problem 6: Frequency modulation
%% a)
t = linspace(0,4);
Wc = 2*pi*1e3;
Wm = 2*pi;

Wi = @(beta, t) Wc + beta*Wm*cos(Wm*t);

figure
subplot(211)
plot(t, Wi(0.2, t)/(2*pi), 'k', 'LineWidth', 2);
xlabel('t (s)', 'FontSize', 12);
ylabel('\Omega_i/2\pi (Hz)', 'FontSize', 12);
legend('\beta = 0.2')

subplot(212)
plot(t, Wi(500, t)/(2*pi), 'k', 'LineWidth', 2)
xlabel('t (s)', 'FontSize', 12);
ylabel('\Omega_i/2\pi (Hz)', 'FontSize', 12);
legend('\beta = 500')
saveas(gca, '../figs/hw6_fm_a', 'epsc')

%% d)
beta = 0.2;
N = 32768;
n = 0:N-1;
% 
x = cos(pi/4*n) - beta*sin(pi/4e3*n).*sin(pi/4*n);

% soundsc(x)

% (i)
dt = 1/8e3;
df = 1/(N*dt);
f = -1/(2*dt):df:1/(2*dt)-df;
X = fftshift(fft(x, N)/N);

figure
plot(f, abs(X), 'k')
ylabel('|X(j\Omega)|', 'FontSize', 12)
xlabel('Frequency (Hz)', 'FontSize', 12)
axis([990 1010 0 0.5])
saveas(gca, '../figs/hw6_fm_di', 'epsc')

% (ii) 
figure
spectrogram(x, 256, 250, 256, 8e3);
saveas(gca, '../figs/hw6_fm_dii', 'epsc')

%% e)
beta = 500;
N = 32768;
n = 0:N-1;

x = cos(pi/4*n + beta*sin(pi*n/4e3));
% soundsc(x)

% (i)
dt = 1/8e3;
df = 1/(N*dt);
f = -1/(2*dt):df:1/(2*dt)-df;
X = fftshift(fft(x, N)/N);

figure
plot(f, abs(X), 'k')
ylabel('|X(j\Omega)|', 'FontSize', 12)
xlabel('Frequency (Hz)', 'FontSize', 12)
saveas(gca, '../figs/hw6_fm_ei', 'epsc')

% (ii) 
figure
spectrogram(x, 256, 250, 256, 8e3);
saveas(gca, '../figs/hw6_fm_eii', 'epsc')