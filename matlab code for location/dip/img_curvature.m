function [H, K, Lmax, Lmin, theta] = img_curvature( ...
    Dx, Dy, Dxx, Dxy, Dyy)
%% IMG_CURVATURE calculates the curvatures of images by using
% numerical derivatives directly.
% [H, K, Lmax, Lmin, theta] = img_curvature(Dx, Dy, Dxx, Dxy, Dyy)

% Input:
% Dx, Dy, Dxx, Dxy, Dyy: the first and second derivatives calculated
% by img_1st_derivative img_2nd_derivative

% Output:
% H: mean curvature
% K: Gaussian curvature
% Lmax: the largest curvature
% Lmin: the smallest curvature
% theta: the radian angle corresponding to the smallest curvature

d = sqrt(1+Dx.^2+Dy.^2);
H = ((1+Dx.^2).*Dyy + (1+Dy.^2).*Dxx - 2*Dx.*Dy.*Dxy )...
    ./(2*d.^3);
K = (Dxx.*Dyy-Dxy.^2)./d.^4;

% tmp = sqrt(H.^2-K);
tmp = (H.^2-K);
tmp(tmp<0) = 0;
tmp = sqrt(tmp);
tmp1 = H + tmp;
tmp2 = H - tmp;
idx = abs(tmp1) > abs(tmp2);
Lmax = tmp2;
Lmax(idx) = tmp1(idx);
Lmin = tmp1;
Lmin(idx) = tmp2(idx);

% lambda = - (Dxy./d - Lmin.*Dx.*Dy)./(Dyy./d - Lmin.*(1+ Dy.^2));
lambda = - (Dxy./d - Lmax.*Dx.*Dy)./(Dyy./d - Lmax.*(1+ Dy.^2));
theta = atan(lambda);
theta = theta + pi/2;
theta = theta - pi*floor(theta*2/pi);

end
