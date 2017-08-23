%% Hearing aid problem 
clear, clc, close all

T = 1/22.05e3;     % sampling time in seconds
f = 1e3*[0.1 0.5 1 2 3 4 5 6 7 8 9 10]; % in Hz
A = [0 0 0 -10 -12 -17 -22 -29 -34 -39 -47 -50]; % in dB

%% a)
w_spec = 2*pi*f*T;

% Plot results
figure, box on
plot(w_spec/pi, -A, 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('20log_{10}(|H_d(e^{j\omega}|)', 'FontSize', 12)
axis([0 1 0 60])
% saveas(gca, '../figs/hearing_aid_spec', 'epsc')
    
%% b)
Hd = 1./(10.^(A/20).*sinc(w_spec/(2*pi)).^2);
figure, plot(w_spec/pi, 20*log10(abs(Hd)))

% Plot results
figure, box on
plot(w_spec/pi, 20*log10(abs(Hd)), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('20log_{10}(|H_d(e^{j\omega}|)', 'FontSize', 12)
axis([0 1 0 60])
% saveas(gca, '../figs/hearing_aid_corrected_spec', 'epsc')

%% c)
for M = 3:100
    hls = firls(M, w_spec/pi, Hd); % design filter of order M
    error = 20*log10(abs(freqz(hls, 1, w_spec))./abs(Hd));
    if all(abs(error) < 1) % error is smaller than 1 dB at all frequencies
        break
    end
end

M % filter order that meets specs
[Hls, w] = freqz(hls, 1);

% Plot results
figure, hold on, box on
stem(w_spec/pi, 20*log10(abs(freqz(hls, 1, w_spec))./abs(Hd)), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Error (dB)', 'FontSize', 12)
axis([0 1 -1 1])
% saveas(gca, '../figs/hearing_aid_filter_error', 'epsc')

figure, hold on, box on
plot(w_spec/pi, 20*log10(abs(Hd)), 'r', 'LineWidth', 2)
plot(w/pi, 20*log10(abs(Hls)), 'k', 'LineWidth', 2)
legend('Specification', sprintf('Least-squares FIR M = %d', M),...
    'Location', 'SouthEast')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
% saveas(gca, '../figs/hearing_aid_filter_mag', 'epsc')

figure, box on
plot(w/pi, unwrap(angle(Hls)), 'k', 'LineWidth', 2)
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Phase (rad)', 'FontSize', 12)
% saveas(gca, '../figs/hearing_aid_filter_phase', 'epsc')

%% d)
% Could also have used grpdelay(hls, 1, 1)
delay_samples = M/2 % delay of linear phase filter
delay_time = delay_samples*T

%% e)
% Quantization noise power
DeltaX = 2;
B = 10:20;
Delta = DeltaX./2.^B;
varQ = Delta.^2/12;

varQuant = varQ*sum(abs(hls).^2);

% Plot results
figure, box on, hold on
stem(B, 10*log10(varQuant/1e-3), 'k', 'LineWidth', 2)
plot([B(1) B(end)], [-30 -30], 'r')
xlabel('Resolution (bits)', 'FontSize', 12)
ylabel('Output quantization noise average power (dBm)', 'FontSize', 12)
% saveas(gca, '../figs/hearing_aid_quant_noise_var', 'epsc')

%% f)
% Roundoff noise
Nmult = floor(M/2+1);

% Rounoff noise is not enhanced by filter
varRoundOff = Nmult*(1./(2.^(B-1))).^2/12;

% Plot results
figure, box on, hold on
stem(B, 10*log10((varRoundOff + varQuant)/1e-3), 'k', 'LineWidth', 2)
plot([B(1) B(end)], [-30 -30], 'r')
xlabel('Resolution (bits)', 'FontSize', 12)
ylabel('Output noise variance (dBm)', 'FontSize', 12)
% saveas(gca, '../figs/hearing_aid_total_noise_var', 'epsc')

%% g)
B = 18;
Delta = DeltaX/2^B;
varQ = Delta^2/12;
varRoundOff = Nmult*(1/(2^(B-1)))^2/12;

% 
q = sqrt(varQ)/sqrt(1/12)*(rand(1, 10e4)-0.5); % quantization noise
roundoff = sqrt(varRoundOff)/sqrt(1/12)*(rand(1, 10e4)-0.5); % roundoff noise

% Quantization noise is shaped by the filter, but roundoff noise is not 
noise = filter(hls, 1, q) + roundoff;

% PSD estimation
M = 1024;
L = 2*M-1;
window = bartlett(L).';
dw = 2*pi/L;
w = -pi:dw:pi-dw; % frequency vector

Pw = blackman_tukey_psd(noise, window, M);

% Average power estimation
estimatedNoisePower = trapz(w, Pw)/(2*pi);
estimatedNoisePowerdBm = 10*log10(estimatedNoisePower/1e-3)

% Theoretical PSD
Hls = freqz(hls, 1, w);
Ptheory = varQ*abs(Hls).^2 + varRoundOff;

theoreticalNoisePower = trapz(w, Pw)/(2*pi);
theoreticalNoisePowerdBm = 10*log10(theoreticalNoisePower/1e-3)

% Plot results
figure, box on, hold on
plot(w/pi, 10*log10(Pw/1e-3), 'r', 'LineWidth', 2)
plot(w/pi, 10*log10(Ptheory/1e-3), 'k', 'LineWidth', 2)
legend('Theory', 'Estimated PSD', 'Location', 'SouthEast')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dBm)', 'FontSize', 12)
saveas(gca, '../figs/hearing_aid_psd', 'epsc')
