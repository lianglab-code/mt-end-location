function [H, K, Lmax, Lmin, theta] = img_curvature( ...
    Dx, Dy, Dxx, Dxy, Dyy)
%% IMG_CURVATURE calculates the curvatures of images by using
% numerical derivatives directly.
% [H, K, Lmax, Lmin, theta] = img_curvature_2(Dx, Dy, Dxx, Dxy, Dyy)
%
% Input:
% Dx, Dy, Dxx, Dxy, Dyy: the first and second derivatives calculated
% by img_1st_derivative img_2nd_derivative
%
% Output:
% H: mean curvature
% K: Gaussian curvature
% Lmax: the largest curvature
% Lmin: the smallest curvature
% theta: the radian angle corresponding to the smallest curvature
%
% Note:
% This function differs from img_curvature_old.m by directly
% calculating the eigenvalues and eigenvectors of the second
% fundamental form, instead of from mean and Gaussian curvatures.

% Notation Reference:
% Consistent computation of first- and second-order differential
% quantities for surface meshes

% Example:
% [X,Y] = meshgrid(1:300,1:300);
% tmp = 10000 - (Y-150).^2 - (X-150).^2;
% tmp(tmp<0) = 0;
% mt_img = sqrt(tmp);
% S = 1;
% [Dx,Dy] = img_1st_derivative(mt_img,S);
% [Dxx,Dxy,Dyy] = img_2nd_derivative(mt_img,S);

[d1,d2,d3] = size(Dx);

Dx = Dx(:);
Dy = Dy(:);
Dxx = Dxx(:);
Dxy = Dxy(:);
Dyy = Dyy(:);

l = sqrt(1+Dx.^2+Dy.^2);
% hess = [Dxx,Dxy;Dxy,Dyy];
tmp = sqrt((Dxx-Dyy).^2+4*Dxy.^2);
k1 = (Dxx+Dyy+tmp)/2;
k2 = (Dxx+Dyy-tmp)/2;
k = cat(2,k1,k2);
[~,ind] = max(abs(k),[],2);

Lmax = zeros(size(k1));
Lmin = zeros(size(k1));
theta = zeros(size(k1));
% for ii = 1:numel(k1);
%     Lmax(ii) = k(ii,ind(ii));
%     Lmin(ii) = k(ii,3-ind(ii));
% end
Lmax = k(sub2ind(size(k),(1:numel(k1))',ind));
Lmin = k(sub2ind(size(k),(1:numel(k1))',3-ind));

% hess = [a,b;b,c]
% (a-lambda)*x1 + b*x2 = 0
% % 1
% theta = atan((Lmax-Dxx)./Dxy);
% theta = theta + pi/2;
% theta = theta - pi*floor(theta*2/pi);
% 2
theta = atan(Dxy./(Dxx-Lmax));

H = (abs(Lmax)+abs(Lmin))/2;
K = abs(Lmax.*Lmin);

Lmax = Lmax./l;
Lmin = Lmin./l; 

Lmax = reshape(Lmax,[d1,d2,d3]);
Lmin = reshape(Lmin,[d1,d2,d3]);
theta = reshape(theta,[d1,d2,d3]);
H = reshape(H,[d1,d2,d3]);
K = reshape(K,[d1,d2,d3]);

end
