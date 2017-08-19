%% Inverse control of unknown plant
clear, clc, close all

% Plant
b = conv([1 -1.5*exp(1j*3*pi/4)], [1 -1.5*exp(-1j*3*pi/4)]);
a = conv([1 -0.75*exp(1j*pi/3)], [1 -0.75*exp(-1j*pi/3)]);

% figure, freqz(b, a)
% figure, zplane(b, a)

% Minimum phase
bmin = 2.25*conv([1 -1/1.5*exp(1j*3*pi/4)], [1 -1/1.5*exp(-1j*3*pi/4)]);
amin = conv([1 -0.75*exp(1j*pi/3)], [1 -0.75*exp(-1j*pi/3)]);

% figure, freqz(bmin, amin)
% figure, zplane(bmin, amin)

% All-pass 
bap = 1/2.25*conv([1 -1.5*exp(1j*3*pi/4)], [1 -1.5*exp(-1j*3*pi/4)]);
aap = conv([1 -1/1.5*exp(1j*3*pi/4)], [1 -1/1.5*exp(-1j*3*pi/4)]);

% figure, freqz(bap, aap)
% figure, zplane(bap, aap)

%% Plant ID 1
sigma_x = 1;                    % average power of input noise
x = sigma_x*randn(1, 1e4);      % generate zero-mean white noise with unit average power
y = filter(b, a, x);            % filter by the plant
    
% PSD estimation using Blackman-Tukey method
M = 512;                        % M-1 is the max lag in autocorrelation estimation
L = 2*M-1;                      % window length
window = bartlett(L).';         % window
PSDy = blackman_tukey_psd(y, window, M);

% Kramers-Kronig method
logMag = log(sqrt(PSDy))/sigma_x^2; % Log magnitude ln(|H|)

dw = 2*pi/L;                    % frequency spacing: Nfft = L
w = -pi:dw:pi-dw;               % frequency vector
w_ext = -2*pi+dw:dw:2*pi-dw;    % extended frequency vector for convolution integral

% Hilbert transform
hHT = sin(w_ext)./(1-cos(w_ext));
hHT(w_ext == 0) = 0; % enforces hHT = 0, when w = 0

% Convolution integral
Hphase = -1/(2*pi)*conv(logMag, hHT, 'same')*dw; % phase response

% Plot results
Hplant = freqz(b, a, w);
Hmin = freqz(bmin, amin, w);
figure, hold on, box on
plot(w/pi, 10*log10(abs(PSDy)), 'LineWidth', 2, 'DisplayName', 'Estimated magnitude')
plot(w/pi, 20*log10(abs(Hplant)), 'LineWidth', 2, 'DisplayName', 'True plant magnitude')
xlabel('\omega/\pi')
ylabel('Magnitude (dB)')
legend('-dynamiclegend')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_kramers_kronig_id_mag', 'epsc')

figure, hold on, box on
plot(w/pi, Hphase, 'LineWidth', 2, 'DisplayName', 'Estimated phase')
plot(w/pi, unwrap(angle(Hmin)), 'LineWidth', 2, 'DisplayName', 'H_{min}(z) phase response')
plot(w/pi, unwrap(angle(Hplant)), 'LineWidth', 2, 'DisplayName', 'True plant phase response')
xlabel('\omega/\pi')
ylabel('Phase (rad)')
legend('-dynamiclegend', 'Location', 'SouthWest')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_kramers_kronig_id_phase', 'epsc')

%% Plant ID 2
% Modified Blackman-Tukey method
phi_yx_hat = xcorr(y, x, M-1, 'unbiased'); % unbiased autocorrelation estimator
s = phi_yx_hat.*window; % windowing
Hest = fftshift(fft(ifftshift(s)));

figure, hold on
plot(w/pi, 20*log10(abs(Hest)), 'LineWidth', 2, 'DisplayName', 'Estimated magnitude')
plot(w/pi, 20*log10(abs(Hplant)), 'LineWidth', 2, 'DisplayName', 'True plant magnitude')
xlabel('\omega/\pi')
ylabel('Magnitude (dB)')
legend('-dynamiclegend')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_xcorr_id_mag', 'epsc')

