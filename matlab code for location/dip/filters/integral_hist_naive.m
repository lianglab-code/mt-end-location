function inhist = integral_hist_naive(img,varargin)
%% INTEGRAL_HIST_NAVIE implements the integral histogram algorithm.
%
% inhist = integral_hist_naive(img)
%
% INPUT:
% img: 2d image, [M N], range: 0-255
% num_bins: number of bins
%
% OUTPUT:
% inhist: integral histogram, [M+1 N+1 num_bins]
%
% NOTE:
% The output inhist is similar to the output of MATLAB's
% integralImage, rather than that of VL's vl_inthist.
% The output can be used by filter_inhist_naive.m written by
% JERVIEDOG.

if ndims(img)>2
    error('pls input 2d matrix');
    return;
end

if nargin>1
    num_bins = varargin{1};
else
    num_bins = 256; % if max(img(:)) is larger than 255, the value
                    % larger than 255 will be ignored
end

img = round(img);
[M,N] = size(img);
inhist = zeros(M+1,N+1,num_bins);

for ii=1:num_bins
    inhist(:,:,ii) = integralImage(img==(ii-1));
end
