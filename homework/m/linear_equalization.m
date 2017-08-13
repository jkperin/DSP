%% Linear equalization
clear, clc, close all

M = 8; % Filter order

% Filter coefficients
c = [0.4032    0.3992    0.1976];

% Impulse response of 1/C(z)
hc = impz(1, c);

%% a) Window method with rectangular window
hwin = hc(1:M+1);

BER = simple_channel(hwin)

% Plot results
[H, w] = freqz(1, c);
Hwin = freqz(hwin, 1, w);

figure, hold on, box on
plot(w/pi, abs(H).^2, 'LineWidth', 2, 'displayname', 'H(z)')
plot(w/pi, abs(Hwin).^2, 'LineWidth', 2, 'displayname', 'H_{win}(z)')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/eq_rect_win_mag', 'epsc')

figure, hold on, box on
plot(w/pi, unwrap(angle(H)), 'LineWidth', 2, 'displayname', 'H(z)')
plot(w/pi, unwrap(angle(Hwin)), 'LineWidth', 2, 'displayname', 'H_{win}(z)')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/eq_rect_win_phase', 'epsc')

%% c) Least-squares method
% Calculate matrix Q
% This assumes even symmetry
N = 100;
w = linspace(-pi, pi).';
d = freqz(1, c, w);

Q = zeros(N, M+1); % initialized
n = 0:M; % time vector
for i = 1:N % for every frequency wi
    Q(i, :) = exp(-1j*w(i)*n);
end

% Least-squares filter
hls = pinv(Q)*d;

BER = simple_channel(hls)

% Plot results
[H, w] = freqz(1, c);
Hls = freqz(hls, 1, w);

figure, hold on, box on
plot(w/pi, abs(H).^2, 'LineWidth', 2, 'displayname', 'H(z)')
plot(w/pi, abs(Hls).^2, 'LineWidth', 2, 'displayname', 'H_{win}(z)')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude', 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/eq_ls_mag', 'epsc')

figure, hold on, box on
plot(w/pi, unwrap(angle(H)), 'LineWidth', 2, 'displayname', 'H(z)')
plot(w/pi, unwrap(angle(Hls)), 'LineWidth', 2, 'displayname', 'H_{win}(z)')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/eq_ls_phase', 'epsc')

% d)
sigma2 = 0.001;
P = sigma2/(pi)*trapz(w, abs(Hls).^2) 
% Note division by pi instead of 2pi since w is defined in the interval (0,
% pi)

% Another way to calculate P
P = sigma2*sum(abs(hls).^2) % from Parseval's identity
