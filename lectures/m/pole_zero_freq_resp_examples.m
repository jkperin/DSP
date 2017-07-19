%% Clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

%% 4-point moving average system
b = [1 1 1 1]/4;
a = 1;

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% Low-pass filter
close all
b = 0.05634*conv([1 1], [1 -1.0166 1]);
a = conv([1 -0.683], [1 -1.4461 0.7957]);

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% two poles and two zeros
close all
p = 0.5*exp(1j*pi/4);
z = 0.9*exp(1j*pi/2);
b = sqrt(10^(-1))*conv([1 -z], [1 -conj(z)])
a = conv([1 -p], [1 -conj(p)])

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% All-pass
close all
p = 0.9*exp(1j*pi/3);
b = conv([1 -1/p], [1 -1/conj(p)])
a = conv([1 -p], [1 -conj(p)])

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% 4-point moving average system
close all
b = [1 1 1 1 1]/5;
a = 1;

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% Second-order system
close all
p = 0.9*exp(1j*pi/3);
a = conv([1 -p], [1 -conj(p)]);
b = 1;

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')

%% Second-order system
close all
p = 0.9*exp(1j*pi/3);
a = conv([1 -p], [1 -conj(p)]);
b = 1;

zplane(b, a)
m = matlab2tikz(gca, 1)
m.write('zplan.tex')

[h, w] = freqz(b, a);
figure, plot(w/pi, 20*log10(abs(h)));
m = matlab2tikz(gca);
m.write('mag_resp.tex')

figure, plot(w/pi, rad2deg(unwrap(angle(h))));
m = matlab2tikz(gca);
m.write('phase_resp.tex')