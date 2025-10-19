function out = filter_gauss_1d(in, sigma, kernel_size)
%% FILTER_GAUSS applies a gaussian filter to an 1d series
% - Output:
%     out: filtered series
% - Input:
%     in: 1d series
%     sigma: sigma of the gaussian filter
%     kernel_size: size of the gaussian kernel (default: 6*sigma)

% Adapted from Gonzalo Vaca-Castano's tutorial slide

if nargin < 2
    sigma = 1;
end
if nargin < 3
    kernel_size = 6*sigma;
end

r = floor(kernel_size/2); % radius
x = [-r:r];
g = exp(-x.^2/(2*sigma^2))/(sigma*sqrt(2*pi)); % filter
out = conv(double(in), g, 'same');
end

