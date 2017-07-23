function [xq, e] = quantizer(x, B, range_lims)
%% B-bit quantizer with range determined by range_lims

DeltaX = range_lims(2) - range_lims(1); % dynamic range
Delta = DeltaX/(2^B); % step size

% Quantization levels start at range_lims(1) and go up to range_lims(2) in
% Delta increments. This is the codebook for the quantiz function
levels = range_lims(1):Delta:range_lims(2);
[~, xq] = quantiz(x, levels(1:end-1)+Delta/2, levels); 
% The codebook is shifted by Delta/2 in order to obtain the partitions

xq = xq.'; % transpose to preserve same dimensionality as x
e = x - xq; % quantization error

