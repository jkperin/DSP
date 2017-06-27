%% EE 264: Digital Signal Processing, Summer 2017
% Jose Krause Perin

%% Equalization demo
clear, clc, close all

Nsymb = 2^13; % Number of symbols
M = 2; % M-PAM order
Mct = 9; % oversampling rate to emulate continuous time
L = 12;
mu = 1e-3;

dataTX = randi([0, 1], [1 Nsymb]); % generate binary data
dataTX(1:2) = [0 1];
x = pammod(dataTX, M, 0, 'gray'); % generate PAM signal

% Generate analog data
ximp = upsample(x, Mct);
hps = rcosdesign(0.2, 6, Mct, 'normal'); % pulse shapping filter coefficients
n = length(hps);
hps = hps/hps((n+1)/2);
xt = filter(hps, 1, ximp); % transmitted analog signal

% Channel
Nch = 20;
num = fir1(Nch, 0.01/Mct);
den = 1;
% num = [0.0462 0.0925 0.0462];
% den = [1 -1.1398 0.3248];

% Received signal
yt = filter(num, den, xt);
yt = circshift(yt, [0, -Nch/2-1]);

% Decision directed equalizer
heq = zeros(1, 2*L+1); 
heq(L+1) = 1; % initialize equalizer as
e = zeros(size(yt)); % error vector
yeq = zeros(size(yt)); % error vector
for k = L+1:length(yt)-L
    yeq(k) = sum(heq.*yt(k+L:-1:k-L)); % equalizer output
    e(k) = yeq(k) - xt(k);
    heq = heq - 2*mu*e(k)*yt(k+L:-1:k-L);
end

y = sign(yeq);
y(y < 0) = 0;
dataRX = y(ceil(Mct/2):Mct:end);

[~, ber] = biterr(dataRX(500:end), dataTX(500:end))

figure, hold on
plot(xt)
plot(yt)
plot(yeq)
axis([Nsymb*Mct-200 Nsymb*Mct  -1 1])
legend('xt', 'yt', 'yeq')
figure, plot(abs(e).^2)
figure, stem(heq)

