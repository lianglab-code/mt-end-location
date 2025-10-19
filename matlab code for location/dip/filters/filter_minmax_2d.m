function out = filter_minmax_2d(in,mode,r)
%% FILTER_MINMAX_2D calculates the min/max in a window with
% diameter r
% out = filter_minmax_2d(in,mode,r)

%% INPUT:
% in: input image
% mode: 'min' or 'max'
% r: window half-size

%% OUTPUT:
% out: min/max filtered image

%% REFERENCE:
% Herk, A fast algorithm for local minimum and maximum filters on
% rectangular and octagonal kernels

%% NOTE:

if ndims(in)~=2
    error('2d image is required');
    return;
end

[h,w] = size(in);

mode = lower(mode);
if strcmp(mode,'max')
    out = -in;
elseif strcmp(mode,'min')
    out = in;
else
    error('mode must be max or min');
    return;
end

for ii = 1:w
    out(:,ii) = filter_minmax_1d(out(:,ii),'min',r);
end

out = out.';

for ii = 1:h
    out(:,ii) = filter_minmax_1d(out(:,ii),'min',r);
end

out = out.';

if strcmp(mode,'max')
    out = -out;
end
