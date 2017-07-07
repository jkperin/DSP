%% Interpolation with zoh, linear, and cubic
clear, clc, close all

addpath('D:\Jose\Dropbox\research\codes\f')

t = linspace(0, 21);
y = @(t) cos(2*pi*0.15*t);
ys = y(0:21);
T = 1;

tlin = linspace(-T, T, 11);
hlin = 1-abs(tlin)/T;

yss = upsample(ys, 5);
yrec = filter(hlin,1, yss);
yrec = circshift(yrec, [0, -5]);
dt = 1/(T*5);
tt = 0:dt:21-dt;

figure, hold on, box on
plot(tt, yrec(1:length(tt)))
plot(tt, interp1(0:21, ys, tt), '--r')

m = matlab2tikz(gca);
m.write('linear_interp.tex')


%% Spline
a = 0.1;
tspline = linspace(-2*T, 2*T, 51);
tnorm = abs(tspline)/T;
hspline = ((a+2)*tnorm.^3 - (a+3)*tnorm.^2 +1).*(abs(tnorm) <= T)...
    +(a*tnorm.^3 - 5*a*tnorm.^2 + 8*a*tnorm - 4*a).*(abs(tnorm) > T);

w = linspace(-1.2*2*pi/T, 1.2*2*pi/T);
f = w/(2*pi);
Hspline = 12*T./(w*T).^2.*(sinc(f*T).^2 - sinc(2*f*T))...
    + 8*a*T./(w*T).^2.*(3*sinc(2*f*T).^2 - 2*sinc(2*f*T) - sinc(4*f*T));

figure
plot(tspline, hspline)
m = matlab2tikz(gca);
m.write('spline_impulse_resp.tex')

figure
plot(w, abs(Hspline))
m = matlab2tikz(gca);
m.write('spline_freq_resp.tex')

% reconstruction
tlin = linspace(-2*T, 2*T, 21);
tnorm = abs(tspline)/T;
hspline = ((a+2)*tnorm.^3 - (a+3)*tnorm.^2 +1).*(abs(tnorm) <= T)...
    +(a*tnorm.^3 - 5*a*tnorm.^2 + 8*a*tnorm - 4*a).*(abs(tnorm) > T);

yss = upsample(ys, 10);
yrec = filter(hspline,1, yss);
yrec = circshift(yrec, [0, -25]);
dt = 1/(T*10);
tt = 0:dt:21-dt;

figure, hold on, box on
plot(t, y(t))
plot(tt, yrec(1:length(tt)))

m = matlab2tikz(gca);
m.write('spline_interp.tex')

% Spectrum for interpolation comparison
T = 2*pi/10;
a = -0.5;
w = linspace(-13, 13);
f = w/(2*pi);
Hspline = 12*T./(w*T).^2.*(sinc(f*T).^2 - sinc(2*f*T))...
    + 8*a*T./(w*T).^2.*(3*sinc(2*f*T).^2 - 2*sinc(2*f*T) - sinc(4*f*T));

Hspline = 6*Hspline/max(abs(Hspline));
figure
plot(w, abs(Hspline))
m = matlab2tikz(gca);
m.write('spline_freq_resp2.tex')

