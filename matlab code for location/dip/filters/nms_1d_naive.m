function out = nms_1d_naive(in,n)
%% NMS_1D_NAIVE suppresses the non-maximum values of the input 1d array
% out = nms_1d_naive(in,n,varargin)
%
% INPUT:
% in: 1d input array
% n: window radius
% 
% OUTPUT:
% out: non-maximum suppressed output
%
% REFERENCE:
% Efficient Non-Maximum Suppression, Neubeck and van Gool
%
% NOTE:
% Multiple maxima are not suppressed, not like nms_1d.m

in = reshape(in,[1,numel(in)]);
Win = numel(in);
I = padarray(in,[0,n],-inf,'both');
W = numel(I); % width
out = inf(1,W)*(-1);

for i = (n+1):(n+Win)
    if I(i) == max(I((i-n):(i+n)))
        out(i) = I(i);
    end
end

out = out((n+1):(Win+n));
