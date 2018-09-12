%% Chirped transform
close all

N = 64;
L = 64;
w0 = 0.3*pi;
w1 = 0.35*pi;

n = (0:L-1).';
x = 2*cos(w0*n) + 2*cos(w1*n + pi/4);
x = x + sqrt(0)*randn(size(x));

dw = 2*pi/L;
w = -pi:dw:pi-dw;

y = x;

figure, box on, hold on
plot(w/pi, abs(fftshift(fft(y, N))).^2)

% 
X = chirped_z_transform(x, exp(1j*pi*0.25), exp(-1j*0.15*pi/N));

figure, box on, hold on
plot(abs(fftshift(fft(X, N))).^2)


