%% Quantization of Gaussian
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

N = 1e6;
sigma = 1;
delta = 2.1*sigma;
xmax = 20;
thresholds = delta/2:delta:xmax;
thresholds = [-thresholds(end:-1:1) thresholds];

x = sigma*randn(1, N);

[~, xQ] = quantiz(x, thresholds(2:end), thresholds + delta/2);

e = x - xQ;

figure, 
Nbins = 50;
[counts, centers] = hist(e, Nbins);

counts = counts/(delta/Nbins*sum(counts))

bar(centers, counts)

figure, plot(centers, counts)
m = matlab2tikz(gca);
m.write('hist_out.tex')

% axis([-0.5 0.5 0 1.2*N/50])

