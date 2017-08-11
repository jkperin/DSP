%% FFT of analog signals

[bz, az] = butter(2, 0.9);

[H, w] = freqz(bz, az);

plot(w/(pi), abs(H).^2)


h = hamming(51);
figure, plot(-25:25, h)
axis([-15 15 0 1])