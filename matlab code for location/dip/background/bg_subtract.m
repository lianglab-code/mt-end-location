function out = bg_subtract(in, r)
%% BG_SUBTRACT subtracts the background from the input image.
% It calculates a mean value of a 2D region centered at the current
% position and subtracts it from the value of the current position.

% Input:
% in: input image, m x n x k
% r: radius of the mask used to calculate the mean value to
%    be subtracted
% Output:
% out: output image

[m,n,k] = size(in);
out = in;

f = fspecial('disk',r);
for i = 1:k
    img = imfilter(in(:,:,i),f,'replicate');
    out(:,:,i) = in(:,:,i)-img;
end


end