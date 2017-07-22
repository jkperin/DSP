%% Plant identification by noise injection
clear, clc, close all

% Coefficients for H(z)
b = 0.05634*conv([1 0.9], [1 -1.0166 0.8]);
a = conv([1 -0.683], [1 -1.4461 0.7957]);

figure, zplane(b, a)

sigma_x = 1; % average power of input noise

%% Your code goes here
