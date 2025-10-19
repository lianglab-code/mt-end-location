function [Dx,Dy] = img_1st_derivative(img,sigma)
%% IMG_1ST_DERIVATIVE calculates the second derivatives of an image.
% The image is first blurred by a gaussian.
% [Dx,Dy] = img_1st_derivative(img,sigma)
% 
% Input
% img: input image, M*N*L
% sigma: sigma of the 2d gaussian
%
% Output
% | Dx Dy |
%
% Note:
% The output Dx, Dy have all been normalized, e.g., 
% multiplied by sigma
%
% code is adapted from FrangiFilter at MathWorks Center
% 
%%%%%%% NOTE:
% gaussian in image analysis: (different that used in probability)
% g(x,y) = 1/(2*pi*sigma^2) * exp(-(x^2+y^2)/(2*sigma^2))
%%%%%%%%%%%%%

[M,N,L] = size(img);
% [X,Y] = ndgrid( -round(3*sigma) : round(3*sigma) );
[X,Y] = meshgrid( -round(3*sigma) : round(3*sigma) );
% % unnormalized
% gx = -X/(2*pi*sigma^4) .* exp(-(X.^2+Y.^2)/(2*sigma^2));
% gy = gx';
% normalized by sigma
gx = -X/(2*pi*sigma^3) .* exp(-(X.^2+Y.^2)/(2*sigma^2));
gy = gx';

Dx = zeros(M,N,L);
Dy = zeros(M,N,L);

for i = 1:L
    Dx(:,:,i) = imfilter(img(:,:,i),gx,'conv');
    Dy(:,:,i) = imfilter(img(:,:,i),gy,'conv');
end

end
