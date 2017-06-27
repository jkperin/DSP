%% Quantization
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f\')
addpath('C:\Users\Joe\Dropbox\research\codes\ofdm\')

Ofdm = ofdm(64, 56, 16, 100e9, 'DSB', 'none');
Ofdm.set_cyclic_prefix(0, 0);

x = Ofdm.signal(100);

Nbits = 3;
xmax = max(abs(x));
xmin = -xmax;
dx = (xmax-xmin)/(2^Nbits-1);
codebook = xmin:dx:xmax;
partition = codebook(1:end-1) + dx/2;
[~, xq, varQ] = quantiz(x, partition, codebook); 

figure, hold on, box on
plot(x)
%plot(x)
%plot([0 50], [1;1]*codebook)
plot(xq)
axis([0 50 -25 25])

m = matlab2tikz(gca);
m.write('quantization_example.tex')

figure
plot((x-xq)/dx)
axis([0 50 -0.5 0.5])

m = matlab2tikz(gca);
m.write('quantization_error.tex')

Nbins = 20;
[counts,centers] = hist((x-xq)/dx, Nbins);

bar(centers, Nbins*counts/sum(counts))

y = Nbins*counts/sum(counts);

for k = 1:length(y)
    fprintf('(%f, %f) ', centers(k), y(k))
end
