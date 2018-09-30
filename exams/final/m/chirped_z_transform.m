function X = chirped_z_transform(x, A, W)

N = length(x);

n = (0:N-1).';

W = W.^(-n.^2/2);

X = conj(W).*ifft(fft(x.*(A.^(-n)).*conj(W)).*fft(W));


