function [p, x] = out_prob(L)

p2 = [1 1]/2; % pmf for L = 1
p = p2;
for k = 1:L-1
    p = conv(p, p2);
end

% since x takes on equally spaced values between -1 and 1
x = linspace(-1,1, length(p)); 
