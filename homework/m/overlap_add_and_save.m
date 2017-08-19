%% Overlap and save or overlap and add
clear, clc, close all

load('notch_filter_coeff'); % loads filter coefficients
load('ecg_recording.mat')  % loads ECG data

% Definitions
Nfft = 256;    % FFT length
M = length(hls) - 1; % M = 52
Loa = Nfft - M; % block length for overlap-add
Los = Nfft;     % block length for overlap-save
H = fft(hls, Nfft); % FFT of filter coefficients

t = 0:T:(N-1)*T; % time vector
ecg_fir = filter(hls, 1, ecg_60Hz);
ecg_fir = circshift(ecg_fir, [0, -M/2]); % remove group delay

%% Overlap-add
yoa = zeros(size(ecg_60Hz));
select = (1:Loa);
for r = 0:floor(length(ecg_60Hz)/Loa)-1
    xr = ecg_60Hz(select);           % non-overlapping segments of length Loa
    yr = ifft(H.*fft(xr, Nfft));    % compute Nfft-point circular convolution
    yoa(select(1):(select(1)+Nfft-1)) = yoa(select(1):(select(1)+Nfft-1)) + yr; % add
    select = select + Loa;
end

figure, hold on, box on
n = 0:length(ecg_60Hz)-1;
yoa = circshift(yoa, [0, -M/2]); % remove group delay
plot(t, ecg_clean, 'LineWidth', 2, 'DisplayName', 'Clean ECG')
plot(t, yoa, '--', 'LineWidth', 2, 'displayname', 'Overlap-add')
plot(t, ecg_fir, ':', 'LineWidth', 2, 'displayname', 'Direct form implementation')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
saveas(gca, '../figs/fir_notch_overlap_add', 'epsc')

%% Overlap-save
yos = zeros(size(ecg_60Hz));
select = (1:Los);
for r = 0:floor(length(ecg_60Hz)/Los)
    xr = ecg_60Hz(select);           % non-overlapping segments of length Loa
    yr = ifft(H.*fft(xr, Nfft));    % compute Nfft-point circular convolution
    yoa(select(M+1:end)) = yr(M+1:end); % save
    select = select + Los - M;
end

figure, hold on, box on
n = 0:length(ecg_60Hz)-1;
yoa = circshift(yoa, [0, -M/2]); % remove group delay
plot(t, ecg_clean, 'LineWidth', 2, 'DisplayName', 'Clean ECG')
plot(t, yoa, '--', 'LineWidth', 2, 'displayname', 'Overlap-save')
plot(t, ecg_fir, ':', 'LineWidth', 2, 'displayname', 'Direct form implementation')
legend('-dynamiclegend')
xlabel('Time (s)', 'FontSize', 12)
ylabel('ECG', 'FontSize', 12)
saveas(gca, '../figs/fir_notch_overlap_save', 'epsc')

%% Complexity calculation
M = 50:50:150;

C = @(N, M) (2*2*N.*(log2(N)-1) + N)./(N-M);

figure, hold on, box on
for k = 1:length(M)
    N = linspace(M(k)*2, 5e3);
    plot(N, C(N, M(k)), 'LineWidth', 2, 'DisplayName', sprintf('M = %d', M(k)))
end
xlabel('FFT length, N', 'FontSize', 12)
ylabel('Complexity, C', 'FontSize', 12)
legend('-dynamiclegend')
saveas(gca, '../figs/block_conv_complexity', 'epsc')