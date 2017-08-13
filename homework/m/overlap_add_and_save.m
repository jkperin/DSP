%% Overlap and save or overlap and add

M = 50:50:150;

C = @(N, M) 3*2*N.*(log2(N)-1)./(N-M);

figure, hold on
for k = 1:length(M)
    N = linspace(M(k)*2, 5e3);
    plot(N, C(N, M(k)))
end