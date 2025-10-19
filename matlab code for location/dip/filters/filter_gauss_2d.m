function out = filter_gauss_2d(in, sigma, kernel_size)
%% FILTER_GAUSS_2D applies a gaussian filter to an image
% - Output:
%     out: filtered image
% - Input:
%     in: 2D monochrome image
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

[M,N,L] = size(in);
out = zeros(M,N,L);
in = double(in);
for i = 1:L
    temp = conv2(in(:,:,i), g, 'same');
    out(:,:,i) = conv2(temp, g', 'same');
end

end

