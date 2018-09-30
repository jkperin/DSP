%% 
clear,  close all

%% Continuous-time Fresnel transform
N = 6e3;
fs = 1e9;
dt = 1/fs;
t = ((-N/2):(N/2)-1)*dt;
df = fs/(N);
f_ct = -fs/2:df:fs/2-df;
alpha_ct = 9e14;

H_ct = exp(1j*pi*f_ct.^2/alpha_ct);
h_ct = sqrt(1j*alpha_ct)*exp(1j*pi*alpha_ct*t.^2);

figure
subplot(211)
plot(f_ct/1e6, abs(H_ct))

subplot(212)
plot(f_ct/1e6, unwrap(angle(H_ct)))

figure
plot(t, real(h_ct), t, imag(h_ct))

%% Bandlimiting the CT Fresnel transform
fc = 500e6;
wc = 2*pi*fc;
win = wc/pi*sinc(wc/pi*t);

h_tilde = conv(h_ct, win, 'same')/1e16;
hinv = 100*fftshift(ifft(ifftshift(H_ct)));

figure, hold on
plot(t, real(h_tilde)) %, t, imag(h_tilde))
plot(t, real(hinv)) %, t, imag(hinv))



% H_tilde = fft(ifftshift(h_tilde));
% 
% figure
% subplot(211)
% plot(f_ct/fs, abs(H_tilde))
% 
% subplot(212)
% plot(f_ct/fs, unwrap(angle(H_tilde)))


% 
% df = 0.01;
% f = -0.5:df:0.5-df;
% alpha = 1e-2;
% 
% figure, 
% subplot(211)
% plot(f, abs(X))
% subplot(212)
% plot(f, unwrap(angle(X)))
% 
% N = length(f);
% n = 0:N-1;
% x_t = @(n) 1/200*exp(1j*pi*alpha*n.^2);
% x_tilde = 0;
% for r = -10:10
%     x_tilde = x_tilde + x_t(n-r*N);
% end
% 
% xinv = ifft(ifftshift(X));
% 
% figure
% subplot(211), hold on
% plot(real(xinv))
% plot(real(x_tilde))
% subplot(212), hold on
% plot(imag(xinv))
% plot(imag(x_tilde))
% 
% mean(abs(x_tilde-xinv).^2)
% 
% % figure, 
% % subplot(211)
% % plot(f, abs(X))
% % subplot(211)
% % plot(f, unwrap(angle(X)))
