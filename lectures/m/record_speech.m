%% Record data 
clear, clc, close all

addpath('C:\Users\Joe\Dropbox\research\codes\f')

Fs = 8e3;
recObj = audiorecorder(Fs, 16, 2);
disp('Start speaking.')
recordblocking(recObj, 15);
disp('End of Recording.');

% Play back the recording.
play(recObj);

% Store data in double-precision array.
myRecording = getaudiodata(recObj);

% Plot the waveform.
plot(myRecording);

m = matlab2tikz(gca);
m.write('speech.tex')

audiowrite('myRecording.wav', myRecording, Fs);

% myRecording = (myRecording(1e4:end, 1) + myRecording(1e4:end, 2))/2;
myRecording = myRecording(1e4:end, 1);
myRecording = myRecording - mean(myRecording);

Nbins = 20;
[counts,centers] = hist(myRecording, Nbins);

y = Nbins*counts/sum(counts);

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',0,...
               'Upper',Inf,...
               'StartPoint',10);
ft = fittype('1/(2*a)*exp(-abs(x)/a)','options',fo);
f = fit(centers.', y.', ft);

Laplace = @(x, a) 1/(2*a)*exp(-abs(x)/a);

figure, hold on
bar(centers, y)
x = linspace(centers(1), centers(end));
plot(x, f(x))