function BER = simple_channel(h)
%% Computes the BER of transmission over a simple channel with equalizer h
% Input:
% - h : coefficients of the FIR equalizer
% Output:
% - BER : bit error rate

% Channel variables
sigma2 = 0.001;
c = [0.4032    0.3992    0.1976];

% Simulation variables
Nbits = 1e4;        % number of bits
Ndiscard = 100;     % number of bits to be discarded from BER computation

% Generates signal
x = randi([0 1], [1 Nbits]); % generates a binary vector with Nbits elements

% Filter and add noise
y = filter(c, 1, x);
y = y + sqrt(sigma2)*randn(size(y)); % adds noise

% Equalization
y = filter(h, 1, y); % received signal

% Detect bits
d = double(y > 0.5); 

% Count BER
[~, BER] = biterr(d(Ndiscard:end-Ndiscard), x(Ndiscard:end-Ndiscard));
