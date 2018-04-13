%% Example of FIR bandpass filter design using Parks-McClellan and least-squares algorithms
% Problem described in lecture notes 9, slide 
clear, clc, close all

N = 100;                   % number of samples in the frequency domain
L = 51;                    % Filter length (number of coefficients)
M = L - 1;                 % Filter order 
w = linspace(0, pi, N).';  % frequency vector omega (N x 1)

% Desired frequency response
d = zeros(size(w));  
d(w >= 0.5*pi & w <= 0.7*pi) = 1; % bandpass filter between 0.5*pi and 0.7*pi

% Weight function. 
% Transition band
Deltaw = 0.1*pi; % transition band width
wv  = ones(size(w));
wv(w > 0.5*pi-Deltaw & w < 0.5*pi) = 0; % transition band (don't care)
wv(w > 0.7*pi & w < 0.7*pi+Deltaw) = 0; % transition band (don't care)
W = diag(wv); % diagonal matrix W

% Calculate matrix Q
% This assumes even symmetry
Q = zeros(N, floor(M/2)+1); % initialized
n = 0:floor(M/2); % time vector
for i = 1:N % for every frequency wi
    Q(i, :) = 2*cos(w(i)*(M/2-n));
    if mod(M, 2) == 0 % M even
        Q(i, end) = 1;
    end
end

% Define parameter k used to append vectors
if mod(M, 2) == 0 % M even
    k = 1;
else % M odd
    k = 0;
end

%% Parks-McClellan as a linear program
% To run this part you must have CVX installed
% (http://cvxr.com/cvx/doc/install.html)
% cvx_begin
%     variable u(1)
%     variable h(floor(M/2)+1) 
%     minimize u
%     subject to 
%     -u <= W*(d - Q*h) <= u
% cvx_end
% 
% hpm =[h; h(end-k:-1:1)];

% Matlab Parks-McClellan FIR filter design
hpmMat = firpm(M, w(wv ~= 0)/pi, d(wv ~= 0));

% Plot results
% Hpm = freqz(hpm, 1, w);    
HpmMat = freqz(hpmMat, 1, w);

figure, subplot(211), hold on, box on
% plot(w/pi, 20*log10(abs(Hpm)), 'LineWidth', 2, 'DisplayName', 'PM cvx')
plot(w/pi, 20*log10(abs(HpmMat)), 'LineWidth', 2, 'DisplayName', 'firpm')
plot(w/pi, 20*log10(d), ':k', 'LineWidth', 2, 'DisplayName', 'Desired response')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
title('Parks-McClellan FIR filter design')
set(gca, 'FontSize', 12)
legend('-dynamiclegend', 'Location', 'NorthEast')
% axis([0 1 -50 10])

%% Least-squares algorithm
h = pinv(W*Q)*(W*d);

hls =[h; h(end-k:-1:1)]; % append to get filter coefficients

% Matlab least-squares FIR filter design
hlsMat = firls(M, w(wv ~= 0)/pi, d(wv ~= 0));

% Plot results
Hls = freqz(hls, 1, w);    
HlsMat = freqz(hlsMat, 1, w);

figure(1), subplot(212), hold on, box on
plot(w/pi, 20*log10(abs(Hls)), 'LineWidth', 2, 'DisplayName', 'Least squares')
plot(w/pi, 20*log10(abs(HlsMat)), 'LineWidth', 2, 'DisplayName', 'firls')
plot(w/pi, 20*log10(d), ':k', 'LineWidth', 2, 'DisplayName', 'Desired response')
xlabel('\omega/\pi', 'FontSize', 12)
ylabel('Magnitude (dB)', 'FontSize', 12)
title('Least-squares FIR filter design')
set(gca, 'FontSize', 12)
legend('-dynamiclegend', 'Location', 'NorthEast')
% axis([0 1 -50 10])


