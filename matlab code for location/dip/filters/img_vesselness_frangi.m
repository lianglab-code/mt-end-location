function v = img_vesselness_frangi(imgs,varargin)
%% IMG_VESSELNESS_FRANGI calculates the Frangi vesselness of an
% input image. 
%
% Input:
% imgs: 2d image or time-series images
% s: scale
% Q: quantile
%
% Output:
% v: vesselness
%
% Note:
% The implementation here uses fixed scale.
%
% Reference:
% Multiscale vessel enhancement filtering.

% params
alpha = 0.5;
beta = 0.5;
c = 1;

s = 1;
if nargin>1
    s = varargin{1};
end

Q = 0.7;
if nargin>2
    Q = varargin{2};
end


[img_h, img_w, num_frame] = size(imgs);
[Dx,Dy] = img_1st_derivative(imgs,s);
[Dxx,Dxy,Dyy] = img_2nd_derivative(imgs,s);
[H,K,Lmax,Lmin,theta] = img_curvature(Dx,Dy,Dxx,Dxy,Dyy);

Rb = abs(Lmin./Lmax);
S = sqrt(Lmin.^2+Lmax.^2);

tmp = Rb(:,:,round(num_frame/2));
beta = quantile(tmp(:),Q);

tmp = S(:,:,round(num_frame/2));
c = quantile(tmp(:),Q);

v = exp(-Rb.^2/(2*beta^2)).*(1-exp(-S.^2/(2*c^2)));
