%% Noise canceling
clear, clc, close all
 
[s, Fs] = audioread('guitartune.wav'); % Fs is sampling frequency

Nruns = 20; % number of independent runs to average learning curve
var_r = 2e-3; % variance of white Gaussian noise

L = 49; % adaptive filter order. L+1 coefficients

% H(z) filter coefficients 
% Although H(z) is "unknown", for developing your answers you can use this
% filter. It is a eighth-order IIR Chebyshev type II filter with bandwidth
% 0.55*Fs. Chebyshev type II filters have constant gain at the passband, 
% but they exhibit ripples in the stopband. 
[hb, ha] = cheby2(6, 30, 0.55);
hb = [zeros(1, 20) hb]; % Add a delay of 20 samples to H(z)
% Hint: for filtering, use the function filter, e.g., output = filter(hb, ha, input)

%% Your solutions go here
% Matlab hints: 
% - The function randn() generates zero-mean, unit-variance,
% Gaussian-distributed numbers
% - Fixed filters can be easily implement using the function filter()
% - Adaptive filters are can be implemented in a for loop
% - To plot the coefficients of an FIR filter, use the function impz
% (impulse response)
% - To plot the magnitude and phase response, use the function freqz()
% - To play a signal use the function sound(x, Fs). Don't forget to include
% the sampling frequency when calling sound, otherwise Matlab will assume 
% Fs = 8 kHz, which is not the correct value.
sound(s, Fs) % example


%% Your solutions go here
% (C) adaptation constant
lamb = var_r; % all eigenvalues are equal to var_r since R = var_r*I
mu = 0.001/((L+1)*var_r)

% (D) convergence time
tau = 1/(4*mu*lamb); % learning curve time constants
T_conv = 4*tau/Fs % convergence time

% (F) Implementation
% Generate input white noise
r = sqrt(var_r)*randn(size(s));
rf = filter(hb, ha, r);

% Generate signal x
x = s + rf; % from diagram in Fig. 2

avg_noise = zeros(size(s));
for q = 1:Nruns
    y = zeros(size(s)); % output of adaptive filter
    e = zeros(size(s)); % error signal
    W = zeros(1, L+1); % initial weight vector
    for k = L+1:length(s)
        y(k) = W*r(k:-1:k-L);
        e(k) = x(k) - y(k);
        W = W + 2*mu*e(k)*r(k:-1:k-L).';
    end
    
    avg_noise = avg_noise + (s-e).^2;
end

avg_noise = avg_noise/Nruns;

figure, box on
plot((0:length(s)-1)/Fs, avg_noise)
xlabel('Time (seconds)')
ylabel('Average noise')
saveas(gca, '../figs/part1_average_noise', 'epsc')

figure, impz(W)
saveas(gca, '../figs/part1_coeff', 'epsc')

[H1, w] = freqz(hb, ha);
H2 = freqz(W, 1, w);

figure
subplot(211), hold on, box on
plot(w/pi, 20*log10(abs(H1)))
plot(w/pi, 20*log10(abs(H2)))
xlabel('Normalized frequency (\times\pi rad/samples)')
ylabel('Magnitude response (dB)')
legend('H(z)', 'Adaptive filter')

subplot(212), hold on, box on
plot(w/pi, unwrap(angle(H1)))
plot(w/pi, unwrap(angle(H2)))
xlabel('Normalized frequency (\times\pi rad/samples)')
ylabel('Phase response (rad)')
legend('H(z)', 'Adaptive filter')
saveas(gca, '../figs/part1_freqz', 'epsc')
