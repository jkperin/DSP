%% Template for notch filtering of ECG signals
clear, clc, close all

%% Loads ECG signal from file
% This loads the following variables:
% - ecg_clean: ecg_signal without 60 Hz interference. Use this only for
% comparison
% - ecg_60Hz: ECG signal corrupted by 60 Hz interference
% - N: length of the vectors ecg_clean and ecg_60Hz
% - T (in seconds): sampling period of ECG recordings. T = 3 ms.
load('ecg_recording.mat') 
% Note: these signals are real ECG recordings made with standard ECG recorders, 
% leads, and electrodes. The quality is typical of ambulatory ECG recordings.
% The 60 Hz component was introduced artificially for this exercise.
% The complete database can be found online on PhysioNet [1]: 
% http://www.physionet.org/physiobank/database/nstdb/
% This database is discrebed in [2].
% References:
% [1] Goldberger AL, Amaral LAN, Glass L, Hausdorff JM, Ivanov PCh, Mark RG, 
% Mietus JE, Moody GB, Peng C-K, Stanley HE. PhysioBank, PhysioToolkit, and 
% PhysioNet: Components of a New Research Resource for Complex Physiologic 
% Signals. Circulation 101(23):e215-e220 [Circulation Electronic Pages; 
% http://circ.ahajournals.org/content/101/23/e215.full]; 2000 (June 13).
% [2] Moody GB, Muldrow WE, Mark RG. A noise stress test for arrhythmia detectors. 
% Computers in Cardiology 1984; 11:381-384.

t = 0:T:(N-1)*T; % time vector

% Plot signals
figure, box on, hold on
plot(t, ecg_clean, 'k')
plot(t, ecg_60Hz)
xlabel('Time (s)')
ylabel('ECG')
legend('Clean ECG', 'ECG corrupted by 60 Hz')

%% Your code goes here