figure, hold on
plot(w/pi, unwrap(angle(Hest)), 'LineWidth', 2, 'DisplayName', 'Estimated phase')
plot(w/pi, unwrap(angle(Hplant)), '--', 'LineWidth', 2, 'DisplayName', 'True plant phase response')
xlabel('\omega/\pi')
ylabel('Phase (rad)')
legend('-dynamiclegend', 'Location', 'SouthWest')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_xcorr_id_phase', 'epsc')

%% Controler 1: linear phase
wd = linspace(-pi, pi, 1024);
Hd = freqz(amin, bmin, wd);

idx = find(wd >= 0);
cls = firls(20, wd(idx(1:end))/pi, abs(Hd(idx(1:end))));

Cls = freqz(cls, 1, wd);

figure, hold on, box on
plot(wd/pi, 20*log10(abs(Hd)), 'LineWidth', 2, 'DisplayName', 'Desired response')
plot(wd/pi, 20*log10(abs(Cls)), '--', 'LineWidth', 2, 'DisplayName', 'FIR leasts-squares')
axis([-1 1 -50 30])
xlabel('\omega/\pi')
ylabel('Magnitude (dB)')
legend('-dynamiclegend', 'Location', 'SouthWest')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_controller_linear_phase', 'epsc')

%% Controller 2: non-linear phase
M = 20; % filter order

% Calculate matrix Q
% This assumes even symmetry
Q = zeros(length(wd), M+1); % initialized
n = 0:M; % time vector
for i = 1:length(wd) % for every frequency wi
    Q(i, :) = exp(-1j*wd(i)*n);
end

%% Least-squares algorithm
d = Hd.';               % Since we are using the theoretical Hd, Hd is already Hermitian symmetric
cls_nl = real(pinv(Q)*d); % use real() only to discard small imaginary part
Cls_nl = freqz(cls_nl, 1, wd);

figure, hold on, box on
plot(wd/pi, 20*log10(abs(Hd)), 'LineWidth', 2, 'DisplayName', 'Desired response')
plot(wd/pi, 20*log10(abs(Cls_nl)), '--', 'LineWidth', 2, 'DisplayName', 'FIR leasts-squares')
axis([-1 1 -50 30])
xlabel('\omega/\pi')
ylabel('Magnitude (dB)')
legend('-dynamiclegend', 'Location', 'SouthWest')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_controller_nonlinear_phase_mag', 'epsc')

figure, hold on, box on
plot(wd/pi, unwrap(angle(Hd)), 'LineWidth', 2, 'DisplayName', 'Desired response')
plot(wd/pi, unwrap(angle(Cls_nl)), '--', 'LineWidth', 2, 'DisplayName', 'FIR leasts-squares')
axis([-1 1 -50 30])
xlabel('\omega/\pi')
ylabel('Phase (rad)')
legend('-dynamiclegend', 'Location', 'SouthWest')
set(gca,'FontSize', 12)
% saveas(gca, '../figs/inverse_control_controller_nonlinear_phase_phase', 'epsc')

%% Testing
figure, hold on, box on
n = 0:39;
u = ones(40,1);
plot(n, u, 'LineWidth', 2, 'DisplayName', 'Unit step')
plot(n, filter(cls, 1, filter(b, a, u)), 'LineWidth', 2, 'DisplayName',  'Plant output')
xlabel('Time')
ylabel('Amplitude')
set(gca,'FontSize', 12)
legend('-dynamiclegend')
% saveas(gca, '../figs/inverse_control_unit_step', 'epsc')

n = 0:100;
s = sin(0.1*pi*n);
figure, hold on, box on
plot(n, s, 'LineWidth', 2, 'DisplayName', 'Controller input')
plot(n, filter(cls_nl, 1, filter(b, a, s)), 'LineWidth', 2, 'DisplayName', 'Plant output')
xlabel('Time')
ylabel('Amplitude')
set(gca,'FontSize', 12)
legend('-dynamiclegend')
% saveas(gca, '../figs/inverse_control_sin1', 'epsc')

n = 0:100;
s = sin(0.9*pi*n);
figure, hold on, box on
plot(n, s, 'LineWidth', 2, 'DisplayName', 'Controller input')
plot(n, filter(cls_nl, 1, filter(b, a, s)), 'LineWidth', 2, 'DisplayName', 'Plant output')
xlabel('Time')
ylabel('Amplitude')
set(gca,'FontSize', 12)
legend('-dynamiclegend')
axis([0 100 -1 1])
% saveas(gca, '../figs/inverse_control_sin2', 'epsc')
