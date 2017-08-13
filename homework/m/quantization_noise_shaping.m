%% Template for Homework #3: Problem 3 on quantization and quantization noise shaping
clear, clc, close all % clear variables

% Load speech signal
[x, Fs] = audioread('speech_dft.wav');          % Fs is sampling frequency
T = 1/Fs;                                       % sampling period

%% Important: 
% If your simulations take too long because you're using a slow computer,
% you can uncomment the following line in order to use just part of the 
% speech signal. Specifically, you may use just the first 43000 samples, 
% which correspond to the phrase "The discrete Fourier transform". 
% In my computer, the simulations with the whole signal took < 1 s.
% x = x(1:43e3); % play just part of the speech

%% Your code goes here
%sound(x, Fs) % Play speech

% Define parameters
range_lims = [-1 1];           % range limits                  
B = 4; % quantizer resolution

%% Part (b)
maxLag = 10;
[~, e4bits] = quantizer(x, 4, range_lims); 
[~, e10bits] = quantizer(x, 10, range_lims); 

c4bits = xcorr(e4bits, e4bits, maxLag, 'unbiased');
c10bits = xcorr(e10bits, e10bits, maxLag, 'unbiased');

e4bits_power = c4bits(maxLag+1); % autocorrelation at m = 0;
e10bits_power = c10bits(maxLag+1); % autocorrelation at m = 0;

% Plot autocorrelation function
figure, subplot(211), box on
stem(-maxLag:maxLag, c4bits)
legend('B = 4 bits')
xlabel('m', 'FontSize', 12)
ylabel('Empir. autocorrelation', 'FontSize', 12)
set(gca, 'FontSize', 12)
subplot(212), box on
stem(-maxLag:maxLag, c10bits)
legend('B = 10 bits')
xlabel('m', 'FontSize', 12)
ylabel('Empir. autocorrelation', 'FontSize', 12)
set(gca, 'FontSize', 12)
saveas(gca, '../figs/hw03_q4_empir_xcorr', 'epsc')

%% Part (c)
B = 4; % quantizer resolution
b = [1 -1]; % shaping filter coefficients

[xq, e] = quantizer(x, B, range_lims); 

eshaped = filter(b, 1, e);

xqshaped = x + eshaped;
%sound(xqshaped, Fs)

%% Part (d)
B = 4; % quantizer resolution
b = [1 -1]; % shaping filter coefficients
M = 3; % upsampling factor 
[xq, e] = quantizer(x, B, range_lims); 

eup = upsample(e, M);
eshaped = filter(b, 1, eup);
ef = M*decimate(eshaped, M); % Note multiplication by M in order to account 
% for the fact that in Fig. 6a the signal is also decimated

xqshaped = x + ef;
sound(xqshaped, Fs)

ef_power = mean(abs(ef).^2); % can use var only if ef is zero mean

SNRimprovement = 10*log10(e4bits_power/ef_power)

Bimprovement = SNRimprovement/6.02