function [Dxx,Dxy,Dyy] = img_2nd_derivative(img,sigma)
%% IMG_2ND_DERIVATIVE calculates the second derivatives of an image.
% The image is first blurred by a gaussian.
% [Dxx,Dxy,Dyy] = img_2nd_derivative(img,sigma)

% Input
% img: input image, M*N*L
% sigma: sigma of the 2d gaussian
% Output
% | Dxx Dxy |
% | Dxy Dyy |

% code is adapted from FrangiFilter at MathWorks Center

%%%%%%% NOTE:
% gaussian in image analysis: (different that used in probability)
% g(x,y) = 1/(2*pi*sigma^2) * exp(-(x^2+y^2)/(2*sigma^2))
%%%%%%%%%%%%%

[M,N,L] = size(img);
% [X,Y] = ndgrid( -round(3*sigma) : round(3*sigma) );
[X,Y] = meshgrid( -round(3*sigma) : round(3*sigma) );
% % unnormalized
% gxx = 1/(2*pi*sigma^4) * (X.^2/sigma^2 - 1) .* exp(-(X.^2+Y.^2)/(2* ...
%                                                   sigma^2));
% gxy = 1/(2*pi*sigma^6) * (X.*Y) .* exp(-(X.^2+Y.^2)/(2*sigma^2));
% gyy = gxx';
% normalized by sigma^2
gxx = 1/(2*pi*sigma^2) * (X.^2/sigma^2 - 1) .* exp(-(X.^2+Y.^2)/(2* ...
                                                  sigma^2));
gxy = 1/(2*pi*sigma^4) * (X.*Y) .* exp(-(X.^2+Y.^2)/(2*sigma^2));
gyy = gxx';

Dxx = zeros(M,N,L);
Dxy = zeros(M,N,L);
Dyy = zeros(M,N,L);

for i = 1:L
    Dxx(:,:,i) = imfilter(img(:,:,i),gxx,'conv');
    Dxy(:,:,i) = imfilter(img(:,:,i),gxy,'conv');
    Dyy(:,:,i) = imfilter(img(:,:,i),gyy,'conv');
end

end
