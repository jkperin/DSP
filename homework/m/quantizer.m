function [xq, e] = quantizer(x, B, range_lims)

DeltaX = range_lims(2) - range_lims(1);
Delta = DeltaX/(2^B); % step size

levels = range_lims(1):Delta:range_lims(2);
[~, xq] = quantiz(x, levels(1:end-1)+Delta/2, levels);

xq = xq.';
e = x - xq;

